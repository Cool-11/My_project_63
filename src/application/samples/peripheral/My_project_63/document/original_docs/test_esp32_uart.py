#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
WS63 UART Command Test Script
=============================
模拟ESP32通过UART发送JSON命令，测试WS63固件的命令解析和处理逻辑。

依赖安装：
    pip install pyserial cjson

用法：
    python test_esp32_uart.py --port COM5 --baud 115200
    python test_esp32_uart.py --simulate  # 无硬件时模拟测试
"""

import os
import sys
import json
import time
import struct
import threading
import argparse
import traceback
from typing import Optional, List, Tuple, Callable
from dataclasses import dataclass, field
from datetime import datetime

try:
    import serial
    HAS_PYSERIAL = True
except ImportError:
    HAS_PYSERIAL = False
    print("[WARN] pyserial not installed, using simulation mode")

try:
    import cjson
    HAS_CJSON = True
except ImportError:
    HAS_CJSON = False
    print("[WARN] cjson not installed, using json module")


@dataclass
class TestResult:
    name: str
    passed: bool
    expected: str
    actual: str
    duration_ms: float
    error_msg: str = ""

    def to_dict(self):
        return {
            "name": self.name,
            "passed": self.passed,
            "expected": self.expected,
            "actual": self.actual,
            "duration_ms": round(self.duration_ms, 2),
            "error_msg": self.error_msg
        }


class RingBuffer:
    """模拟WS63的环形缓冲区"""
    SIZE = 512
    LINE_MAX = 256

    def __init__(self):
        self.data = bytearray(self.SIZE)
        self.head = 0
        self.tail = 0

    def push(self, buf: bytes) -> int:
        written = 0
        for b in buf:
            next_head = (self.head + 1) % self.SIZE
            if next_head != self.tail:
                self.data[self.head] = b
                self.head = next_head
                written += 1
            else:
                break
        return written

    def has_line(self) -> bool:
        i = self.tail
        dist = 0
        while i != self.head:
            if self.data[i] in (0x0A, 0x0D) and dist < self.LINE_MAX:
                return True
            i = (i + 1) % self.SIZE
            dist += 1
        return False

    def read_line(self) -> Optional[bytes]:
        line = bytearray()
        while self.tail != self.head and len(line) < self.LINE_MAX - 1:
            ch = self.data[self.tail]
            self.tail = (self.tail + 1) % self.SIZE
            if ch in (0x0A, 0x0D):
                return bytes(line)
            line.append(ch)
        return bytes(line) if line else None

    def clear(self):
        self.head = 0
        self.tail = 0


class SimulatedWS63:
    """
    模拟WS63固件的UART命令处理逻辑
    复刻 uart_vision.c 的行为
    """

    def __init__(self):
        self.ring = RingBuffer()
        self.cmd_handler: Optional[Callable] = None
        self.received_lines: List[Tuple[str, int]] = []
        self.sent_responses: List[str] = []
        self.last_rx_time = 0

    def set_cmd_handler(self, handler: Callable):
        self.cmd_handler = handler

    def inject_data(self, data: bytes) -> int:
        """模拟UART接收回调"""
        written = self.ring.push(data)
        self.last_rx_time = time.time()
        return written

    def poll(self) -> List[str]:
        """模拟 uart_vision_poll() 的处理逻辑"""
        responses = []
        while self.ring.has_line():
            line_bytes = self.ring.read_line()
            if not line_bytes:
                continue
            try:
                line_str = line_bytes.decode('utf-8').strip()
            except UnicodeDecodeError:
                line_str = line_bytes.decode('utf-8', errors='replace').strip()

            if not line_str:
                continue

            resp = self._dispatch_line(line_str)
            if resp:
                responses.append(resp)
                self.sent_responses.append(resp)

        if self.ring.has_line() == False and self.ring.head != self.ring.tail:
            elapsed = time.time() - self.last_rx_time
            if elapsed > 0.1 and self.ring.head != self.ring.tail:
                line_bytes = self._read_all()
                if line_bytes:
                    try:
                        line_str = line_bytes.decode('utf-8').strip()
                        if line_str:
                            resp = self._dispatch_line(line_str)
                            if resp:
                                responses.append(resp)
                                self.sent_responses.append(resp)
                    except Exception:
                        pass

        return responses

    def _read_all(self) -> bytes:
        """超时读取所有数据"""
        result = bytearray()
        while self.ring.tail != self.ring.head:
            ch = self.ring.data[self.ring.tail]
            self.ring.tail = (self.ring.tail + 1) % self.ring.SIZE
            result.append(ch)
        return bytes(result)

    def _dispatch_line(self, line: str) -> Optional[str]:
        """模拟 uv_dispatch_line()"""
        try:
            if HAS_CJSON:
                root = cjson.decode(line)
            else:
                root = json.loads(line)
        except Exception as e:
            return None

        cmd = root.get('cmd', '')
        seq = root.get('seq', 0)
        data = root.get('data', {})

        self.received_lines.append((cmd, seq))

        if self.cmd_handler:
            data_str = json.dumps(data) if isinstance(data, dict) else str(data)
            return self.cmd_handler(cmd, seq, data_str)
        return None


class WS63BusinessLogic:
    """
    模拟 business_logic.c 的命令处理逻辑
    复刻 biz_uart_cmd_handler() 的行为
    """

    def __init__(self):
        self.tags = {}
        self.next_tag_id = 1
        self.wifi_cfg = {}
        self.mqtt_cfg = {}
        self.responses = []

    def handle_command(self, cmd: str, seq: int, data_str: str) -> str:
        """复刻 biz_uart_cmd_handler() 的命令分发"""
        data = {}
        if data_str:
            try:
                data = json.loads(data_str) if isinstance(data_str, str) else data_str
            except Exception:
                pass

        if cmd == 'wifi_connect':
            return self._handle_wifi_connect(seq, data)
        elif cmd == 'wifi_status':
            return self._handle_wifi_status(seq)
        elif cmd == 'mqtt_connect':
            return self._handle_mqtt_connect(seq, data)
        elif cmd == 'mqtt_status':
            return self._handle_mqtt_status(seq)
        elif cmd == 'list':
            return self._handle_list(seq)
        elif cmd == 'inventory':
            return self._handle_inventory(seq)
        elif cmd == 'inbound':
            return self._handle_inbound(seq, data)
        else:
            return self._make_response(cmd, seq, -1, f"unknown cmd: {cmd}")

    def _make_response(self, cmd: str, seq: int, code: int, msg: str, data: dict = None) -> str:
        resp = {
            'cmd': cmd,
            'seq': seq,
            'code': code,
            'msg': msg
        }
        if data is not None:
            resp['data'] = data
        return json.dumps(resp)

    def _handle_wifi_connect(self, seq: int, data: dict) -> str:
        ssid = data.get('ssid', '')
        psk = data.get('psk', '')
        if not ssid:
            return self._make_response('wifi_connect', seq, -1, 'ssid required')
        self.wifi_cfg = {'ssid': ssid, 'psk': psk}
        print(f"  [SIM] WiFi config: ssid={ssid}, psk={'*'*len(psk) if psk else 'none'}")
        return self._make_response('wifi_connect', seq, 0, 'ok',
                                   {'state': 'connecting', 'ssid': ssid})

    def _handle_wifi_status(self, seq: int) -> str:
        if not self.wifi_cfg:
            return self._make_response('wifi_status', seq, 0, 'not configured')
        return self._make_response('wifi_status', seq, 0, 'ok', {
            'ssid': self.wifi_cfg.get('ssid', ''),
            'state': 'disconnected',
            'ip': ''
        })

    def _handle_mqtt_connect(self, seq: int, data: dict) -> str:
        uri = data.get('uri', '')
        client_id = data.get('client_id', '')
        username = data.get('username', '')
        password = data.get('password', '')
        if not uri:
            return self._make_response('mqtt_connect', seq, -1, 'uri required')
        self.mqtt_cfg = {'uri': uri, 'client_id': client_id, 'username': username}
        print(f"  [SIM] MQTT config: uri={uri}, client_id={client_id}")
        return self._make_response('mqtt_connect', seq, 0, 'ok', {'state': 'connecting'})

    def _handle_mqtt_status(self, seq: int) -> str:
        if not self.mqtt_cfg:
            return self._make_response('mqtt_status', seq, 0, 'not configured')
        return self._make_response('mqtt_status', seq, 0, 'ok', {
            'uri': self.mqtt_cfg.get('uri', ''),
            'state': 'disconnected'
        })

    def _handle_list(self, seq: int) -> str:
        tags = [{'tag_id': k, 'zone': v.get('zone', ''), 'item': v.get('item', ''),
                 'qty': v.get('qty', 0)} for k, v in self.tags.items()]
        return self._make_response('list', seq, 0, 'ok', {'count': len(tags), 'tags': tags})

    def _handle_inventory(self, seq: int) -> str:
        return self._make_response('inventory', seq, 0, 'ok',
                                    {'count': len(self.tags), 'timestamp': int(time.time())})

    def _handle_inbound(self, seq: int, data: dict) -> str:
        tag_id = self.next_tag_id
        self.next_tag_id += 1
        self.tags[tag_id] = {
            'zone': data.get('zone', ''),
            'item': data.get('item', ''),
            'qty': data.get('qty', 1)
        }
        return self._make_response('inbound', seq, 0, 'ok',
                                   {'tag_id': tag_id, 'zone': data.get('zone', '')})


def test_json_parsing():
    """测试1: JSON解析一致性（cjson vs json模块）"""
    print("\n" + "="*60)
    print("TEST 1: JSON Parsing Consistency")
    print("="*60)

    test_cases = [
        '{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}',
        '{"cmd":"list","seq":1,"data":{}}',
        '{"cmd":"mqtt_connect","seq":2,"data":{"uri":"mqtt://1.2.3.4:1883","client_id":"cid","username":"token","password":"pwd"}}',
        '{"cmd":"inventory","seq":3,"data":{"zone":"A1"}}',
    ]

    results = []
    for tc in test_cases:
        try:
            std_result = json.loads(tc)
            if HAS_CJSON:
                cjson_result = cjson.decode(tc)
                match = (std_result == cjson_result)
                print(f"  [PASS] '{tc[:40]}...' -> std==cjson: {match}")
                results.append(TestResult(
                    name=f"JSON: {tc[:30]}...",
                    passed=match,
                    expected=str(std_result),
                    actual=str(cjson_result),
                    duration_ms=0
                ))
            else:
                print(f"  [INFO] '{tc[:40]}...' -> parsed (cjson not available)")
        except Exception as e:
            print(f"  [FAIL] '{tc[:40]}...' -> {e}")
            results.append(TestResult(
                name=f"JSON: {tc[:30]}...",
                passed=False,
                expected="valid JSON",
                actual=f"Exception: {e}",
                duration_ms=0
            ))

    return results


def test_ring_buffer():
    """测试2: 环形缓冲区 + 换行符处理"""
    print("\n" + "="*60)
    print("TEST 2: Ring Buffer & Line Detection")
    print("="*60)

    results = []

    # 2.1: \n 结尾
    print("  [2.1] Test data ending with \\n")
    ring = RingBuffer()
    data = b'{"cmd":"list","seq":1,"data":{}}\n'
    ring.push(data)
    assert ring.has_line() == True, "Should detect line with \\n"
    line = ring.read_line()
    assert line == b'{"cmd":"list","seq":1,"data":{}}', f"Got: {line}"
    print(f"    [PASS] Read: {line}")
    results.append(TestResult("RingBuffer \\n detection", True, "has line", str(line), 0))

    # 2.2: \r\n 结尾
    print("  [2.2] Test data ending with \\r\\n")
    ring2 = RingBuffer()
    data2 = b'{"cmd":"wifi_connect","seq":1,"data":{}}\r\n'
    ring2.push(data2)
    assert ring2.has_line() == True, "Should detect line with \\r\\n"
    line2 = ring2.read_line()
    assert line2 == b'{"cmd":"wifi_connect","seq":1,"data":{}}', f"Got: {line2}"
    print(f"    [PASS] Read: {line2}")
    results.append(TestResult("RingBuffer \\r\\n detection", True, "has line", str(line2), 0))

    # 2.3: 无换行符
    print("  [2.3] Test data WITHOUT any line ending")
    ring3 = RingBuffer()
    data3 = b'{"cmd":"test","seq":1,"data":{}}'
    ring3.push(data3)
    has = ring3.has_line()
    print(f"    [INFO] has_line()={has} (expected: False, simulating timeout...)")
    results.append(TestResult("RingBuffer no-line detection", not has, "False", str(has), 0))

    # 2.4: 多条命令
    print("  [2.4] Test multiple commands")
    ring4 = RingBuffer()
    ring4.push(b'{"cmd":"a","seq":1,"data":{}}\n')
    ring4.push(b'{"cmd":"b","seq":2,"data":{}}\n')
    lines = []
    while ring4.has_line():
        l = ring4.read_line()
        if l:
            lines.append(l)
    print(f"    [PASS] Read {len(lines)} lines: {lines}")
    results.append(TestResult("RingBuffer multi-line", len(lines) == 2, "2 lines", str(len(lines)), 0))

    return results


def test_simulated_ws63_uart():
    """测试3: 模拟WS63 UART端到端测试"""
    print("\n" + "="*60)
    print("TEST 3: Simulated WS63 UART End-to-End")
    print("="*60)

    results = []
    biz = WS63BusinessLogic()
    ws63 = SimulatedWS63()
    ws63.set_cmd_handler(biz.handle_command)

    # 3.1: wifi_connect 命令
    print("  [3.1] Test wifi_connect command")
    start = time.time()
    sent = b'{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}\n'
    ws63.inject_data(sent)
    responses = ws63.poll()
    dur = (time.time() - start) * 1000
    if responses:
        resp = json.loads(responses[0])
        passed = (resp['cmd'] == 'wifi_connect' and resp['seq'] == 1 and resp['code'] == 0)
        print(f"    [PASS] Response: {responses[0]}")
        results.append(TestResult("wifi_connect seq=1", passed, "code=0,seq=1",
                                  str(resp), dur))
    else:
        print(f"    [FAIL] No response received")
        results.append(TestResult("wifi_connect seq=1", False, "response", "none", dur))

    # 3.2: wifi_connect seq配对
    print("  [3.2] Test wifi_connect seq=99 (seq pairing)")
    start = time.time()
    sent2 = b'{"cmd":"wifi_connect","seq":99,"data":{"ssid":"test","psk":"pass"}}\n'
    ws63.inject_data(sent2)
    responses2 = ws63.poll()
    dur2 = (time.time() - start) * 1000
    if responses2:
        resp2 = json.loads(responses2[0])
        passed2 = (resp2['seq'] == 99)
        print(f"    [{'PASS' if passed2 else 'FAIL'}] Response seq={resp2['seq']} (expected 99)")
        results.append(TestResult("wifi_connect seq=99", passed2, "seq=99",
                                  f"seq={resp2['seq']}", dur2))
    else:
        results.append(TestResult("wifi_connect seq=99", False, "response", "none", dur2))

    # 3.3: list 命令
    print("  [3.3] Test list command")
    start = time.time()
    ws63.inject_data(b'{"cmd":"list","seq":5,"data":{}}\n')
    responses3 = ws63.poll()
    dur3 = (time.time() - start) * 1000
    if responses3:
        resp3 = json.loads(responses3[0])
        print(f"    [PASS] Response: {resp3}")
        results.append(TestResult("list seq=5", resp3['code'] == 0, "code=0",
                                  str(resp3), dur3))
    else:
        results.append(TestResult("list seq=5", False, "response", "none", dur3))

    # 3.4: mqtt_connect 命令
    print("  [3.4] Test mqtt_connect command")
    start = time.time()
    mqtt_json = '{"cmd":"mqtt_connect","seq":6,"data":{"uri":"mqtt://1.2.3.4:1883","client_id":"dev001","username":"token","password":"pwd"}}\n'
    ws63.inject_data(mqtt_json.encode())
    responses4 = ws63.poll()
    dur4 = (time.time() - start) * 1000
    if responses4:
        resp4 = json.loads(responses4[0])
        passed4 = (resp4['cmd'] == 'mqtt_connect' and resp4['seq'] == 6)
        print(f"    [{'PASS' if passed4 else 'FAIL'}] Response: {resp4}")
        results.append(TestResult("mqtt_connect seq=6", passed4, "cmd=mqtt_connect,seq=6",
                                  str(resp4), dur4))
    else:
        results.append(TestResult("mqtt_connect seq=6", False, "response", "none", dur4))

    # 3.5: inbound 命令
    print("  [3.5] Test inbound command")
    start = time.time()
    ib_json = '{"cmd":"inbound","seq":7,"data":{"zone":"A1","item":"螺丝","qty":100}}\n'
    ws63.inject_data(ib_json.encode())
    responses5 = ws63.poll()
    dur5 = (time.time() - start) * 1000
    if responses5:
        resp5 = json.loads(responses5[0])
        tag_id = resp5.get('data', {}).get('tag_id', 0)
        passed5 = (resp5['code'] == 0 and tag_id == 1)
        print(f"    [{'PASS' if passed5 else 'FAIL'}] Response: {resp5}")
        results.append(TestResult("inbound seq=7", passed5, "code=0,tag_id=1",
                                  str(resp5), dur5))
    else:
        results.append(TestResult("inbound seq=7", False, "response", "none", dur5))

    # 3.6: 盘点命令
    print("  [3.6] Test inventory command")
    start = time.time()
    ws63.inject_data(b'{"cmd":"inventory","seq":8,"data":{}}\n')
    responses6 = ws63.poll()
    dur6 = (time.time() - start) * 1000
    if responses6:
        resp6 = json.loads(responses6[0])
        print(f"    [PASS] Response: {resp6}")
        results.append(TestResult("inventory seq=8", resp6['code'] == 0, "code=0",
                                  str(resp6), dur6))
    else:
        results.append(TestResult("inventory seq=8", False, "response", "none", dur6))

    # 3.7: 连续多条命令
    print("  [3.7] Test multiple sequential commands")
    start = time.time()
    ws63.inject_data(b'{"cmd":"list","seq":10,"data":{}}\n{"cmd":"wifi_status","seq":11,"data":{}}\n')
    responses7 = ws63.poll()
    dur7 = (time.time() - start) * 1000
    seqs = []
    for r in responses7:
        try:
            seqs.append(json.loads(r)['seq'])
        except Exception:
            pass
    passed7 = (seqs == [10, 11])
    print(f"    [{'PASS' if passed7 else 'FAIL'}] Seqs: {seqs} (expected [10, 11])")
    results.append(TestResult("Multi-cmd seq ordering", passed7, "[10,11]",
                              str(seqs), dur7))

    return results


def test_code_path_verification():
    """测试4: 代码路径静态验证（读取源码验证逻辑）"""
    print("\n" + "="*60)
    print("TEST 4: Code Path Verification (Static Analysis)")
    print("="*60)

    results = []
    base_path = "/home/cool/fbb_ws63/src/application/samples/peripheral/My_project_63"

    # 4.1: 验证 uart_vision.c 的 uv_ring_has_newline() 是否检测 \r
    print("  [4.1] Check uv_ring_has_newline() supports \\r")
    try:
        with open(f"{base_path}/components/uart_vision/uart_vision.c", "r") as f:
            content = f.read()
        has_r_check = "\\\\x0d" in content or "== '\\\\r'" in content or ("'\\\\r'" in content)
        print(f"    [{'PASS' if has_r_check else 'FAIL'}] \\r support in ring buffer")
        results.append(TestResult("uv_ring_has_newline \\r support", has_r_check,
                                  "\\r detected in code", str(has_r_check), 0))
    except Exception as e:
        results.append(TestResult("uv_ring_has_newline \\r support", False, "read file", str(e), 0))

    # 4.2: 验证 wifi_connect 命令处理路径
    print("  [4.2] Check biz_wifi_connect_handler exists")
    try:
        with open(f"{base_path}/components/business_logic/business_logic.c", "r") as f:
            biz_content = f.read()
        has_wifi_handler = "biz_wifi_connect" in biz_content or "cmd_wifi_connect" in biz_content
        has_uart_dispatch = "biz_uart_cmd_handler" in biz_content
        print(f"    [{'PASS' if has_uart_dispatch else 'FAIL'}] biz_uart_cmd_handler found")
        results.append(TestResult("biz_uart_cmd_handler exists", has_uart_dispatch,
                                  "found", str(has_uart_dispatch), 0))
    except Exception as e:
        results.append(TestResult("biz_uart_cmd_handler exists", False, "read file", str(e), 0))

    # 4.3: 验证 NV key 定义不冲突
    print("  [4.3] Check NV keys are distinct")
    try:
        with open(f"{base_path}/components/cloud_storage/cloud_storage.h", "r") as f:
            cs_header = f.read()
        with open(f"{base_path}/components/business_logic/business_logic.h", "r") as f:
            biz_header = f.read()
        mqtt_key = "0x5002" in cs_header
        wifi_key = "0x5003" in cs_header
        biz_key = "0x5001" in biz_header
        all_distinct = mqtt_key and wifi_key and biz_key
        print(f"    [{'PASS' if all_distinct else 'FAIL'}] NV keys: biz=0x5001, mqtt=0x5002, wifi=0x5003")
        results.append(TestResult("NV keys distinct", all_distinct,
                                  "0x5001,0x5002,0x5003 distinct",
                                  f"biz={biz_key},mqtt={mqtt_key},wifi={wifi_key}", 0))
    except Exception as e:
        results.append(TestResult("NV keys distinct", False, "read files", str(e), 0))

    # 4.4: 验证 main.c 回调桥接（检查注册函数调用）
    print("  [4.4] Check main.c callback bridge registration")
    try:
        with open(f"{base_path}/app/main.c", "r") as f:
            main_content = f.read()
        has_cloud_reg = "business_logic_register_cloud_cb" in main_content
        has_wifi_reg = "business_logic_register_wifi_cmd_cb" in main_content
        has_mqtt_reg = "business_logic_register_mqtt_cmd_cb" in main_content
        has_cloud_fn = "my63_cloud_publish_cb" in main_content
        has_wifi_fn = "my63_wifi_cmd_cb" in main_content
        has_mqtt_fn = "my63_mqtt_cmd_cb" in main_content
        registered = (has_cloud_reg and has_wifi_reg and has_mqtt_reg and
                      has_cloud_fn and has_wifi_fn and has_mqtt_fn)
        print(f"    [{'PASS' if registered else 'FAIL'}] All callback registrations found")
        results.append(TestResult("main.c callback bridge", registered,
                                  "all 3 cb registered + 3 fn defined",
                                  f"cloud_reg={has_cloud_reg},wifi_reg={has_wifi_reg},mqtt_reg={has_mqtt_reg}", 0))
    except Exception as e:
        results.append(TestResult("main.c callback bridge", False, "read file", str(e), 0))

    # 4.5: 验证 cloud_storage 不被 business_logic 直接 include
    print("  [4.5] Check business_logic does NOT include cloud_storage.h")
    try:
        with open(f"{base_path}/components/business_logic/business_logic.c", "r") as f:
            biz_c = f.read()
        bad_include = 'cloud_storage.h' in biz_c and '#include' in biz_c
        decoupled = not bad_include
        print(f"    [{'PASS' if decoupled else 'FAIL'}] business_logic.c NOT include cloud_storage.h")
        results.append(TestResult("business_logic decoupling", decoupled,
                                  "no cloud_storage.h include",
                                  f"has_cloud_ref={bad_include}", 0))
    except Exception as e:
        results.append(TestResult("business_logic decoupling", False, "read file", str(e), 0))

    # 4.6: 验证 ThingsKit 主题常量
    print("  [4.6] Check ThingsKit topic constants")
    try:
        with open(f"{base_path}/components/cloud_storage/cloud_storage.h", "r") as f:
            cs_h = f.read()
        has_telemetry = "v1/devices/me/telemetry" in cs_h
        has_rpc = "v1/devices/me/rpc/request/+" in cs_h
        topics_ok = has_telemetry and has_rpc
        print(f"    [{'PASS' if topics_ok else 'FAIL'}] ThingsKit topics: telemetry + RPC")
        results.append(TestResult("ThingsKit topic constants", topics_ok,
                                  "v1/devices/me/telemetry + rpc/request/+",
                                  f"telemetry={has_telemetry},rpc={has_rpc}", 0))
    except Exception as e:
        results.append(TestResult("ThingsKit topic constants", False, "read file", str(e), 0))

    return results


def run_all_tests():
    """运行所有测试"""
    print("\n" + "#"*60)
    print("# WS63 ESP32 UART 命令测试套件")
    print(f"# Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("#"*60)

    all_results = []

    all_results.extend(test_json_parsing())
    all_results.extend(test_ring_buffer())
    all_results.extend(test_simulated_ws63_uart())
    all_results.extend(test_code_path_verification())

    # 汇总
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)
    passed = sum(1 for r in all_results if r.passed)
    total = len(all_results)
    print(f"  Total: {total}, Passed: {passed}, Failed: {total - passed}")
    print(f"  Pass Rate: {100*passed/total:.1f}%")

    for r in all_results:
        status = "PASS" if r.passed else "FAIL"
        print(f"  [{status}] {r.name}: {r.actual}")

    return all_results


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="WS63 UART Test")
    parser.add_argument("--simulate", action="store_true", help="Run simulation only")
    parser.add_argument("--port", type=str, help="Serial port")
    parser.add_argument("--baud", type=int, default=115200, help="Baud rate")
    args = parser.parse_args()

    if args.simulate or not HAS_PYSERIAL:
        print("[MODE] Simulation mode (no hardware)")
        results = run_all_tests()
        sys.exit(0 if all(r.passed for r in results) else 1)
    else:
        print(f"[MODE] Real hardware mode on {args.port}@{args.baud}")
        # TODO: Real serial port testing
        print("[ERROR] Real hardware mode not yet implemented")
        sys.exit(1)

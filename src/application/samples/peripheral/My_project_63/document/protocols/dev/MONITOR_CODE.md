# 淘晶驰 T1 串口屏 — 端侧代码汇总

> **工程**: 星闪双模资产盘点系统  
> **型号**: TJC T1系列 4.3寸 480*272  
> **波特率**: 115200bps, 8N1  
> **协议文档**: `PROTOCOL/WS63_MONITOR_PROTOCOL.md`  
> **最后更新**: 2026-05-27

---

## 控件命名规范

| 页面 | Tag ID | 状态 | vscope | 用户输入 | 资产列表 |
|:--:|--------|------|:--:|------|------|
| page1 in | t01 | t11 | **global** | t1/t2/t3 (local) | — |
| page2 out | t02 | t21 | **global** | t6 (local) | — |
| page3 check | t03 | t31 | **global** | t0 输入 (local) | — |
| page4 find | — | t41 | global | — | t0-t5 (local, 不弹键盘) |
| page5 setting | — | t51 | global | t3/t0 (local) | — |

> **规则**: 弹键盘的页面的 Tag ID 和状态控件必须设 `vscope=global`，否则键盘返回时控件值丢失。

---

## 目录

1. [program.s — 全局初始化](#1-programs--全局初始化)
2. [Page0 menu — 主菜单](#2-page0-menu--主菜单)
3. [Page1 in — 入库](#3-page1-in--入库)
4. [Page2 out — 出库](#4-page2-out--出库)
5. [Page3 check — 盘点](#5-page3-check--盘点)
6. [Page4 find — 资产查找](#6-page4-find--资产查找)
7. [Page5 setting — 设置](#7-page5-setting--设置)
8. [Page6 msg — 消息](#8-page6-msg--消息)
9. [注意事项](#9-注意事项)

---

## 1. program.s — 全局初始化

```c
// ===== 星闪双模资产盘点系统 =====
// 全局变量（有符号32位 int）
int sys0=0,sys1=0,sys2=0,sys3=0,sys4=0,sys5=0
int getFrameFlag,frameLength,cmdLen

// 亮度
dim=100

// 波特率 (与WS63 UART一致)
baud=115200

// 开启主动解析模式
recmod=1

// 启动时显示menu页
page 0
```

| 变量 | 用途 |
|------|------|
| `sys0` | 各页面状态机 |
| `sys1, sys2` | 解析临时变量（定时器内用） |
| `sys3` | page4 当前页码 |
| `sys4` | page4 总页数 |
| `sys5` | page4 选中slot（0-5=选中, 99=未选） |
| `getFrameFlag` | 帧查找状态（0=找帧头, 1=找帧尾, 2=找到完整帧） |
| `frameLength` | 完整帧总长度（含\r\n） |
| `cmdLen` | 数据部分长度（不含\r\n） |

---

## 2. Page0 menu — 主菜单

### 控件

| 控件 | 类型 | 用途 |
|------|------|------|
| b0 | Button | 入库 → page1 |
| b1 | Button | 出库 → page2 |
| b2 | Button | 盘点 → page3 |
| b3 | Button | 查找 → page4 |
| b4 | Button | 设置 → page5 |
| b5 | Button | 消息 → page6 |
| tm0 | Timer | 串口解析，tim=50, en=1 |

### tm0 定时器

```c
// ---- menu页定时器: 清理非#开头的数据 ----
if(usize>0)
{
  if(u[0]!=0x23)
  {
    udelete 1
  }else if(usize>=3)
  {
    for(sys0=1;sys0<usize;sys0++)
    {
      if(u[sys0]==0x0d&&u[sys0+1]==0x0a)
      {
        udelete sys0+2
        sys0=usize+1
      }
    }
  }
}
```

### 按钮事件

```c
// b0: 入库
page 1

// b1: 出库
page 2

// b2: 盘点
page 3

// b3: 查找
page 4

// b4: 设置
page 5

// b5: 消息
page 6
```

---

## 3. Page1 in — 入库

### 控件清单

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t01 | Text | Tag ID（只读） | `txt="tag_id"`, **vscope=global** |
| t1 | Text | 数量 count | `txt="count"`, `key=1`, vscope=local |
| t2 | Text | 存放区域 area | `txt="area"`, `key=1`, vscope=local |
| t3 | Text | 物品名称 name | `txt="name"`, `key=1`, vscope=local |
| t4 | Text | 拍摄步骤 | `txt=""`, vscope=local |
| t11 | Text | 状态栏 | `txt="请按匹配按钮扫描标签"`, **vscope=global** |
| va0 | Variable(字符串) | 帧缓冲区 | `txt_maxl=200` |
| c0 | Dual-state | 覆写开关 | mode=0, txt="覆写" |
| c1 | Dual-state | 更新验证开关 | mode=0, txt="更新" |
| b0 | Button | 开始匹配标签 | |
| b1 | Button | 发送信息+启动摄像头 | |
| b3 | Button | 返回menu | |
| b4 | Button | 拍正面 | |
| b5 | Button | 拍侧面 | |
| b6 | Button | 拍顶部 | |
| b7 | Button | 确认入库 | |
| m0 | Hotspot | 帧解析入口 | |
| tm1 | Timer | 串口解析 | `tim=50`, `en=1` |

### tm1 定时器

```c
// ===== 查找帧头 '#' (0x23) =====
while(usize>=3&&getFrameFlag==0)
{
  if(u[0]==0x23)
  {
    getFrameFlag=1
  }else
  {
    udelete 1
  }
}

// ===== 查找帧尾 \r\n =====
if(getFrameFlag==1)
{
  sys1=1
  sys2=usize
  sys2=sys2-1
  while(sys1<sys2)
  {
    if(u[sys1]==0x0d)
    {
      if(u[sys1+1]==0x0a)
      {
        frameLength=sys1+2
        cmdLen=sys1
        getFrameFlag=2
        sys1=sys2
      }
    }
    sys1=sys1+1
  }
}

// ===== 提取完整帧 =====
if(getFrameFlag==2)
{
  ucopy va0.txt,0,cmdLen,0
  udelete frameLength
  click m0,1
  getFrameFlag=0
}
```

### m0 按下事件（帧解析）

```c
// ===== 提取CMD到 t11 做临时 =====
spstr va0.txt,t11.txt,",",0

// === #VERIFY,tag_id,name,area,current_qty ===
if(t11.txt=="#VERIFY")
{
  spstr va0.txt,t01.txt,",",1
  spstr va0.txt,t3.txt,",",2       // t3 = 旧名称
  spstr va0.txt,t2.txt,",",3       // t2 = 旧区域
  spstr va0.txt,t11.txt,",",4      // t11临时=当前库存
  t11.txt="当前库存:"+t11.txt+" 此标签已存在! 请选择模式并填写新增数量"
  t1.txt="count"
  t4.txt=""
  sys0=5
}

// === #TAG,tag_id ===
if(t11.txt=="#TAG")
{
  spstr va0.txt,t01.txt,",",1
  t11.txt="Tag ID: "+t01.txt+" 已获取,请填写物品信息"
  sys0=1
}

// === #PROG,step,view,score ===
if(t11.txt=="#PROG")
{
  spstr va0.txt,t4.txt,",",1       // t4 = step (临时)
  spstr va0.txt,t11.txt,",",2      // t11 = view (临时)
  t4.txt="拍摄: "+t4.txt+"/3 "+t11.txt
  spstr va0.txt,t11.txt,",",3      // t11 = score
  t11.txt="清晰度评分: "+t11.txt
  sys0=3
}

// === #DONE,reg,result,tag_id ===
if(t11.txt=="#DONE")
{
  spstr va0.txt,t11.txt,",",2
  if(t11.txt=="success")
  {
    t11.txt="入库成功! 可按确认"
    sys0=4
  }else if(t11.txt=="success_updated")
  {
    t11.txt="验证通过,数量已累加! 可按确认"
    sys0=4
  }else
  {
    t11.txt="入库失败,请重试"
  }
}

// === #ERR,code,msg ===
if(t11.txt=="#ERR")
{
  spstr va0.txt,t11.txt,",",2
}

// === #MSG,text ===
if(t11.txt=="#MSG")
{
  spstr va0.txt,t11.txt,",",1
}
```

### t1/t2/t3 按下事件

```c
// t1 按下
if(t1.txt=="count")
{
  t1.txt=""
}

// t2 按下
if(t2.txt=="area")
{
  t2.txt=""
}

// t3 按下
if(t3.txt=="name")
{
  t3.txt=""
}
```

### c0 按下事件（互斥）

```c
c1.val=0
```

### c1 按下事件（互斥）

```c
c0.val=0
```

### 按钮事件

```c
// ===== b0: 开始匹配标签 =====
prints "@in,start",0
printh 0d 0a
t11.txt="正在扫描最近标签..."
t01.txt=""
t1.txt="count"
t2.txt="area"
t3.txt="name"
t4.txt=""
c0.val=0
c1.val=0
sys0=0
getFrameFlag=0


// ===== b1: 发送信息+启动摄像头 =====
// 预先计算 sys2=1 表示新注册或覆写模式
sys2=0
if(sys0==1)
{
  sys2=1
}
if(sys0==5)
{
  if(c0.val==1)
  {
    sys2=1
  }
}

// 未选择模式
if(sys0==5&&c0.val==0&&c1.val==0)
{
  t11.txt="请选择覆写或更新验证模式"

// 更新验证模式 (sys0==5, c1=1)
}else if(sys0==5&&c1.val==1)
{
  if(t1.txt=="count"||t1.txt=="")
  {
    t11.txt="请填写新增数量"
  }else
  {
    prints "@in,capture,",0
    prints t01.txt,0
    prints ",",0
    prints t1.txt,0
    prints ",",0
    prints t2.txt,0
    prints ",",0
    prints t3.txt,0
    prints ",2",0
    printh 0d 0a
    t11.txt="更新验证模式: 仅需正面,等待摄像头..."
    t4.txt=""
    sys0=2
  }

// 新注册 或 覆写 (sys2=1)
}else if(sys2==1)
{
  if(t1.txt=="count"||t1.txt=="")
  {
    t11.txt="请填写数量"
  }else if(t2.txt=="area"||t2.txt=="")
  {
    t11.txt="请填写存放区域"
  }else if(t3.txt=="name"||t3.txt=="")
  {
    t11.txt="请填写物品名称"
  }else
  {
    prints "@in,capture,",0
    prints t01.txt,0
    prints ",",0
    prints t1.txt,0
    prints ",",0
    prints t2.txt,0
    prints ",",0
    prints t3.txt,0
    if(sys0==5)
    {
      prints ",1",0
      t11.txt="覆写模式: 需拍三视图,等待摄像头..."
    }else
    {
      prints ",0",0
      t11.txt="已发送,等待摄像头就绪..."
    }
    printh 0d 0a
    t4.txt=""
    sys0=2
  }
}else
{
  t11.txt="请先按匹配按钮获取标签"
}


// ===== b4: 拍正面 =====
if(sys0!=3)
{
  t11.txt="请先发送信息启动摄像头"
}else
{
  prints "@in,photo,front",0
  printh 0d 0a
  t11.txt="拍摄正面..."
}


// ===== b5: 拍侧面 =====
if(sys0!=3)
{
  t11.txt="请先发送信息启动摄像头"
}else
{
  prints "@in,photo,side",0
  printh 0d 0a
  t11.txt="拍摄侧面..."
}


// ===== b6: 拍顶部 =====
if(sys0!=3)
{
  t11.txt="请先发送信息启动摄像头"
}else
{
  prints "@in,photo,top",0
  printh 0d 0a
  t11.txt="拍摄顶部..."
}


// ===== b7: 确认入库 =====
if(sys0!=4)
{
  t11.txt="请等待入库完成后再确认"
}else
{
  prints "@in,confirm",0
  printh 0d 0a
  t11.txt="确认入库中..."
  sys0=0
}


// ===== b3: 返回menu =====
prints "@in,cancel",0
printh 0d 0a
page 0
```

---

## 4. Page2 out — 出库

### 控件清单

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t02 | Text | Tag ID（只读） | `txt="tag_id"`, **vscope=global** |
| t1 | Text | 库存数量（只读） | vscope=local |
| t2 | Text | 存放区域（只读） | vscope=local |
| t3 | Text | 物品名称（只读） | vscope=local |
| t4 | Text | 拍摄状态 | `txt=""`, vscope=local |
| t21 | Text | 状态栏 | `txt="请按匹配按钮扫描标签"`, **vscope=global** |
| t6 | Text | 出库数量输入 | `txt="out_count"`, `key=1`, vscope=local |
| t7 | Text | 提示文本（动态） | `txt=""`, vscope=local |
| va0 | Variable(字符串) | 帧缓冲区 | `txt_maxl=200` |
| b0 | Button | 开始匹配标签 | |
| b3 | Button | 返回menu | |
| b4 | Button | 发送信息+启动摄像头 | |
| b5 | Button | 拍正面 | |
| b7 | Button | 确认出库 | |
| m0 | Hotspot | 帧解析入口 | |
| tm1 | Timer | 串口解析 | `tim=50`, `en=1` |

### tm1 定时器

（同 page1，略）

### m0 按下事件（帧解析）

```c
// ===== 提取CMD到 t21 做临时 =====
spstr va0.txt,t21.txt,",",0

// === #ASSET_INFO,tag_id,name,current_qty,remove_qty,remaining_qty ===
// ⚠️ 必须在 #TAG 之前，因为CMD不同
if(t21.txt=="#ASSET_INFO")
{
  spstr va0.txt,t3.txt,",",2       // t3 = name
  spstr va0.txt,t7.txt,",",3       // t7临时 = current_qty
  t7.txt="出库: 库存"+t7.txt
  spstr va0.txt,t21.txt,",",5      // t21临时 = remaining_qty
  t7.txt=t7.txt+"→"+t21.txt+"  请确认后拍摄正面"
  t21.txt=""
  sys0=2
}

// === #TAG,tag_id,name,area,total ===
if(t21.txt=="#TAG")
{
  spstr va0.txt,t02.txt,",",1      // t02 = tag_id
  spstr va0.txt,t3.txt,",",2       // t3 = name
  spstr va0.txt,t2.txt,",",3       // t2 = area
  spstr va0.txt,t1.txt,",",4       // t1 = 库存
  t7.txt="当前库存: "+t1.txt+"  请输入出库数量"
  t21.txt="Tag ID: "+t02.txt+" 已获取"
  sys0=1
}

// === #PROG,step,view,score ===
if(t21.txt=="#PROG")
{
  spstr va0.txt,t4.txt,",",1
  spstr va0.txt,t21.txt,",",2
  t4.txt="拍摄: "+t4.txt+"/1 "+t21.txt
  spstr va0.txt,t21.txt,",",3
  t21.txt="清晰度评分: "+t21.txt
  sys0=3
}

// === #DONE,out,result ===
if(t21.txt=="#DONE")
{
  spstr va0.txt,t21.txt,",",2
  if(t21.txt=="success")
  {
    t21.txt="出库验证通过! 库存已更新, 可按确认"
    sys0=4
  }else
  {
    t21.txt="验证失败: 物品不匹配"
  }
}

// === #ERR,code,msg ===
if(t21.txt=="#ERR")
{
  spstr va0.txt,t21.txt,",",2
}

// === #MSG,text ===
if(t21.txt=="#MSG")
{
  spstr va0.txt,t21.txt,",",1
}
```

### t6 按下事件

```c
if(t6.txt=="out_count")
{
  t6.txt=""
}
```

### 按钮事件

```c
// ===== b0: 开始匹配标签 =====
prints "@out,start",0
printh 0d 0a
t21.txt="正在扫描最近标签..."
t02.txt=""
t1.txt=""
t2.txt=""
t3.txt=""
t4.txt=""
t6.txt="out_count"
t7.txt=""
sys0=0
getFrameFlag=0


// ===== b4: 发送信息+启动摄像头 =====
if(sys0!=1)
{
  t21.txt="请先按匹配按钮获取标签"
}else if(t6.txt=="out_count"||t6.txt=="")
{
  t21.txt="请先输入出库数量"
}else
{
  prints "@out,capture,",0
  prints t02.txt,0
  prints ",",0
  prints t6.txt,0
  printh 0d 0a
  t21.txt="已发送,等待确认信息..."
  t4.txt=""
  sys0=10  // 等待 #ASSET_INFO
}


// ===== b5: 拍正面 =====
if(sys0!=2)
{
  t21.txt="请先发送信息并确认资产"
}else
{
  prints "@out,photo,front",0
  printh 0d 0a
  t21.txt="拍摄正面..."
}


// ===== b7: 确认出库 =====
if(sys0!=4)
{
  t21.txt="请等待验证完成"
}else
{
  prints "@out,confirm",0
  printh 0d 0a
  t21.txt="确认出库完成"
  sys0=0
}


// ===== b3: 返回menu =====
prints "@out,cancel",0
printh 0d 0a
page 0
```

---

## 5. Page3 check — 盘点

### 控件清单

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t03 | Text | Tag ID 输入 | `txt="tag_id"`, `key=1`, **vscope=global** |
| t1 | Text | 标签详情 | vscope=local |
| t4 | Text | 拍摄步骤 | `txt=""`, vscope=local |
| t31 | Text | 状态栏 | `txt="请扫描或输入Tag ID"`, **vscope=global** |
| va0 | Variable(字符串) | 帧缓冲区 | `txt_maxl=200` |
| b0 | Button | 特定盘点 | |
| b1 | Button | 发送信息+启动摄像头 | |
| b2 | Button | 全局盘点 | |
| b3 | Button | 返回menu | |
| b4 | Button | 拍正面 | |
| b5 | Button | 拍侧面 | |
| b6 | Button | 拍顶部 | |
| m0 | Hotspot | 帧解析入口 | |
| tm1 | Timer | 串口解析 | `tim=50`, `en=1` |

### tm1 定时器

（同 page1，略）

### m0 按下事件（帧解析）

```c
// ===== 提取CMD到 t31 做临时 =====
spstr va0.txt,t31.txt,",",0

// === #INV,sle_count,db_total ===
if(t31.txt=="#INV")
{
  spstr va0.txt,t1.txt,",",1       // t1 = sle_count (临时)
  spstr va0.txt,t31.txt,",",2      // t31 = db_total (临时)
  t31.txt="星闪扫描:"+t1.txt+"个  数据库:"+t31.txt+"个"
  t1.txt=""
}

// === #TAG_INFO,tag_id,name,area,count ===
if(t31.txt=="#TAG_INFO")
{
  spstr va0.txt,t03.txt,",",1
  spstr va0.txt,t1.txt,",",2
  t1.txt="名称:"+t1.txt
  spstr va0.txt,t31.txt,",",3
  t1.txt=t1.txt+"  区域:"+t31.txt
  spstr va0.txt,t31.txt,",",4
  t1.txt=t1.txt+"  库存:"+t31.txt
  t31.txt="标签信息已获取,可按启动摄像头"
  sys0=1
}

// === #PROG,step,view,score ===
if(t31.txt=="#PROG")
{
  spstr va0.txt,t4.txt,",",1
  spstr va0.txt,t31.txt,",",2
  t4.txt="拍摄: "+t4.txt+"/3 "+t31.txt
  spstr va0.txt,t31.txt,",",3
  t31.txt="清晰度评分: "+t31.txt
  sys0=3
}

// === #DONE,check,result,similarity ===
if(t31.txt=="#DONE")
{
  spstr va0.txt,t31.txt,",",2
  spstr va0.txt,t1.txt,",",3       // t1 = similarity (临时)
  if(t31.txt=="match")
  {
    t31.txt="比对通过! 相似度:"+t1.txt
  }else
  {
    t31.txt="比对失败! 相似度:"+t1.txt
  }
  sys0=4
}

// === #ERR,code,msg ===
if(t31.txt=="#ERR")
{
  spstr va0.txt,t31.txt,",",2
}

// === #MSG,text ===
if(t31.txt=="#MSG")
{
  spstr va0.txt,t31.txt,",",1
}
```

### 按钮事件

```c
// ===== t03 按下: 清除占位符 =====
if(t03.txt=="tag_id")
{
  t03.txt=""
}


// ===== b2: 全局盘点 =====
prints "@check,global",0
printh 0d 0a
t31.txt="全局盘点中..."
t03.txt="tag_id"
t1.txt=""
t4.txt=""
sys0=0


// ===== b0: 特定盘点 =====
if(t03.txt=="tag_id"||t03.txt=="")
{
  t31.txt="请先输入Tag ID"
}else
{
  prints "@check,specific,",0
  prints t03.txt,0
  printh 0d 0a
  t31.txt="查询中..."
  t1.txt=""
  t4.txt=""
  sys0=0
}


// ===== b1: 发送信息+启动摄像头 =====
if(sys0!=1)
{
  t31.txt="请先查询标签信息"
}else
{
  prints "@check,capture,",0
  prints t03.txt,0
  printh 0d 0a
  t31.txt="已发送,等待摄像头就绪..."
  t4.txt=""
  sys0=2
}


// ===== b4: 拍正面 =====
if(sys0!=3)
{
  t31.txt="请先启动摄像头"
}else
{
  prints "@check,photo,front",0
  printh 0d 0a
  t31.txt="拍摄正面..."
}


// ===== b5: 拍侧面 =====
if(sys0!=3)
{
  t31.txt="请先启动摄像头"
}else
{
  prints "@check,photo,side",0
  printh 0d 0a
  t31.txt="拍摄侧面..."
}


// ===== b6: 拍顶部 =====
if(sys0!=3)
{
  t31.txt="请先启动摄像头"
}else
{
  prints "@check,photo,top",0
  printh 0d 0a
  t31.txt="拍摄顶部..."
}


// ===== b3: 返回menu =====
prints "@check,cancel",0
printh 0d 0a
page 0
```

---

## 6. Page4 find — 资产查找

### 控件清单

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t0-t5 | Text | 资产条目 slot 0~5 | `txt_maxl=60`, vscope=local |
| t6 | Text | 资产总数 | `txt=""`, vscope=local |
| t7 | Text | 页码 | `txt=""`, vscope=local |
| t41 | Text | 状态显示 | `txt=""`, `txt_maxl=200`, vscope=global |
| va0 | Variable(字符串) | 帧缓冲区 | `txt_maxl=200` |
| c0-c5 | Dual-state | 选中条目（互斥） | mode=0 |
| b4 | Button | 获取列表 | `txt="获取列表"` |
| b0 | Button | 上一页 | |
| b1 | Button | 下一页 | |
| b2 | Button | 定位 | `txt="定位"` |
| b3 | Button | 返回menu | |
| b5 | Button | 停止定位 | |
| m0 | Hotspot | 帧解析入口 | |
| tm1 | Timer | 串口解析 | `tim=50`, `en=1` |

### tm1 定时器

```c
while(usize>=3&&getFrameFlag==0)
{
  if(u[0]==0x23)
  {
    getFrameFlag=1
  }else
  {
    udelete 1
  }
}

if(getFrameFlag==1)
{
  sys1=1
  sys2=usize
  sys2=sys2-1
  while(sys1<sys2)
  {
    if(u[sys1]==0x0d)
    {
      if(u[sys1+1]==0x0a)
      {
        frameLength=sys1+2
        cmdLen=sys1
        getFrameFlag=2
        sys1=sys2
      }
    }
    sys1=sys1+1
  }
}

if(getFrameFlag==2)
{
  ucopy va0.txt,0,cmdLen,0
  udelete frameLength
  click m0,1
  getFrameFlag=0
}
```

### m0 按下事件（帧解析）

```c
// ===== 提取CMD到 t41 =====
spstr va0.txt,t41.txt,",",0

// === #LIST,page,total_pages,total_count ===
if(t41.txt=="#LIST")
{
  // t7 = 页码
  spstr va0.txt,t7.txt,",",1
  spstr va0.txt,t41.txt,",",2       // t41临时 = total_pages
  t7.txt="第"+t7.txt+"/"+t41.txt+"页"
  covx t41.txt,sys4,0,0             // sys4 = total_pages (整数)
  
  // t6 = 资产总数
  spstr va0.txt,t6.txt,",",3
  t6.txt="资产总数："+t6.txt
  
  // 清空条目和选中
  t0.txt=""
  t1.txt=""
  t2.txt=""
  t3.txt=""
  t4.txt=""
  t5.txt=""
  t41.txt=""
  c0.val=0
  c1.val=0
  c2.val=0
  c3.val=0
  c4.val=0
  c5.val=0
  sys5=99
  sys0=1
}

// === #ITEM,slot,tag_id,name,area,count ===
if(t41.txt=="#ITEM")
{
  spstr va0.txt,t41.txt,",",1       // t41 = slot

  if(t41.txt=="0")
  {
    spstr va0.txt,t0.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t0.txt=t0.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t0.txt=t0.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t0.txt=t0.txt+"*"+t41.txt
  }
  if(t41.txt=="1")
  {
    spstr va0.txt,t1.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t1.txt=t1.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t1.txt=t1.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t1.txt=t1.txt+"*"+t41.txt
  }
  if(t41.txt=="2")
  {
    spstr va0.txt,t2.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t2.txt=t2.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t2.txt=t2.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t2.txt=t2.txt+"*"+t41.txt
  }
  if(t41.txt=="3")
  {
    spstr va0.txt,t3.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t3.txt=t3.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t3.txt=t3.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t3.txt=t3.txt+"*"+t41.txt
  }
  if(t41.txt=="4")
  {
    spstr va0.txt,t4.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t4.txt=t4.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t4.txt=t4.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t4.txt=t4.txt+"*"+t41.txt
  }
  if(t41.txt=="5")
  {
    spstr va0.txt,t5.txt,",",2
    spstr va0.txt,t41.txt,",",3
    t5.txt=t5.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",4
    t5.txt=t5.txt+" "+t41.txt
    spstr va0.txt,t41.txt,",",5
    t5.txt=t5.txt+"*"+t41.txt
  }
  t41.txt=""
}

// === #LOCATE,status,tag_id ===
if(t41.txt=="#LOCATE")
{
  spstr va0.txt,t41.txt,",",1
  if(t41.txt=="found")
  {
    b2.txt="已激活"
    t41.txt="标签正在蜂鸣..."
  }else
  {
    b2.txt="未找到"
    t41.txt="未找到标签信号"
  }
}

// === #ERR,code,msg ===
if(t41.txt=="#ERR")
{
  spstr va0.txt,t41.txt,",",2
}

// === #MSG,text ===
if(t41.txt=="#MSG")
{
  spstr va0.txt,t41.txt,",",1
}
```

### 按钮事件

```c
// ===== b4: 获取列表 =====
sys3=1
prints "@find,list,1",0
printh 0d 0a
t6.txt="加载中..."
t7.txt="加载中..."
t41.txt=""
t0.txt=""
t1.txt=""
t2.txt=""
t3.txt=""
t4.txt=""
t5.txt=""
c0.val=0
c1.val=0
c2.val=0
c3.val=0
c4.val=0
c5.val=0
sys5=99
b2.txt="定位"


// ===== c0-c5 互斥选中 =====
// c0 按下
c1.val=0
c2.val=0
c3.val=0
c4.val=0
c5.val=0
sys5=0

// c1 按下
c0.val=0
c2.val=0
c3.val=0
c4.val=0
c5.val=0
sys5=1

// c2 按下
c0.val=0
c1.val=0
c3.val=0
c4.val=0
c5.val=0
sys5=2

// c3 按下
c0.val=0
c1.val=0
c2.val=0
c4.val=0
c5.val=0
sys5=3

// c4 按下
c0.val=0
c1.val=0
c2.val=0
c3.val=0
c5.val=0
sys5=4

// c5 按下
c0.val=0
c1.val=0
c2.val=0
c3.val=0
c4.val=0
sys5=5


// ===== b0: 上一页 =====
if(sys3>1)
{
  sys3=sys3-1
  prints "@find,list,",0
  prints sys3,0
  printh 0d 0a
  t7.txt="加载中..."
  t0.txt=""
  t1.txt=""
  t2.txt=""
  t3.txt=""
  t4.txt=""
  t5.txt=""
  t41.txt=""
  c0.val=0
  c1.val=0
  c2.val=0
  c3.val=0
  c4.val=0
  c5.val=0
  sys5=99
  b2.txt="定位"
}else
{
  t41.txt="已是第一页"
}


// ===== b1: 下一页 =====
if(sys3<sys4)
{
  sys3=sys3+1
  prints "@find,list,",0
  prints sys3,0
  printh 0d 0a
  t7.txt="加载中..."
  t0.txt=""
  t1.txt=""
  t2.txt=""
  t3.txt=""
  t4.txt=""
  t5.txt=""
  t41.txt=""
  c0.val=0
  c1.val=0
  c2.val=0
  c3.val=0
  c4.val=0
  c5.val=0
  sys5=99
  b2.txt="定位"
}else
{
  t41.txt="已是最后一页"
}


// ===== b2: 定位选中标签 =====
if(sys5==99)
{
  t41.txt="请先选择一个资产"
}else
{
  if(sys5==0)
  {
    spstr t0.txt,t6.txt," ",0
  }
  if(sys5==1)
  {
    spstr t1.txt,t6.txt," ",0
  }
  if(sys5==2)
  {
    spstr t2.txt,t6.txt," ",0
  }
  if(sys5==3)
  {
    spstr t3.txt,t6.txt," ",0
  }
  if(sys5==4)
  {
    spstr t4.txt,t6.txt," ",0
  }
  if(sys5==5)
  {
    spstr t5.txt,t6.txt," ",0
  }
  prints "@find,locate,",0
  prints t6.txt,0
  printh 0d 0a
  t41.txt="正在定位..."
  b2.txt="定位中..."
}


// ===== b5: 停止定位 =====
prints "@find,stop",0
printh 0d 0a
b2.txt="定位"
t41.txt="已停止定位"


// ===== b3: 返回menu =====
prints "@find,cancel",0
printh 0d 0a
page 0
```

---

## 7. Page5 setting — 设置

### 控件清单

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t51 | Text | 状态显示 | `txt="Status"`, `txt_maxl=100`, **vscope=global** |
| t3 | Text | WiFi名称输入 | `txt="WiFi_name"`, `key=1`, `txt_maxl=30`, vscope=local |
| t0 | Text | WiFi密码输入 | `txt="WiFi_pswd"`, `key=1`, `txt_maxl=30`, vscope=local |
| h0 | Slider | 屏幕背光 | `val=100`, vscope=local |
| va0 | Variable(字符串) | 帧缓冲区 | `txt_maxl=200` |
| b1 | Button | 连接WiFi | |
| b3 | Button | 返回menu | |
| b4 | Button | 断开连接 | `txt="断开"` |
| m0 | Hotspot | 帧解析 | |
| tm1 | Timer | 串口解析 | `tim=50`, `en=1` |

### tm1 定时器

```c
while(usize>=3&&getFrameFlag==0)
{
  if(u[0]==0x23)
  {
    getFrameFlag=1
  }else
  {
    udelete 1
  }
}

if(getFrameFlag==1)
{
  sys1=1
  sys2=usize
  sys2=sys2-1
  while(sys1<sys2)
  {
    if(u[sys1]==0x0d)
    {
      if(u[sys1+1]==0x0a)
      {
        frameLength=sys1+2
        cmdLen=sys1
        getFrameFlag=2
        sys1=sys2
      }
    }
    sys1=sys1+1
  }
}

if(getFrameFlag==2)
{
  ucopy va0.txt,0,cmdLen,0
  udelete frameLength
  click m0,1
  getFrameFlag=0
}
```

### m0 按下事件

```c
spstr va0.txt,t51.txt,",",0

// === #NET,mode,status,signal ===
if(t51.txt=="#NET")
{
  spstr va0.txt,t51.txt,",",1      // t51 = mode (wifi/4g)
  spstr va0.txt,t3.txt,",",2       // t3临时 = status
  if(t3.txt=="connected")
  {
    spstr va0.txt,t3.txt,",",3     // t3临时 = signal
    if(t51.txt=="wifi")
    {
      t51.txt="WiFi已连接 信号:"+t3.txt+"dBm"
    }else
    {
      t51.txt="4G已连接 信号:"+t3.txt
    }
  }else if(t3.txt=="connecting")
  {
    if(t51.txt=="wifi")
    {
      t51.txt="WiFi连接中..."
    }else
    {
      t51.txt="4G连接中..."
    }
  }else
  {
    t51.txt="未连接"
  }
}

// === #WIFI,result ===
if(t51.txt=="#WIFI")
{
  spstr va0.txt,t51.txt,",",1
  if(t51.txt=="ok")
  {
    t51.txt="WiFi连接成功!"
  }else
  {
    t51.txt="WiFi连接失败"
  }
}

// === #ERR,code,msg ===
if(t51.txt=="#ERR")
{
  spstr va0.txt,t51.txt,",",2
}

// === #MSG,text ===
if(t51.txt=="#MSG")
{
  spstr va0.txt,t51.txt,",",1
}
```

### 控件事件

```c
// ===== t3 按下: 清除占位符 =====
if(t3.txt=="WiFi_name")
{
  t3.txt=""
}

// ===== t0 按下: 清除占位符 =====
if(t0.txt=="WiFi_pswd")
{
  t0.txt=""
}

// ===== h0 弹起事件: 实时调背光 =====
dim=h0.val
```

### 按钮事件

```c
// ===== b1: 连接 WiFi =====
if(t3.txt=="WiFi_name"||t3.txt=="")
{
  t51.txt="请先输入WiFi名称"
}else if(t0.txt=="WiFi_pswd"||t0.txt=="")
{
  t51.txt="请先输入WiFi密码"
}else
{
  prints "@setting,wifi,",0
  prints t3.txt,0
  prints ",",0
  prints t0.txt,0
  printh 0d 0a
  t51.txt="正在连接 "+t3.txt+"..."
}

// ===== b4: 断开连接 =====
prints "@setting,disconnect",0
printh 0d 0a
t51.txt="正在断开..."

// ===== b3: 返回menu =====
prints "@setting,cancel",0
printh 0d 0a
page 0
```

---

## 8. Page6 msg — 消息

纯静态展示页，无串口交互。

### 控件

| 控件 | 类型 | 用途 | 属性 |
|------|------|------|------|
| t0 | Text | 固定信息展示 | `txt` 设为要显示的文本 |
| b0 | Button | 返回menu | |

### 按钮事件

```c
// b0: 返回menu
page 0
```

---

## 9. 注意事项

1. **`recmod=1` 后模拟器无法调试串口**。必须在真实屏幕上测试帧收发。
2. **T1 缓冲区 1024 字节**，单帧建议不超过 200 字节。
3. **`if(xxx){yyy}` 不支持写在同一行**，必须 `if(xxx)` 一行，`{` 一行，`yyy` 一行，`}` 一行。
4. **不支持混合 `&&` 和 `||`**。需用全局变量预先计算条件标记。
5. **`for` 循环中 `usize` 不能参与算术表达式**。需 `sys2=usize; sys2=sys2-1; while(...)`。
6. **`spstr` 源和目标不能相同**（自覆盖问题）。用其他变量中转。
7. **字符串不能直接赋值给 `int` 变量**。用 `covx` 转换。
8. **所有控件默认文本在属性面板中设 `txt`**，不要在页面预初始化事件中赋值（会被键盘返回触发）。
9. **弹键盘页面的 Tag ID 和状态控件必须设 `vscope=global`**，否则键盘返回时值丢失。
10. **上位机指令区只能发淘晶驰字符串指令**（如 `t0.txt="test"`, `page 1`），不能发自定义帧。

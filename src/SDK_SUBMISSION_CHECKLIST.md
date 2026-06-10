# WS63 SDK 提交清单

这份清单用于把整个 SDK 安全地提交到你自己的组织仓库。重点是区分「应该提交的源码和配置」与「不应该提交的构建产物和缓存」。

## 1. 建议提交的内容

下面这些内容通常属于 SDK 的正式源码、脚本和配置，建议提交到仓库：

- `CMakeLists.txt`
- `build.py`
- `config.in`
- `application/`
- `bootloader/`
- `build/` 中的源码脚本、CMake 片段、配置生成脚本、toolchain 配置
- `drivers/`
- `include/`
- `kernel/`
- `libs_url/`
- `middleware/`
- `open_source/`
- `protocol/`
- `tools/`

## 2. 一般不要提交的内容

这些目录和文件通常是本地构建产物、缓存、临时文件，不建议提交：

- `output/`
- `interim_binary/`
- `**/__pycache__/`
- `**/*.pyc`
- `**/*.pyo`
- `**/*.log`
- `**/*.tmp`
- `build/config/target_config/**/menuconfig/**/*.old`
- 任何自动生成的签名文件、bin 文件、hex 文件、map 文件、obj 文件

## 3. 你这个 SDK 里特别要注意的点

这个 SDK 的 `build/` 目录不是“编译输出目录”，而是“构建脚本和配置目录”。所以它通常是要提交的，但要注意不要把它下面的临时缓存也一起带上。

建议你重点检查这些位置：

- `build/cmake/`
- `build/config/`
- `build/script/`
- `build/toolchains/`

另外，`menuconfig` 生成的 `.old` 文件一般是本地备份，不建议提交。

## 4. 安全提交顺序

推荐每次都按下面顺序走，能最大限度避免误操作：

1. 看当前改动

```bash
git status --short
```

2. 看详细差异

```bash
git diff
```

3. 只添加你确认要提交的目录和文件

```bash
git add CMakeLists.txt build.py config.in application bootloader build drivers include kernel libs_url middleware open_source protocol tools
```

4. 再确认暂存区

```bash
git status --short
git diff --cached
```

5. 提交

```bash
git commit -m "Initial commit: import WS63 SDK"
```

6. 推送到远端

```bash
git push -u origin main
```

## 5. 以后做轻微修改时的做法

如果后面只是小改动，流程也一样：

- 先 `git status --short`
- 再 `git diff`
- 再只 `git add` 你改过的文件
- 然后 `git commit`
- 最后 `git push`

这样不会影响你没有改过的文件，也不会把构建产物误提交上去。

## 6. 建议补一个本地忽略规则

如果你愿意，后面最好在仓库根目录再加一个 `.gitignore`，至少忽略：

- `output/`
- `interim_binary/`
- `**/__pycache__/`
- `**/*.pyc`
- `**/*.old`

这样以后你每次构建和 menuconfig，工作区都会干净很多。

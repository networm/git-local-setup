#!/bin/bash

# 用于在 git pull --rebase 出错时删除目录恢复到可以拉取状态
if [ -d .git/rebase-merge ]; then
    echo "> Restore from rebase failure"
    rm -rf .git/rebase-merge
    exit 0
fi

echo "> Set Git config"
# 使用简单模式拉取，即只更新当前所在分支
git config push.default simple
# 禁用检出时自动切换换行符
git config core.autocrlf false
# 修正中文路径显示为\xXXX
git config core.quotepath false
# 不记录所有文件的可执行位，记录会导致 Windows 下未改动的有可执行位文件出现改动
git config core.filemode false
# 取消拉取时自动变基
git config --unset pull.rebase
# 取消变基时自动储藏功能
git config --unset rebase.autoStash
# 只使用快进式（fast-forward）合并
git config pull.ff only

echo "> Set Git LFS"
# 初始化 LFS 支持
git lfs install --force
# 开启文件锁定功能
git config lfs.locksverify true

echo "> Set Git hooks"
# 安装 Git 自定义钩子
sh githooks/install-hooks.sh

echo "> Fix LFS files"
# 修复 LFS 追踪的文件，某些情况下大文件可能会处在文本指针状态下，重新执行检出可以恢复文件内容
git lfs fetch
git lfs checkout

# 暂停，按任意键关闭
echo "Press any key to continue"
read -n1 ans

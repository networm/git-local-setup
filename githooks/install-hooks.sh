#!/bin/bash

set -e

readonly SCRIPT_DIR="githooks"
readonly HOOKS_DIR="$SCRIPT_DIR/../.git/hooks"

SCRIPTS=(applypatch-msg commit-msg fsmonitor-watchman post-update pre-applypatch pre-commit pre-merge-commit pre-rebase pre-receive prepare-commit-msg update)

for SCRIPT in "${SCRIPTS[@]}"; do
    cat <<EOF > "$HOOKS_DIR/$SCRIPT"
#!/bin/sh

if [[ -f "$SCRIPT_DIR/$SCRIPT" ]]; then
    sh "$SCRIPT_DIR/$SCRIPT" $@
fi
EOF
    chmod +x "$HOOKS_DIR/$SCRIPT"
done

echo "Installed ${SCRIPTS[*]}"

# 注意 Git LFS 会覆盖 post-checkout post-commit post-merge pre-push 几个钩子的内容
# 因此对以上钩子使用内容追加方式添加修改

SCRIPTS=(post-checkout post-commit post-merge pre-push)

for SCRIPT in "${SCRIPTS[@]}"; do
    cat <<EOF >> "$HOOKS_DIR/$SCRIPT"

if [[ -f "$SCRIPT_DIR/$SCRIPT" ]]; then
    sh "$SCRIPT_DIR/$SCRIPT" $@
fi
EOF
    chmod +x "$HOOKS_DIR/$SCRIPT"
done

echo "Installed ${SCRIPTS[*]}"

#!/usr/bin/env bash
# Git Lab 3 — Interactive Rebase & Clean History
G="\033[0;32m"; C="\033[0;36m"; Y="\033[1;33m"; N="\033[0m"
LAB=~/git-labs/lab3
echo -e "\n${C}═══════════════════════════════════${N}"
echo -e "${C}  Git Lab 3 — Interactive Rebase    ${N}"
echo -e "${C}═══════════════════════════════════${N}\n"
rm -rf $LAB && mkdir -p $LAB && cd $LAB
git init -q

echo "# Auth App" > README.md
git add . && git commit -q -m "Initial commit"
git switch -q -c feature/user-auth

# 7 messy commits
echo "def register(): pass"       >> auth.py && git add . && git commit -q -m "WIP register"
echo "def login(): pass"          >> auth.py && git add . && git commit -q -m "add loginn"
echo "def logout(): pass"         >> auth.py && git add . && git commit -q -m "typo fix"
echo "def password_reset(): pass" >> auth.py && git add . && git commit -q -m "forgot reset"
echo "# Auth module"              >> auth.py && git add . && git commit -q -m "add comment"
echo "VERSION = '1.0'"           > version.py && git add . && git commit -q -m "version"
echo "DEBUG = False"             >> version.py && git add . && git commit -q -m "debug off"

echo -e "${G}✓ 7 messy commits created on feature/user-auth${N}"
echo ""
git log --oneline
echo ""
echo -e "${C}Tasks:${N}"
echo "  1. git rebase -i HEAD~7"
echo "     In the editor:"
echo "       pick  → keep first commit as-is"
echo "       squash (s) → merge commits 2-5 into commit 1"
echo "       pick  → keep version commit"
echo "       squash (s) → merge debug commit into version"
echo "  2. Write clean commit messages in the next two editors"
echo "  3. git log --oneline   # should show 3 commits total"
echo "  4. Try: git rebase -i HEAD~2 with 'reword' to rename a commit"
echo "  5. Use 'drop' to delete a commit — then recover with git reflog"
echo ""
echo -e "${Y}Tip: Set editor to nano if VS Code is slow: export GIT_EDITOR=nano${N}"
echo -e "Open VS Code: ${Y}code $LAB${N}"

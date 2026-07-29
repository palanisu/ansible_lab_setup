#!/usr/bin/env bash
# Git Lab 4 — Full GitFlow Workflow
G="\033[0;32m"; C="\033[0;36m"; Y="\033[1;33m"; N="\033[0m"
LAB=~/git-labs/lab4
echo -e "\n${C}══════════════════════════════${N}"
echo -e "${C}  Git Lab 4 — GitFlow Workflow  ${N}"
echo -e "${C}══════════════════════════════${N}\n"
rm -rf $LAB && mkdir -p $LAB && cd $LAB
git init -q

# v1.0.0 baseline
echo "1.0.0" > VERSION
echo "print('App v1.0.0')" > app.py
echo "# Changelog\n## v1.0.0\n- Initial release" > CHANGELOG.md
git add . && git commit -q -m "Initial release"
git tag -a v1.0.0 -m "Release 1.0.0"
git switch -q -c develop

echo -e "${G}✓ Ready — main tagged v1.0.0, develop branch created${N}"
echo ""
git log --oneline --graph --all
echo ""
echo -e "${C}GitFlow tasks (run in order):${N}"
echo ""
echo -e "${Y}── FEATURE BRANCH ──────────────────────────────────────${N}"
echo "  git switch develop"
echo "  git switch -c feature/user-profile"
echo "  echo 'def get_profile(uid): return {}' >> app.py"
echo "  git add . && git commit -m 'Add user profile function'"
echo "  git switch develop"
echo "  git merge --no-ff feature/user-profile -m 'Merge feature/user-profile'"
echo "  git branch -d feature/user-profile"
echo "  git log --oneline --graph --all"
echo ""
echo -e "${Y}── RELEASE BRANCH ──────────────────────────────────────${N}"
echo "  git switch -c release/1.1.0"
echo "  echo '1.1.0' > VERSION && git commit -am 'Bump version to 1.1.0'"
echo "  # (fix a bug if found during release testing)"
echo "  git switch main && git merge --no-ff release/1.1.0 -m 'Release v1.1.0'"
echo "  git tag -a v1.1.0 -m 'Release 1.1.0'"
echo "  git switch develop && git merge --no-ff release/1.1.0 -m 'Merge release back'"
echo "  git branch -d release/1.1.0"
echo ""
echo -e "${Y}── HOTFIX BRANCH ───────────────────────────────────────${N}"
echo "  git switch main"
echo "  git switch -c hotfix/fix-null-crash"
echo "  echo 'def safe_run(x): return x or {}' >> app.py"
echo "  git commit -am 'Fix null crash in safe_run'"
echo "  echo '1.1.1' > VERSION && git commit -am 'Bump to 1.1.1'"
echo "  git switch main && git merge --no-ff hotfix/fix-null-crash -m 'Hotfix v1.1.1'"
echo "  git tag -a v1.1.1 -m 'Hotfix 1.1.1'"
echo "  git switch develop && git merge --no-ff hotfix/fix-null-crash -m 'Merge hotfix'"
echo "  git branch -d hotfix/fix-null-crash"
echo ""
echo "  git log --oneline --graph --all   # Full GitFlow picture!"
echo "  git tag -l                        # v1.0.0, v1.1.0, v1.1.1"
echo ""
echo -e "${Y}Open VS Code: code $LAB${N}"

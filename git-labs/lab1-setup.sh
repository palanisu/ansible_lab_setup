#!/usr/bin/env bash
# Git Lab 1 — Commits, Selective Staging & Undo
G="\033[0;32m"; C="\033[0;36m"; Y="\033[1;33m"; N="\033[0m"
LAB=~/git-labs/lab1
echo -e "\n${C}══════════════════════════════════════════${N}"
echo -e "${C}  Git Lab 1 — Commits & Selective Staging  ${N}"
echo -e "${C}══════════════════════════════════════════${N}\n"
rm -rf $LAB && mkdir -p $LAB && cd $LAB
git init -q && echo -e "${G}✓ Repo ready: $LAB${N}\n"

# Scaffold files
echo "# DevOps Training Project" > README.md
echo "Flask==3.0.0" > requirements.txt
mkdir -p src tests
cat > src/app.py << 'PY'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'DevOps Training App'

if __name__ == '__main__':
    app.run()
PY
cat > tests/test_app.py << 'PY'
def test_placeholder():
    assert True
PY

echo -e "${C}Tasks:${N}"
echo "  1. git status                    # see untracked files"
echo "  2. git add README.md && git commit -m 'Add README'"
echo "  3. git add requirements.txt && git commit -m 'Add requirements'"
echo "  4. git add src/ tests/ && git commit -m 'Add app skeleton'"
echo "  5. Add two functions to src/app.py (greet + farewell)"
echo "  6. git add -p src/app.py         # stage greet only — press y/n"
echo "  7. git commit -m 'Add greet function'"
echo "  8. git add src/app.py && git commit -m 'Add farewell function'"
echo "  9. git log --oneline --graph"
echo " 10. Make a bad commit → git reset --soft HEAD~1"
echo " 11. Make another bad commit → git reset --hard HEAD~1"
echo " 12. Make one more → git revert HEAD --no-edit"
echo ""
echo -e "${Y}Hint: git add -p keys: y=stage, n=skip, s=split, q=quit, ?=help${N}"
echo -e "Open VS Code: ${Y}code $LAB${N}"

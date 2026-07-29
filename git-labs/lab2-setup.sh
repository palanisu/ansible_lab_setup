#!/usr/bin/env bash
# Git Lab 2 — Branching, Merging & Conflict Resolution
G="\033[0;32m"; C="\033[0;36m"; Y="\033[1;33m"; N="\033[0m"
LAB=~/git-labs/lab2
echo -e "\n${C}═══════════════════════════════════════════════════════${N}"
echo -e "${C}  Git Lab 2 — Branching, Merging & Conflict Resolution  ${N}"
echo -e "${C}═══════════════════════════════════════════════════════${N}\n"
rm -rf $LAB && mkdir -p $LAB && cd $LAB
git init -q

cat > app.py << 'PY'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'Welcome'
PY
echo "Flask==3.0.0" > requirements.txt
git add . && git commit -q -m "Initial: Flask app skeleton"
echo -e "${G}✓ Initial commit done${N}\n"

echo -e "${C}Tasks (run these commands one by one):${N}"
echo ""
echo "  # ── Create feature/login branch ──────────────────────────"
echo "  git switch -c feature/login"
echo "  # Add @app.route('/login') to app.py"
echo "  git add app.py && git commit -m 'Add login route'"
echo ""
echo "  # ── Create feature/dashboard branch ──────────────────────"
echo "  git switch main"
echo "  git switch -c feature/dashboard"
echo "  # Add @app.route('/dashboard') AND change home() return value"
echo "  git add app.py && git commit -m 'Add dashboard route'"
echo ""
echo "  # ── Merge login (clean) ────────────────────────────────────"
echo "  git switch main"
echo "  git merge feature/login"
echo "  git log --oneline --graph --all"
echo ""
echo "  # ── Merge dashboard (CONFLICT) ─────────────────────────────"
echo "  git merge feature/dashboard     # CONFLICT in home()"
echo "  code app.py                     # resolve in VS Code"
echo "  git add app.py"
echo "  git commit -m 'Merge feature/dashboard — resolve conflict'"
echo "  git log --oneline --graph --all"
echo ""
echo "  # ── Clean up ───────────────────────────────────────────────"
echo "  git branch -d feature/login feature/dashboard"
echo ""
echo -e "${Y}Open VS Code: code $LAB${N}"

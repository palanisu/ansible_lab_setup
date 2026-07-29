# DevOps Training Lab v2

**Git · Ansible · Azure Pipelines**  
One `git clone` + **Reopen in Container** → everything works. No manual setup.

---

## What's included

| Component | Details |
|---|---|
| **Control node** | Ubuntu 22.04 Dev Container — Ansible 8.5, Git 2.40+, Azure CLI, Python 3.11 |
| **Managed nodes** | 3 Ubuntu 22.04 containers — web01, web02 (webservers), db01 (dbservers) |
| **Auto SSH** | Keys generated and pushed to all managed nodes on first start |
| **Git labs** | 4 setup scripts — lab1 through lab4, auto-scaffolded |
| **Ansible playbooks** | 5 ready-to-run playbooks covering all training topics |
| **VS Code tasks** | One-click launch for every lab and playbook |

---

## Prerequisites (one-time on your Windows machine)

| Tool | Download | Notes |
|---|---|---|
| Git | https://git-scm.com/download/win | For cloning this repo |
| WSL2 + Ubuntu 22.04 | PowerShell (Admin): `wsl --install -d Ubuntu-22.04` | Required |
| Docker Desktop | https://www.docker.com/products/docker-desktop | Enable WSL2 backend |
| VS Code | https://code.visualstudio.com | |
| Dev Containers extension | VS Code Extensions: search "Dev Containers" | Required |

**Docker Desktop setup after install:**
Settings → Resources → WSL Integration → ✅ Ubuntu-22.04 → Apply & Restart

---

## Quick Start

```bash
# 1. Clone (in WSL Ubuntu terminal)
git clone https://YOUR_ORG@dev.azure.com/YOUR_ORG/DevOps-Training/_git/devops-lab
cd devops-lab

# 2. Open in VS Code
code .
```

VS Code will prompt: **"Reopen in Container"** → Click it.

⏳ First build: 5–10 min (downloads images). Subsequent starts: < 30 sec.

```bash
# 3. Inside the Dev Container terminal — verify everything works:
ansible all -m ping
```

Expected:
```
web01 | SUCCESS => { "ping": "pong" }
web02 | SUCCESS => { "ping": "pong" }
db01  | SUCCESS => { "ping": "pong" }
```

---

## Lab Commands

### Git Labs
```bash
bash git-labs/lab1-setup.sh   # Lab 1 — Commits, staging & undo
bash git-labs/lab2-setup.sh   # Lab 2 — Branching, merging & conflicts
bash git-labs/lab3-setup.sh   # Lab 3 — Interactive rebase
bash git-labs/lab4-setup.sh   # Lab 4 — GitFlow workflow
```

### Ansible Playbooks
```bash
ansible all -m ping
ansible-inventory --graph
ansible-playbook ansible/playbooks/01-ping-test.yml
ansible-playbook ansible/playbooks/02-gather-facts.yml
ansible-playbook ansible/playbooks/03-install-nginx.yml
ansible-playbook ansible/playbooks/03-install-nginx.yml --check --diff
ansible-playbook ansible/playbooks/04-variables-loops.yml
```

### VS Code Tasks (Ctrl+Shift+B or Ctrl+Shift+P → Tasks: Run Task)
All labs and playbooks are available as clickable tasks in the Tasks menu.

---

## Lab Network Layout

```
172.20.0.0/24 (Docker bridge)

┌─────────────────────────────────────────────────────┐
│  devcontainer  172.20.0.10  Control node            │
│  (VS Code attaches here — Ansible, Git, AzureCLI)   │
│                │                                     │
│       SSH (key auto-configured by post-create.sh)    │
│       ┌────────┼────────┐                            │
│       ▼        ▼        ▼                            │
│   web01       web02     db01                         │
│  .0.21        .0.22     .0.23                        │
│  port 80      port 8080  port 5432                   │
└─────────────────────────────────────────────────────┘
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "Reopen in Container" not showing | Install the "Dev Containers" VS Code extension |
| Docker Desktop not running | Open Docker Desktop, wait for whale icon in taskbar |
| `ansible all -m ping` fails | Run `bash scripts/post-start.sh` in the terminal |
| Container slow on first open | Normal — Docker builds images. Takes 5-10 min once only |
| Need to reset managed nodes | `bash scripts/lab-reset.sh` |
| Check container status | `docker ps --filter name=lab-` |

---

## Configure Git (first time in the container)

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@company.com"
```

Useful Git aliases already configured:
```bash
git lg    # log --oneline --graph --all --decorate
git st    # status -sb
git undo  # reset --soft HEAD~1
```

---

## File Structure

```
devops-lab/
├── .devcontainer/
│   ├── devcontainer.json     VS Code Dev Container config
│   └── Dockerfile            Control node image (Ansible + Git + AzCLI)
├── managed-nodes/
│   └── Dockerfile.managed    Managed node image (SSH + Python3)
├── docker-compose.yml         All containers + network definition
├── ansible/
│   ├── ansible.cfg           Ansible configuration
│   ├── inventory.yml         Hosts: web01, web02, db01
│   ├── group_vars/           Variables by group
│   ├── host_vars/            Variables by host
│   ├── templates/            Jinja2 templates (nginx.conf.j2)
│   ├── requirements.yml      Galaxy collection requirements
│   └── playbooks/            5 training playbooks
├── git-labs/
│   ├── lab1-setup.sh         Commits & staging
│   ├── lab2-setup.sh         Branching & conflicts
│   ├── lab3-setup.sh         Interactive rebase
│   └── lab4-setup.sh         GitFlow workflow
├── scripts/
│   ├── post-create.sh        Auto-runs on first container create
│   ├── post-start.sh         Auto-runs on every container start
│   └── lab-reset.sh          Reset managed nodes to clean state
├── docs/
│   └── QUICK_START.md        Detailed getting-started guide
└── README.md                 This file
```

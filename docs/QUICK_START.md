# Quick Start Guide — DevOps Training Lab v2

## Step 1 — One-time Windows setup

### Install WSL2
```powershell
# Open PowerShell as Administrator:
wsl --install -d Ubuntu-22.04
# Restart when prompted
```

### Install Docker Desktop
1. Download from https://www.docker.com/products/docker-desktop
2. Install → open Docker Desktop
3. Settings → Resources → WSL Integration → ✅ Ubuntu-22.04 → Apply & Restart

### Install VS Code + Dev Containers extension
1. Download VS Code from https://code.visualstudio.com
2. Open VS Code → Extensions (Ctrl+Shift+X) → search **Dev Containers** → Install

---

## Step 2 — Clone and open the lab

Open **WSL Ubuntu terminal** (from Start menu or Windows Terminal):

```bash
cd ~
git clone https://YOUR_ORG@dev.azure.com/YOUR_ORG/DevOps-Training/_git/devops-lab
cd devops-lab
code .
```

VS Code opens. You'll see a blue notification bottom-right:
> **"Folder contains a Dev Container config. Reopen in Container?"**

Click **Reopen in Container**.

⏳ First time: Docker builds the control node and managed node images (~5-10 minutes).
After that, it starts in under 30 seconds.

---

## Step 3 — Configure Git (inside the container)

In the VS Code terminal (now running inside the container):

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@company.com"

# Verify:
git config --global --list
```

---

## Step 4 — Verify the lab

```bash
# Test all managed nodes respond:
ansible all -m ping

# See the inventory structure:
ansible-inventory --graph

# See all hosts and their variables:
ansible-inventory --list | python3 -m json.tool
```

---

## Step 5 — Start your first lab

### Git Labs
```bash
bash git-labs/lab1-setup.sh    # Creates ~/git-labs/lab1 with scaffold
bash git-labs/lab2-setup.sh    # Creates ~/git-labs/lab2
bash git-labs/lab3-setup.sh    # Creates ~/git-labs/lab3
bash git-labs/lab4-setup.sh    # Creates ~/git-labs/lab4
```

Each script:
- Creates the lab folder with starter files
- Shows step-by-step tasks to complete
- Opens instructions in the terminal

### Ansible Labs
```bash
# Run playbooks from the workspace root:
ansible-playbook ansible/playbooks/01-ping-test.yml
ansible-playbook ansible/playbooks/02-gather-facts.yml
ansible-playbook ansible/playbooks/03-install-nginx.yml
ansible-playbook ansible/playbooks/03-install-nginx.yml --check --diff  # Dry-run
ansible-playbook ansible/playbooks/04-variables-loops.yml

# Ad-hoc commands:
ansible all -m shell -a 'uptime'
ansible webservers -m shell -a 'df -h /'
ansible all -m setup -a 'filter=ansible_distribution*'
ansible webservers -m package -a 'name=vim state=present' -b
```

---

## VS Code Tasks (easiest way to run labs)

Press **Ctrl+Shift+P** → type **Tasks: Run Task** → choose:

| Task | What it does |
|---|---|
| 🔵 Ansible: Ping all nodes | Quick connectivity test |
| 🔵 Ansible: Show inventory tree | Visual inventory graph |
| 🔵 Ansible: Install nginx on webservers | Runs playbook 03 |
| 🔵 Ansible: Dry-run nginx install | Check + diff mode |
| 🌿 Git Lab 1: Start | Sets up Lab 1 |
| 🌿 Git Lab 2: Start | Sets up Lab 2 |
| 🌿 Git Lab 3: Start | Sets up Lab 3 |
| 🌿 Git Lab 4: Start | Sets up Lab 4 |
| 🔄 Lab Reset | Clean managed nodes |

---

## Common ad-hoc Ansible patterns

```bash
# Target specific groups:
ansible webservers -m ping           # Only web servers
ansible dbservers -m ping            # Only DB servers
ansible 'webservers:dbservers' -m ping  # Both groups
ansible 'all:!dbservers' -m ping     # All except DB

# Target a single host:
ansible web01 -m ping

# Run as root (become):
ansible webservers -m shell -a 'whoami' -b   # prints 'root'

# Limit playbook to one host:
ansible-playbook ansible/playbooks/03-install-nginx.yml --limit web01

# Run specific tags:
ansible-playbook ansible/playbooks/03-install-nginx.yml --tags config,verify

# Pass extra variables:
ansible-playbook ansible/playbooks/03-install-nginx.yml -e 'http_port=9090'
```

---

## Lab network reference

| Container | IP | Port | Role |
|---|---|---|---|
| devcontainer (control) | 172.20.0.10 | — | Ansible control node |
| web01 | 172.20.0.21 | 80 | webservers group |
| web02 | 172.20.0.22 | 8080 | webservers group |
| db01 | 172.20.0.23 | — | dbservers group |

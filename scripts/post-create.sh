#!/usr/bin/env bash
# =================================================================
# post-create.sh  — Runs ONCE when Dev Container is first created
# Generates SSH keys, pushes to managed nodes, configures Git
# =================================================================
set -e
G="\033[0;32m"; Y="\033[1;33m"; C="\033[0;36m"; R="\033[0;31m"; N="\033[0m"
ok()   { echo -e "${G}✓  $*${N}"; }
step() { echo -e "\n${C}▶  $*${N}"; }
warn() { echo -e "${Y}⚠  $*${N}"; }

echo -e "${C}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   DevOps Training Lab v2 — First-Time Setup     ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${N}"

# 1. SSH key generation
step "Generating SSH key pair..."
mkdir -p /home/vscode/.ssh && chmod 700 /home/vscode/.ssh
if [ ! -f /home/vscode/.ssh/lab_key ]; then
    ssh-keygen -t ed25519 -C "devops-lab-$(date +%Y%m%d)" \
               -f /home/vscode/.ssh/lab_key -N "" -q
    chmod 600 /home/vscode/.ssh/lab_key
    chmod 644 /home/vscode/.ssh/lab_key.pub
    ok "SSH key generated: ~/.ssh/lab_key"
else
    ok "SSH key already exists — reusing"
fi

# 2. SSH client config
step "Writing SSH client config..."
cat > /home/vscode/.ssh/config << 'SSHCFG'
Host web01
    HostName 172.20.0.21
    User ansible
    IdentityFile ~/.ssh/lab_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR

Host web02
    HostName 172.20.0.22
    User ansible
    IdentityFile ~/.ssh/lab_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR

Host db01
    HostName 172.20.0.23
    User ansible
    IdentityFile ~/.ssh/lab_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
SSHCFG
chmod 600 /home/vscode/.ssh/config
ok "SSH client config written"

# 3. Push SSH public key to managed nodes
step "Installing SSH key on managed nodes..."
PUB=$(cat /home/vscode/.ssh/lab_key.pub)
for NODE in "lab-web01:172.20.0.21" "lab-web02:172.20.0.22" "lab-db01:172.20.0.23"; do
    CTR="${NODE%%:*}"; IP="${NODE##*:}"; NAME="${CTR#lab-}"
    echo -n "  → $NAME ... "
    # wait up to 20s for container SSH
    for i in $(seq 1 20); do
        docker exec "$CTR" true 2>/dev/null && break || sleep 1
    done
    if docker exec "$CTR" bash -c \
        "mkdir -p /home/ansible/.ssh && \
         grep -qF \"${PUB}\" /home/ansible/.ssh/authorized_keys 2>/dev/null || \
         echo \"${PUB}\" >> /home/ansible/.ssh/authorized_keys && \
         chmod 600 /home/ansible/.ssh/authorized_keys && \
         chown -R ansible:ansible /home/ansible/.ssh" 2>/dev/null; then
        echo -e "${G}done${N}"
    else
        echo -e "${Y}retry on next start${N}"
    fi
done

# 4. Git global config
step "Configuring Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.editor "code --wait"
git config --global alias.lg   "log --oneline --graph --all --decorate"
git config --global alias.st   "status -sb"
git config --global alias.undo "reset --soft HEAD~1"
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
    warn "Set your Git identity:"
    echo "  git config --global user.name  \"Your Name\""
    echo "  git config --global user.email \"you@company.com\""
else
    ok "Git identity: $(git config --global user.name)"
fi
ok "Git aliases added: git lg, git st, git undo"

# 5. Verify Ansible
step "Verifying Ansible..."
ansible --version | head -1
ok "Ansible ready"

# 6. Install collections from requirements.yml
step "Installing Ansible collections..."
if [ -f /workspace/ansible/requirements.yml ]; then
    ansible-galaxy collection install -r /workspace/ansible/requirements.yml --ignore-errors -q
fi
ok "Collections ready"

# 7. Quick connectivity test
step "Testing Ansible connectivity..."
sleep 2
cd /workspace
if ansible all -m ping --timeout=5 2>/dev/null | grep -q "pong"; then
    ok "All managed nodes responding to ping!"
else
    warn "Nodes not ready yet — run: ansible all -m ping"
fi

echo ""
echo -e "${G}╔══════════════════════════════════════════════╗${N}"
echo -e "${G}║        Lab Environment Ready!  🎉           ║${N}"
echo -e "${G}╚══════════════════════════════════════════════╝${N}"
echo ""
echo -e "  ${C}Quick start:${N}"
echo -e "  ${Y}ansible all -m ping${N}                  Test nodes"
echo -e "  ${Y}bash git-labs/lab1-setup.sh${N}          Start Git Lab 1"
echo -e "  ${Y}ansible-playbook ansible/playbooks/01-ping-test.yml${N}"
echo -e "  ${Y}cat docs/QUICK_START.md${N}              Full guide"
echo ""

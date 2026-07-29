#!/usr/bin/env bash
# =================================================================
# post-start.sh — Runs every time the container starts
# Re-pushes SSH key if managed nodes were recreated
# =================================================================
G="\033[0;32m"; Y="\033[1;33m"; C="\033[0;36m"; N="\033[0m"

echo -e "${C}▶  Checking managed node SSH access...${N}"

PUB=$(cat /home/vscode/.ssh/lab_key.pub 2>/dev/null)
[ -z "$PUB" ] && echo -e "${Y}No SSH key found — run scripts/post-create.sh${N}" && exit 0

for ENTRY in "lab-web01:172.20.0.21:web01" "lab-web02:172.20.0.22:web02" "lab-db01:172.20.0.23:db01"; do
    CTR="${ENTRY%%:*}"; REST="${ENTRY#*:}"; IP="${REST%%:*}"; NAME="${REST##*:}"
    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 -o BatchMode=yes \
           -i /home/vscode/.ssh/lab_key ansible@${IP} true 2>/dev/null; then
        echo -e "  ${G}✓ $NAME reachable${N}"
    else
        echo -n "  Re-keying $NAME... "
        docker exec $CTR bash -c \
            "mkdir -p /home/ansible/.ssh && \
             grep -qF \"${PUB}\" /home/ansible/.ssh/authorized_keys 2>/dev/null || \
             echo \"${PUB}\" >> /home/ansible/.ssh/authorized_keys && \
             chmod 600 /home/ansible/.ssh/authorized_keys && \
             chown -R ansible:ansible /home/ansible/.ssh" 2>/dev/null \
        && echo -e "${G}done${N}" || echo -e "${Y}not ready${N}"
    fi
done
echo ""

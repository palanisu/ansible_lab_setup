#!/usr/bin/env bash
# =================================================================
# lab-reset.sh — Reset managed nodes to a clean state
# =================================================================
G="\033[0;32m"; Y="\033[1;33m"; C="\033[0;36m"; N="\033[0m"
echo -e "${Y}⚠  Reset all managed nodes to clean state.${N}"
read -p "Continue? (y/N): " c
[[ "$c" != "y" && "$c" != "Y" ]] && echo "Aborted." && exit 0
for NODE in web01 web02 db01; do
    echo -n "  Resetting lab-$NODE... "
    docker exec lab-$NODE bash -c \
        "apt-get remove -y nginx 2>/dev/null; \
         rm -f /etc/nginx/nginx.conf /var/www/html/index.html; \
         userdel -r alice 2>/dev/null; userdel -r bob 2>/dev/null; \
         rm -rf /tmp/lab* /tmp/ansible*" 2>/dev/null || true
    echo -e "${G}done${N}"
done
echo -e "\n${G}✓ Reset complete. Run: ansible all -m ping${N}"

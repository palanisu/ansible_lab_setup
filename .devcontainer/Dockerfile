# =================================================================
# DevOps Training Lab v2 — Control Node
# Base: Ubuntu 22.04 | Ansible + Git + Azure CLI + Python 3.11
# =================================================================
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

LABEL description="DevOps Lab control node – Ansible + Git + AzureCLI"

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-dev \
    openssh-client sshpass \
    curl wget git vim nano tree jq unzip \
    iputils-ping dnsutils netcat \
    build-essential libssl-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    ansible==8.5.0 \
    ansible-lint==6.22.1 \
    molecule==6.0.3 \
    molecule-docker==2.1.0 \
    ansible-builder==3.0.0 \
    paramiko netaddr jmespath requests

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az extension add --name azure-devops --yes

RUN ansible-galaxy collection install \
    ansible.posix \
    community.general \
    community.docker

RUN git config --system init.defaultBranch main \
    && git config --system pull.rebase false \
    && git config --system core.autocrlf input \
    && git config --system credential.helper store

RUN mkdir -p /home/vscode/.ansible/tmp \
    && chown -R vscode:vscode /home/vscode/.ansible

ENV PATH="/home/vscode/.local/bin:${PATH}"
WORKDIR /workspace
USER vscode

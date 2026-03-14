FROM summerwind/actions-runner:latest

USER root
ENV DEBIAN_FRONTEND=noninteractive

# 1. Essential System Dependencies
ARG CACHE_DATE=not_set
RUN echo "Building with cache date: $CACHE_DATE" && \
    apt-get update && \
    apt-get -y -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get install -y --no-install-recommends \
    curl wget git jq unzip zip build-essential software-properties-common \
    apt-transport-https ca-certificates gnupg lsb-release \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev libyaml-dev python3-pip \
    openjdk-11-jdk openjdk-17-jdk openjdk-21-jdk && \
    rm -rf /var/lib/apt/lists/*

# 2. Terraform & Ansible (Official Repos)
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    add-apt-repository --yes --update ppa:ansible/ansible && \
    apt-get update && apt-get install -y terraform ansible

# 3. Azure CLI & GitHub CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install gh -y

# 4. Global Node.js (Using official NodeSource for specific LTS versions)
# Installing Node 20 (Iron) as the system default
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# 5. Go (Manual Install to /usr/local/go - More stable for Runners)
RUN wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz && \
    rm go1.23.0.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
 
# 6. AWS CLI v2 (Official Installer)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws
 
USER runner
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    PATH="/root/.local/bin:$PATH"

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl git gpg gnupg \
      vim \
      iputils-ping \
      dnsutils \
      net-tools \
      iproute2 \
      netcat-openbsd \
      traceroute \
      tcpdump \
      wget \
      jq \
      unzip \
      zip \
      less \
      htop \
      lsof \
      openssh-client \
      bash-completion \
      python3 \
      python3-pip \
      python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu noble stable" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends gh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg \
      | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" \
      > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends vault && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://claude.ai/install.sh | bash && \
    cp "$(readlink -f /root/.local/bin/claude)" /usr/local/bin/claude && \
    chmod +x /usr/local/bin/claude

RUN ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') && \
    GO_VERSION=$(curl -fsSL "https://go.dev/dl/?mode=json" | jq -r '.[0].version') && \
    curl -fsSL "https://dl.google.com/go/${GO_VERSION}.linux-${ARCH}.tar.gz" \
      | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

RUN ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') && \
    KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt) && \
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" \
      -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

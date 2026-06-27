# syntax=docker/dockerfile:1
FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /root

# ── Core utilities ─────────────────────────────────────────────────────────────
RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
      curl wget git vim tmux \
      python3 python3-pip python3-venv pipx \
      rlwrap socat netcat-traditional \
      jq file exiftool \
      zip unzip p7zip-full \
      dnsutils whois \
      iproute2 iputils-ping traceroute \
      build-essential gcc mingw-w64 \
      sshuttle openssh-client \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Recon / scanning ───────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      nmap rustscan \
      libpcap-dev \
      netdiscover arp-scan \
      tcpdump wireshark-cli \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Web ────────────────────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      gobuster ffuf feroxbuster \
      nikto sqlmap wfuzz \
      whatweb wafw00f wpscan \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Password attacks ───────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      hashcat john \
      hydra medusa \
      cewl crunch \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── SMB / Windows enumeration ──────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      smbclient smbmap \
      samba-common-bin \
      enum4linux enum4linux-ng \
      netexec \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── SNMP / LDAP ────────────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      snmp onesixtyone snmpcheck \
      ldap-utils \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Exploitation ───────────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      metasploit-framework \
      exploitdb \
      gdb \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Active Directory / Kerberos ────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends \
      krb5-user \
      impacket-scripts \
      evil-winrm \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Wordlists ──────────────────────────────────────────────────────────────────
RUN apt update && apt install -y --no-install-recommends wordlists \
    && gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ── Python tools (pipx for isolated envs, no dep conflicts) ───────────────────
RUN pipx install bloodhound \
    && pipx install pwncat-cs \
    && pipx install pwntools \
    && pipx install ldapdomaindump \
    && pipx ensurepath

# ── pwndbg (GDB extension for BOF) ────────────────────────────────────────────
RUN git clone --depth 1 https://github.com/pwndbg/pwndbg /opt/pwndbg \
    && cd /opt/pwndbg && ./setup.sh --quiet

# ── Binary downloads ───────────────────────────────────────────────────────────

# Naabu (port scanner — requires libpcap-dev, installed above)
RUN NAABU_VER=$(curl -s https://api.github.com/repos/projectdiscovery/naabu/releases/latest | jq -r '.tag_name') \
    && curl -sL "https://github.com/projectdiscovery/naabu/releases/download/${NAABU_VER}/naabu_${NAABU_VER#v}_linux_amd64.zip" \
    -o /tmp/naabu.zip \
    && unzip -q /tmp/naabu.zip naabu -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/naabu \
    && rm /tmp/naabu.zip

# Chisel (TCP tunneling)
RUN CHISEL_VER=$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r '.tag_name') \
    && curl -sL "https://github.com/jpillora/chisel/releases/download/${CHISEL_VER}/chisel_${CHISEL_VER#v}_linux_amd64.gz" \
    | gzip -d > /usr/local/bin/chisel \
    && chmod +x /usr/local/bin/chisel

# Ligolo-ng (layer 3 pivoting proxy)
RUN LIGOLO_VER=$(curl -s https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest | jq -r '.tag_name') \
    && curl -sL "https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}/ligolo-ng_proxy_${LIGOLO_VER#v}_linux_amd64.tar.gz" \
    | tar -xz -C /tmp/ \
    && mv /tmp/proxy /usr/local/bin/ligolo-proxy \
    && chmod +x /usr/local/bin/ligolo-proxy

# Ligolo-ng agent (for dropping on targets — keep both here for convenience)
RUN LIGOLO_VER=$(curl -s https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest | jq -r '.tag_name') \
    && curl -sL "https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}/ligolo-ng_agent_${LIGOLO_VER#v}_windows_amd64.zip" \
    -o /opt/ligolo-agent-windows.zip \
    && curl -sL "https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}/ligolo-ng_agent_${LIGOLO_VER#v}_linux_amd64.tar.gz" \
    | tar -xz -C /tmp/ \
    && mv /tmp/agent /usr/local/bin/ligolo-agent \
    && chmod +x /usr/local/bin/ligolo-agent

# Kerbrute (Kerberos user enumeration / brute-force)
RUN KERBRUTE_VER=$(curl -s https://api.github.com/repos/ropnop/kerbrute/releases/latest | jq -r '.tag_name') \
    && curl -sL "https://github.com/ropnop/kerbrute/releases/download/${KERBRUTE_VER}/kerbrute_linux_amd64" \
    -o /usr/local/bin/kerbrute \
    && chmod +x /usr/local/bin/kerbrute

# ── Privesc scripts ────────────────────────────────────────────────────────────
RUN mkdir -p /opt/privesc \
    && curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh \
       -o /opt/privesc/linpeas.sh \
    && curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASx64.exe \
       -o /opt/privesc/winPEASx64.exe \
    && curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASany.exe \
       -o /opt/privesc/winPEASany.exe \
    && curl -sL https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 \
       -o /opt/privesc/pspy64 \
    && chmod +x /opt/privesc/linpeas.sh /opt/privesc/pspy64

# ── proxychains: dynamic chain ─────────────────────────────────────────────────
RUN sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains4.conf \
    && sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains4.conf \
    && echo "socks5 127.0.0.1 1080" >> /etc/proxychains4.conf

# ── tmux ───────────────────────────────────────────────────────────────────────
RUN cat > /root/.tmux.conf << 'EOF'
set -g default-terminal "screen-256color"
set -g mouse on
set -g history-limit 50000
set -g base-index 1
setw -g pane-base-index 1
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind r source-file ~/.tmux.conf \; display "Reloaded"
set -g status-right "#[fg=green]%H:%M #[fg=cyan]%d-%b"
EOF

# ── Shell aliases and helpers ──────────────────────────────────────────────────
RUN cat >> /root/.bashrc << 'EOF'

# ── pentest aliases ────────────────────────────────────────────────────────────
alias ll='ls -la'
alias pc='proxychains4 -q'
alias msfconsole='msfconsole -q'
alias nmap-quick='nmap -sV -sC --open -oA quick'
alias nmap-all='nmap -p- --open -T4 -oA allports'
alias nmap-udp='sudo nmap -sU --top-ports 200 -oA udp'

# dynamic LHOST (picks the first non-loopback IP)
export LHOST=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -1)
export LPORT=4444

# quick http server to serve files
alias serve='python3 -m http.server 8000'

# SecLists shortcut (assumes volume mounted at /wordlists/SecLists)
export SECLISTS=/wordlists/SecLists
export ROCKYOU=/usr/share/wordlists/rockyou.txt

# print current tun0/eth0 for reference on start
echo ""
ip -brief addr show | grep -v "^lo" | awk '{printf "%-10s %s\n", $1, $3}'
echo ""
EOF

CMD ["/bin/bash", "--login"]

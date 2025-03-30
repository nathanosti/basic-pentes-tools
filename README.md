
# 🛡️ Pentest Web Setup (Arch Linux + ZSH)

Este repositório contém um script automatizado para configurar um ambiente de testes de segurança ofensiva focado em **aplicações web**, utilizando **Arch Linux** (ou derivados) e o terminal **ZSH** como base.

O setup inclui ferramentas essenciais para as fases de **reconhecimento, enumeração, fuzzing, exploração e análise**, além de wordlists poderosas e aliases prontos para agilizar seu fluxo de trabalho.

---

## 🚀 Funcionalidades

✅ Instalação automatizada de ferramentas via `pacman` e `yay`  
✅ Clonagem de repositórios essenciais: `XSStrike`, `AutoRecon`, `SecLists`  
✅ Criação automática de aliases úteis no `.zshrc`  
✅ Compatível com **Oh My Zsh** (detecta e instala plugin opcional `zsh-autosuggestions`)  
✅ Ideal para pentesters, bug hunters e CTF players

---

## 🛠️ Ferramentas instaladas

### 📦 Via `pacman`
- `nmap` – Scanner de redes e serviços
- `whatweb` – Identificação de tecnologias web
- `sqlmap` – Injeção SQL automatizada
- `nikto` – Scanner de vulnerabilidades em servidores web
- `hydra` – Força bruta em autenticação
- `wireshark-qt` – Sniffer de pacotes
- `mitmproxy` – Proxy para interceptação e modificação de tráfego
- `httpie`, `jq` – Ferramentas CLI úteis
- `docker` – Contêineres para labs e ambientes isolados

### 📦 Via `yay` (AUR)
- `burpsuite` – Proxy de interceptação e manipulação manual
- `ffuf`, `dirsearch` – Ferramentas de fuzzing (path discovery)
- `amass`, `subfinder-bin` – Enumeração de subdomínios
- `httpx` – Testador ativo de hosts HTTP
- `nuclei` – Scanner de vulnerabilidades baseado em templates
- `metasploit` – Framework completo de exploração
- `insomnia` – Teste e debug de APIs

### 📚 Clonados manualmente
- [`XSStrike`](https://github.com/s0md3v/XSStrike) – Testes avançados de XSS
- [`AutoRecon`](https://github.com/Tib3rius/AutoRecon) – Enumeração automatizada
- [`SecLists`](https://github.com/danielmiessler/SecLists) – Coletânea de wordlists para pentest

---

## ⚙️ Como usar

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/pentes-web-setup.git
cd pentes-web-setup
```

2. Dê permissão e execute o script:

```bash
chmod +x setup.sh
./setup.sh
```

> 💡 **Dica:** você pode rodar o script como usuário normal. Os comandos com `sudo` já estão integrados no próprio script.

3. Após o término, reinicie o terminal ou execute:

```bash
source ~/.zshrc
```

---

## ⚡ Aliases criados

O script adiciona automaticamente aliases no arquivo `~/.pentest_aliases`, que é carregado via `.zshrc`.

Exemplos úteis:

```zsh
# Fuzzing básico de diretórios
alias ff='ffuf -u https://target.com/FUZZ -w ~/tools/SecLists/Discovery/Web-Content/common.txt'

# Diretórios mais profundos (admin, painel, etc)
alias ffadmin='ffuf -u https://target.com/FUZZ -w ~/tools/SecLists/Discovery/Web-Content/big.txt'

# Teste de Local File Inclusion
alias fflfi='ffuf -u https://target.com/page=FUZZ -w ~/tools/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt'

# Força bruta com Hydra
alias hydraweb='hydra -L ~/tools/SecLists/Usernames/top-usernames-shortlist.txt -P ~/tools/SecLists/Passwords/Common-Credentials/10k-most-common.txt'

# Lançar ferramentas rapidamente
alias burp='burpsuite'
alias xss='python3 ~/tools/XSStrike/xsstrike.py'
alias recon='python3 ~/tools/AutoRecon/autorecon.py'
alias httpx='httpx -silent -status-code -title'
```

---

## 💬 Sugestões e contribuições

Sinta-se à vontade para abrir uma [Issue](https://github.com/seu-usuario/pentes-web-setup/issues) ou enviar um Pull Request com melhorias, correções ou sugestões de ferramentas.

---

## 🧠 Requisitos

- Arch Linux ou baseado (Ex: EndeavourOS, Manjaro)
- Terminal ZSH
- Conexão com a internet
- `yay` instalado (o script assume que já está presente)

---

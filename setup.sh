LOG_FILE="$HOME/pentest-web-setup.log"

echo "[*] Log iniciado: $(date)" | tee "$LOG_FILE"

log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

# Função para instalar pacotes se não estiverem presentes
install_pacman_pkg() {
  if ! pacman -Qi "$1" &>/dev/null; then
    log "[+] Instalando $1 via pacman..."
    sudo pacman -S --noconfirm "$1" 2>&1 | tee -a "$LOG_FILE"
  else
    log "[-] $1 já instalado (pacman). Pulando..."
  fi
}

install_yay_pkg() {
  if ! yay -Qi "$1" &>/dev/null; then
    log "[+] Instalando $1 via yay..."
    yay -S --noconfirm "$1" 2>&1 | tee -a "$LOG_FILE"
  else
    log "[-] $1 já instalado (yay). Pulando..."
  fi
}

log "[*] Iniciando setup de ferramentas para pentest web (ZSH)..."

log "[*] Atualizando pacotes..."
sudo pacman -Syu --noconfirm 2>&1 | tee -a "$LOG_FILE"

# Pacotes via pacman
pacman_packages=(
  nmap
  whatweb
  sqlmap
  nikto
  hydra
  wireshark-qt
  mitmproxy
  httpie
  jq
  docker
)

log "[*] Instalando pacotes via pacman..."
for pkg in "${pacman_packages[@]}"; do
  install_pacman_pkg "$pkg"
done

log "[*] Habilitando Docker..."
sudo systemctl enable --now docker 2>&1 | tee -a "$LOG_FILE"

# Pacotes via yay
yay_packages=(
  burpsuite
  ffuf
  dirsearch
  amass
  subfinder-bin
  httpx
  nuclei
  metasploit
  insomnia
)

log "[*] Instalando pacotes via yay (AUR)..."
for pkg in "${yay_packages[@]}"; do
  install_yay_pkg "$pkg"
done

# Diretório base
TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"
cd "$TOOLS_DIR"

# XSStrike
if [ ! -d "$TOOLS_DIR/XSStrike" ]; then
  log "[*] Clonando XSStrike..."
  git clone https://github.com/s0md3v/XSStrike.git 2>&1 | tee -a "$LOG_FILE"
  cd XSStrike && pip install -r requirements.txt 2>&1 | tee -a "$LOG_FILE"
  cd ..
else
  log "[-] XSStrike já está presente. Pulando..."
fi

# AutoRecon
if [ ! -d "$TOOLS_DIR/AutoRecon" ]; then
  log "[*] Clonando AutoRecon..."
  git clone https://github.com/Tib3rius/AutoRecon.git 2>&1 | tee -a "$LOG_FILE"
  cd AutoRecon && pip install -r requirements.txt 2>&1 | tee -a "$LOG_FILE"
  cd ..
else
  log "[-] AutoRecon já está presente. Pulando..."
fi

# SecLists
if [ ! -d "$TOOLS_DIR/SecLists" ]; then
  log "[*] Clonando SecLists..."
  git clone https://github.com/danielmiessler/SecLists.git "$TOOLS_DIR/SecLists" 2>&1 | tee -a "$LOG_FILE"
else
  log "[-] SecLists já está presente. Pulando..."
fi

# Aliases
ALIASES_FILE="$HOME/.pentest_aliases"
SECLISTS="$TOOLS_DIR/SecLists"

log "[*] Criando aliases personalizados..."

ALIASES_CONTENT=$(cat <<EOF
alias burp='burpsuite'
alias ff='ffuf -u https://target.com/FUZZ -w $SECLISTS/Discovery/Web-Content/common.txt'
alias ffadmin='ffuf -u https://target.com/FUZZ -w $SECLISTS/Discovery/Web-Content/big.txt'
alias fflfi='ffuf -u https://target.com/page=FUZZ -w $SECLISTS/Fuzzing/LFI/LFI-Jhaddix.txt'
alias httpx='httpx -silent -status-code -title'
alias xss='python3 ~/tools/XSStrike/xsstrike.py'
alias recon='python3 ~/tools/AutoRecon/autorecon.py'
alias hydraweb='hydra -L $SECLISTS/Usernames/top-usernames-shortlist.txt -P $SECLISTS/Passwords/Common-Credentials/10k-most-common.txt'
EOF
)

# Apenas escreve o arquivo se ele não existir ou estiver diferente
if [[ ! -f "$ALIASES_FILE" || "$(cat "$ALIASES_FILE")" != "$ALIASES_CONTENT" ]]; then
  echo "$ALIASES_CONTENT" > "$ALIASES_FILE"
  log "[+] Aliases criados/atualizados em $ALIASES_FILE"
else
  log "[-] Aliases já estão atualizados. Pulando..."
fi

# Adicionar ao .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q "source ~/.pentest_aliases" "$ZSHRC"; then
  echo "source ~/.pentest_aliases" >> "$ZSHRC"
  log "[+] Adicionado 'source ~/.pentest_aliases' ao $ZSHRC"
else
  log "[-] $ZSHRC já está incluindo os aliases. Pulando..."
fi

# Oh My Zsh (opcional)
if [ -d "$HOME/.oh-my-zsh" ]; then
  log "[*] Oh My Zsh detectado. Deseja instalar 'zsh-autosuggestions'? (s/n)"
  read -r install_plugin
  if [[ "$install_plugin" == "s" ]]; then
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [ ! -d "$PLUGIN_DIR" ]; then
      git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR" 2>&1 | tee -a "$LOG_FILE"
      sed -i 's/plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/' "$ZSHRC"
      log "[+] Plugin adicionado ao .zshrc"
    else
      log "[-] Plugin já instalado. Pulando..."
    fi
  fi
fi

log "[✔] Setup concluído com sucesso!"
log "[📄] Log completo salvo em: $LOG_FILE"


echo "[*] Iniciando setup de ferramentas para pentest web (ZSH)..."

# Atualização do sistema
sudo pacman -Syu --noconfirm

# Instalação via pacman
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

echo "[*] Instalando pacotes via pacman..."
for pkg in "${pacman_packages[@]}"; do
  sudo pacman -S --noconfirm $pkg
done

# Habilitar Docker
sudo systemctl enable --now docker

# Instalação via yay
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

echo "[*] Instalando pacotes via yay (AUR)..."
for pkg in "${yay_packages[@]}"; do
  yay -S --noconfirm $pkg
done

# Diretório base para ferramentas manuais
TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"
cd "$TOOLS_DIR"

# XSStrike
if [ ! -d "$TOOLS_DIR/XSStrike" ]; then
  echo "[*] Clonando XSStrike..."
  git clone https://github.com/s0md3v/XSStrike.git
  cd XSStrike && pip install -r requirements.txt && cd ..
fi

# AutoRecon
if [ ! -d "$TOOLS_DIR/AutoRecon" ]; then
  echo "[*] Clonando AutoRecon..."
  git clone https://github.com/Tib3rius/AutoRecon.git
  cd AutoRecon && pip install -r requirements.txt && cd ..
fi

# SecLists
if [ ! -d "$TOOLS_DIR/SecLists" ]; then
  echo "[*] Clonando SecLists..."
  git clone https://github.com/danielmiessler/SecLists.git "$TOOLS_DIR/SecLists"
fi

# Criar aliases
ALIASES_FILE="$HOME/.pentest_aliases"
SECLISTS="$TOOLS_DIR/SecLists"

echo "[*] Criando aliases em $ALIASES_FILE..."
cat <<EOF > "$ALIASES_FILE"
alias burp='burpsuite'
alias ff='ffuf -u https://target.com/FUZZ -w $SECLISTS/Discovery/Web-Content/common.txt'
alias ffadmin='ffuf -u https://target.com/FUZZ -w $SECLISTS/Discovery/Web-Content/big.txt'
alias fflfi='ffuf -u https://target.com/page=FUZZ -w $SECLISTS/Fuzzing/LFI/LFI-Jhaddix.txt'
alias httpx='httpx -silent -status-code -title'
alias xss='python3 ~/tools/XSStrike/xsstrike.py'
alias recon='python3 ~/tools/AutoRecon/autorecon.py'
alias hydraweb='hydra -L $SECLISTS/Usernames/top-usernames-shortlist.txt -P $SECLISTS/Passwords/Common-Credentials/10k-most-common.txt'
EOF

# Adicionar source ao .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q "source ~/.pentest_aliases" "$ZSHRC"; then
  echo "source ~/.pentest_aliases" >> "$ZSHRC"
  echo "[*] Aliases adicionados ao $ZSHRC"
else
  echo "[*] Aliases já presentes no $ZSHRC"
fi

# Detectar Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "[*] Oh My Zsh detectado. Deseja instalar 'zsh-autosuggestions'? (s/n)"
  read -r install_plugin
  if [[ "$install_plugin" == "s" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/' "$ZSHRC"
    echo "[*] Plugin adicionado ao .zshrc. Recarregue o terminal para aplicar."
  fi
fi

echo "[✔] Setup concluído. Rode 'source ~/.zshrc' ou reinicie o terminal para carregar os aliases."


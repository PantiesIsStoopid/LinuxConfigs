# Initial GitHub.com Connectivity Check With 1 Second Timeout
CanConnectToGitHub=$(ping -c 1 -W 1 github.com > /dev/null 2>&1 && echo "True" || echo "False")

# Initialize Zoxide
eval "$(zoxide init bash)"

# Initialize Oh My Posh for Bash
if command -v oh-my-posh &> /dev/null; then
  # Check if Oh My Posh is installed
  export POSH_THEMES_PATH="$HOME/.poshthemes"  # Define the theme path
  
  # Set the desired theme (change to any theme you prefer)
  export POSH_THEME="cobalt2"  # You can use other themes available in $POSH_THEMES_PATH
  
  # Initialize Oh My Posh
  eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/$POSH_THEME.omp.json)"
else
  echo "Oh My Posh is not installed. Please install it from https://github.com/JanDeDobbeleer/oh-my-posh."
fi

# Function To Update Profile
UpdateProfile() {
  if [ "$CanConnectToGitHub" != "True" ]; then
    echo "Skipping Profile Update Check Due To GitHub.com Not Responding Within 1 Second."
    return
  fi


  Url="https://raw.githubusercontent.com/PantiesIsStoopid/LinuxConfigs/refs/heads/master/.bashrc"  # URL of the raw profile on GitHub
  OldHash=$(sha256sum "$HOME/.bashrc" | awk '{print $1}')
  curl -sL "$Url" -o "/tmp/.bashrc.tmp"
  NewHash=$(sha256sum "/tmp/.bashrc.tmp" | awk '{print $1}')
  
  if [ "$NewHash" != "$OldHash" ]; then
    mv -f "/tmp/.bashrc.tmp" "$HOME/.bashrc"
    echo "Profile Has Been Updated. Please Restart Your Shell To Reflect Changes."
  fi
}

UpdateProfile

# Function To Update System Packages
UpdateSystem() {
  if [ "$CanConnectToGitHub" != "True" ]; then
    echo "Skipping System Update Check Due To GitHub.com Not Responding Within 1 Second."
    return
  fi

  echo "Checking For System Updates..."
  sudo apt update && sudo apt upgrade -y  # Adjust For Your Distro (Use Yay Or Pacman For Arch)
  echo "System Updated. Please Restart Your Shell To Reflect Changes."
}

UpdateSystem

# Check If Terminal Is VS Code Terminal
TerminalType() {
  if [[ $TERM_PROGRAM == "vscode" ]]; then
    echo "VS Code Terminal"
  else
    echo "Unknown Terminal"
  fi
}

# Get Terminal Type And Print It
TerminalType=$(TerminalType)
echo "$TerminalType"

# Function To Show System Information
SysInfo() {
  uname -a
  lscpu
}

# Function To List All Files
La() {
  ls -l
}

# Function To List All Files Including Hidden
Ll() {
  ls -la
}

# Function To Flush DNS (Linux-Specific)
FlushDns() {
  sudo systemd-resolve --flush-caches
  echo "DNS Cache Flushed"
}

# Function To Print Public IP
GetPubIp() {
  curl -s http://ifconfig.me/ip
}

# Function To Print Private IP
GetPrivIp() {
  ip addr show | grep inet | grep -v inet6 | awk '{print $2}' | cut -d/ -f1
}

# Function To Run Speedtest
Speedtest() {
  echo "Running Speedtest..."
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3
  echo "Pinging 1.1.1.1"
  ping -c 4 1.1.1.1
  echo "Pinging 8.8.8.8"
  ping -c 4 8.8.8.8
}

# Function To Open Current Directory In File Explorer (Linux-Specific)
Fe() {
  xdg-open .
}

# Alias For Common Directories
Alias Docs="cd ~/Documents"
Alias Dtop="cd ~/Desktop"
Alias Dloads="cd ~/Downloads"
Alias Root="cd /"

# Git Shortcuts
Alias Gs="git status"
Alias Ga="git add ."
Alias Gc="git commit -m"
Alias Gp="git push"
Alias G="zoxide cd github"
Alias Gcl="git clone"

# Function To Show Help
ShowHelp() {
  Cat <<EOF
Bash Profile Help
=======================

Directory Navigation:
- Docs: Changes To The User's Documents Folder.
- Dtop: Changes To The User's Desktop Folder.
- Dloads: Changes To The User's Downloads Folder.
- Root: Changes To The Root Directory.

File And System Information:
- La: Lists All Files In The Current Directory.
- Ll: Lists All Files, Including Hidden, In The Current Directory.
- SysInfo: Displays Detailed System Information.
- GetPubIp: Retrieves The Public IP Address Of The Machine.
- GetPrivIp: Retrieves The Private IP Address Of The Machine.
- Speedtest: Runs A Speedtest For Your Internet.

System Maintenance:
- FlushDns: Clears The DNS Cache.
- Speedtest: Runs A Speedtest And Ping Test.

Utility Functions:
- Fe: Opens File Explorer In Your Current Directory.

Git Function:
- Gs: Shortcut For 'git status'.
- Ga: Shortcut For 'git add .'.
- Gc <Message>: Shortcut For 'git commit -m'.
- Gp: Shortcut For 'git push'.
EOF
}

# Enable Color For Ls
Alias Ls="ls --color=auto"

# Reload Terminal Profile
ReloadProfile() {
  Source ~/.bashrc
}

# Random Password Generator
RandomPassword() {
  Length=$1
  < /dev/urandom Tr -dc 'A-Za-z0-9' | Head -c $Length
}

# Display Random Fact
RandomFact() {
  Curl -s https://uselessfacts.jsph.pl/random.json?language=en | Jq -r '.text'
}

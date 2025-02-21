# Set error action to stop on any error
$ErrorActionPreference = "Stop"
#Requires -RunAsAdministrator
Clear-Host

# Install Git using winget
Write-Host "Download Bash" -ForegroundColor Green
winget install --id Git.Git -e --source winget --location "C:\Program Files\Git"

# Get Git and Zsh installation paths
$gitPath = ((Get-Command git).Path).Replace('cmd\git.exe','')
$zshPath = ((Get-Command git).Path).Replace('Git\cmd\git.exe','Zsh\')

# Create Zsh directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $zshPath 1> $null
echo "Zsh directory created at `"$zshPath`""

# Copy Git files to Zsh directory
Copy-Item -Path "$gitPath\*" -Destination "$zshPath" -Recurse -Force 1> $null
echo "Copy of Git files to Zsh directory complete"

# Download logos for Git and Zsh
Invoke-WebRequest "https://gitforwindows.org/img/gwindows_logo.png" -OutFile "$gitPath\logo.png"
Invoke-WebRequest "https://raw.githubusercontent.com/Zsh-art/logo/refs/heads/main/png/color_logomark.png" -OutFile "$zshPath\logo.png"

# ZSH Installation section
echo ""
Write-Host "Download ZSH" -ForegroundColor Green
echo "Download the latest MSYS2 zsh package
The file will be named something along the lines of ``zsh-#.#-#-x86_64.pkg.tar.zst``"
Start-Process "https://packages.msys2.org/packages/zsh?repo=msys&variant=x86_64"

# Option to follow external instructions or continue with script
echo ""
$confirmation = Read-Host "Now you need to follow the instructions in the forum ``dev.to``(y) or read here(n)"
if ($confirmation -eq 'y') {
  Start-Process "https://dev.to/equiman/zsh-on-windows-without-wsl-4ah9"
  exit
}

# ZSH setup instructions
echo ""
Write-Host "Installing ZSH" -ForegroundColor Green
echo "Extract the contents of the archive inside ``$zshPath`` your Git Bash installation directory.
Merge the contents of the folder if asked (no files should be getting overridden)."

echo ""
Write-Host "Setting up ZSH" -ForegroundColor Green
echo "Open the Zsh Bash terminal and run ``zsh --version`` command, then verify the installed version."
echo ("You can find it here: ``$zshPath\bin\bash.exe``.").Replace('\\','\')
echo "
Configure ``zsh`` as the default shell by appending the following to your ~/.bashrc file:
``if [ -t 1 ] && [ -f `"/usr/bin/zsh.exe`" ]; then exec zsh; fi``"

# Oh My Zsh installation
echo "
"
Write-Host "Installing Oh my zsh!" -ForegroundColor Green
echo "Run the following command in the zsh bash to install Oh My Zsh: ``sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)`"``
Download the font: `"https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k`""

# Download and install MesloLGS NF font
$confirmation = Read-Host "Do you want to download the font? (y/n)"
if ($confirmation -eq 'y') {
  $downloadsPath = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
  Invoke-WebRequest "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -OutFile "$downloadsPath\MesloLGS NF Regular.ttf"
  (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$downloadsPath\MesloLGS NF Regular.ttf",0x10)
}

# Install Powerlevel10k theme
echo ""
Write-Host "Add the Theme" -ForegroundColor Green
echo "Run the following command in the zsh bash to install the theme: ``git clone https://github.com/romkatv/powerlevel10k.git `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k``"

# Configure Zsh settings
echo ""
Read-Host "Waiting until cloning end then press Enter"
echo "Updating `"~/.zshrc`" and creating `"~/.p10k.zsh`""
$rawUrl = "https://raw.githubusercontent.com/Ayato-san/bash-config/refs/heads/main"
foreach ($file in @('.zshrc', '.p10k.zsh')) {
  Invoke-WebRequest "$rawUrl/$file" -OutFile "$env:USERPROFILE\$file"
}

# Install Zsh plugins
echo ""
Write-Host "Plugins" -ForegroundColor Green
$OhMyZshPath = "$env:USERPROFILE\.oh-my-zsh"
echo "Add the plugins to ZSH, run the following commands:
  git clone https://github.com/zsh-users/zsh-autosuggestions.git `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate"

# Setup custom plugins and completions
New-Item -ItemType Directory -Force -Path "$OhMyZshPath\custom\plugins\custom" 1> $null
Invoke-WebRequest "$rawUrl/plugins/custom/custom.plugin.zsh" -OutFile "$OhMyZshPath\custom\plugins\custom\custom.plugin.zsh"

echo "Adding completion"
New-Item -ItemType Directory -Force -Path "$OhMyZshPath\completions" 1> $null
foreach ($completion in @('docker', 'eza', 'gh', 'golang', 'node', 'npm', 'terraform', 'yarn')) {
  Invoke-WebRequest "$rawUrl/completions/_$completion" -OutFile "$OhMyZshPath\completions\_$completion"
}

# Install Eza (modern replacement for ls)
echo "
Installing Eza"
winget install eza-community.eza

# VS Code terminal configuration instructions
echo ""
Write-Host "VS Code" -ForegroundColor Green
echo "Add this lines to your settings.json file:"
echo "
`"terminal.integrated.profiles.windows`": {
  `"Git Bash`": {
    `"path`": `"C:\\Program Files\\Git\\bin\\bash.exe`",
    `"args`": [`"--login`", `"-i`"],
    `"icon`": `"git-branch`"
  },
  `"Zsh`": {
    `"overrideName`": true,
    `"path`": `"C:\\Program Files\\Zsh\\bin\\bash.exe`",
    `"args`": [`"--login`", `"-i`"],
    `"icon`": `"percentage`"
  }
},
`"terminal.integrated.fontFamily`": `"MesloLGS NF`",
`"terminal.integrated.shellIntegration.enabled`": true,
`"terminal.integrated.defaultProfile.windows`": `"Zsh`",
`"terminal.integrated.bellDuration`": 0,
`"terminal.integrated.persistentSessionReviveProcess`": `"never`"
"

# Windows Terminal configuration instructions
Write-Host "Terminal" -ForegroundColor Green
echo "Add this lines to your settings.json file:"
echo "
{
  `"commandline`": `"C:\\Program Files\\Git\\bin\\bash.exe`",
  `"guid`": `"{e993bb43-92e8-4555-bdb4-adf7b5e083fb}`",
  `"hidden`": false,
  `"icon`": `"C:\\Program Files\\Git\\logo.png`",
  `"name`": `"Git Bash`"
},
{
  `"commandline`": `"C:\\Program Files\\Zsh\\bin\\bash.exe`",
  `"font`": {
    `"face`": `"MesloLGS NF`"
  },
  `"guid`": `"{898f232a-94df-4c34-9b37-5d17412fd215}`",
  `"hidden`": false,
  `"icon`": `"C:\\Program Files\\Zsh\\logo.png`",
  `"name`": `"Zsh`"
}
"
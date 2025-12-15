# Install MonoGame on Linux Mint Cheatsheet

## NOTE
This is a cheatsheet for setting up MonoGame with working effect file compilation on Linux Mint. 
Use either the Official script or the Inofficial script. 

## Install .NET 9 SDK
* `sudo apt-get update && sudo apt-get install -y dotnet-sdk-9.0`

## Optional: Workloads for mobile development
* `dotnet workload install android ios maui`

## Official script: Setup Wine for effect compilation
* `sudo apt-get install -y wget curl p7zip-full wine64`
* `wget -qO- https://monogame.net/downloads/net9_mgfxc_wine_setup.sh | bash`

## Inofficial script: Setup Wine for effect compilation (effect compilation support for older MonoGame versions)
* `wget -qO- https://raw.githubusercontent.com/Kwyrky/mgfxc-wine-setup/refs/heads/main/mgfxc-wine-setup.sh | bash`

## Install MonoGame templates
* `dotnet new install MonoGame.Templates.CSharp`

## Useful command to list installed MonoGame templates
* `dotnet new list MonoGame`

## Install VS Code
* Download and install `.deb` package from https://code.visualstudio.com/

## Install VS Code using a script
```sh
#!/bin/bash

set -e  # Exit on any error

echo "=================================="
echo "VS Code Installation Script"
echo "for Linux Mint"
echo "=================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run this script as root or with sudo"
   echo "The script will ask for sudo password when needed"
   exit 1
fi

# Update package lists
echo "[1/5] Updating package lists..."
sudo apt-get update

# Install prerequisites
echo "[2/5] Installing prerequisites..."
sudo apt-get install -y wget gpg apt-transport-https

# Install Microsoft GPG key
echo "[3/5] Installing Microsoft GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Add VS Code repository
echo "[4/5] Adding VS Code repository..."
sudo bash -c 'cat > /etc/apt/sources.list.d/vscode.sources << EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF'

# Update package lists and install VS Code
echo "[5/5] Installing Visual Studio Code..."
sudo apt-get update
sudo apt-get install -y code
```

## Install VS Code extensions
* `code --install-extension ms-dotnettools.csdevkit`
* `code --install-extension r88.monogame`
* `code --install-extension ms-dotnettools.dotnet-maui`

## Setup a new Project "**MyMonoGameProject**" using the `mgdesktopgl` template
```sh
mkdir MyMonoGameProject
cd MyMonoGameProject

# Optional: Create a solution
dotnet new sln -n MyMonoGameProject

dotnet new mgdesktopgl -n MyMonoGameProject

# If you created the solution --> Add the new project to the solution
dotnet sln MyMonoGameProject.sln add MyMonoGameProject/MyMonoGameProject.csproj

dotnet build MyMonoGameProject.sln

dotnet run --project MyMonoGameProject/MyMonoGameProject.csproj
```

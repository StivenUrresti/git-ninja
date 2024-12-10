#!/bin/bash

# Colores para mensajes del instalador
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BOLD="\033[1m"
RESET="\033[0m"

REPO_URL="https://raw.githubusercontent.com/StivenUrresti/git-ninja/master/git-ninja.sh"
SCRIPT_NAME="git-ninja.sh"
INSTALL_PATH="/usr/local/bin/git-ninja"
ALIAS_NAME="git-ninja"

# Verificar si el script se está ejecutando con permisos de administrador
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${YELLOW}⚠️ Warning:${RESET} This installer requires administrative privileges."
    echo -e "👉 Please run the installation with 'sudo' to ensure proper installation."
    exit 1
fi

echo -e "${BOLD}🔧 Installing Git Ninja for global usage...${RESET}"

# Descargar el script desde GitHub
echo -e "🌐 Downloading Git Ninja script from $REPO_URL..."
curl -fsSL "$REPO_URL" -o "$SCRIPT_NAME"

# Verificar si la descarga fue exitosa
if [[ ! -f "$SCRIPT_NAME" ]]; then
    echo -e "${RED}❌ Error:${RESET} Unable to download '$SCRIPT_NAME'."
    exit 1
fi

# Copiar el script al directorio global
echo "📂 Copying '$SCRIPT_NAME' to '$INSTALL_PATH'..."
cp "$SCRIPT_NAME" "$INSTALL_PATH"

# Configurar permisos de ejecución
echo "🔧 Setting executable permissions..."
chmod +x "$INSTALL_PATH"

# Agregar el alias en el archivo de configuración del shell
if [[ -f ~/.bashrc ]]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [[ -f ~/.zshrc ]]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo -e "${RED}❌ Error:${RESET} Could not find a valid shell configuration file."
    exit 1
fi

echo -e "\n# Git Ninja alias" >> "$CONFIG_FILE"
echo "alias git-ninja='bash $INSTALL_PATH'" >> "$CONFIG_FILE"

# Informar al usuario sobre la configuración del alias
echo -e "${GREEN}✅ Alias 'git-ninja' added to your shell configuration file!${RESET}"
echo -e "👉 You can now use the command: '${BOLD}git-ninja${RESET}'"

# Recargar el archivo de configuración del shell
echo -e "🔄 Reloading shell configuration..."
source "$CONFIG_FILE"

# Confirmar la instalación
if [[ -f "$INSTALL_PATH" ]]; then
    echo -e "${GREEN}✅ Git Ninja installed globally!${RESET}"
    echo -e "👉 You can now use it by typing '${BOLD}git-ninja${RESET}' in your terminal."
    echo -e "📘 For help, run: ${BOLD}git-ninja --help${RESET}"
else
    echo -e "${RED}❌ Installation failed.${RESET} Please check permissions or try again."
    exit 1
fi

#!/bin/bash

# Colores para mensajes del instalador
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BOLD="\033[1m"
RESET="\033[0m"

# URL del repositorio en GitHub (modifica con tu URL)
REPO_URL="https://github.com/StivenUrresti/git-ninja/blob/master/git-ninja.sh"

# Nombre del script principal
SCRIPT_NAME="git-ninja.sh"
INSTALL_PATH="/usr/local/bin/git-ninja"

echo -e "${BOLD}🔧 Installing Git Ninja for global usage...${RESET}"

# Verificar si el archivo principal existe en la URL
echo -e "🌐 Downloading Git Ninja script from $REPO_URL/$SCRIPT_NAME..."
curl -fsSL "$REPO_URL/$SCRIPT_NAME" -o "$SCRIPT_NAME"

# Verificar si el archivo se descargó correctamente
if [[ ! -f "$SCRIPT_NAME" ]]; then
    echo -e "${RED}❌ Error:${RESET} Unable to download '$SCRIPT_NAME'."
    exit 1
fi

# Verificar permisos de administrador
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${YELLOW}⚠️ Warning:${RESET} This installer needs administrative privileges."
    echo -e "👉 Run with 'sudo': ${BOLD}sudo ./install.sh${RESET}"
    exit 1
fi

# Copiar el script al PATH global
echo "📂 Copying '$SCRIPT_NAME' to '$INSTALL_PATH'..."
sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"

# Asegurarse de que sea ejecutable
echo "🔧 Setting executable permissions..."
sudo chmod +x "$INSTALL_PATH"

# Confirmación de instalación
if [[ -f "$INSTALL_PATH" ]]; then
    echo -e "${GREEN}✅ Git Ninja installed globally!${RESET}"
    echo -e "👉 You can now use it by typing '${BOLD}git-ninja${RESET}' in your terminal."
    echo -e "📘 For help, run: ${BOLD}git-ninja --help${RESET}"
else
    echo -e "${RED}❌ Installation failed.${RESET} Please check permissions or try again."
    exit 1
fi

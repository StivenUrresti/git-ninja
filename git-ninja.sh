#!/bin/bash

# ============================
# Git Ninja - Fast Mode ⚡
# ============================

RED="\033[31m"
GREEN="\033[32m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

set -e


# Clear screen and print header
clear
cat << EOF

 ██████╗ ██╗████████╗    ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
██╔════╝ ██║╚══██╔══╝    ████╗  ██║██║████╗  ██║     ██║██╔══██╗
██║  ███╗██║   ██║       ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
██║   ██║██║   ██║       ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
╚██████╔╝██║   ██║       ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
 ╚═════╝ ╚═╝   ╚═╝       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                
EOF

echo -e "Silent as a shadow, swift as the wind. Automate Git like a true ninja! ⚡"
echo -e "🔥 ${GREEN}${BOLD}Welcome to Git Ninja!${RESET} 🚀"
echo -e "${CYAN}Streamline your commits, branches, and more with ease.${RESET}"

set -e

# Verificar si estamos en un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}❌ Error:${RESET} No estás en un repositorio Git."
    exit 1
fi

# Obtener el nombre del repositorio y la rama actual
repo_name=$(basename "$(git rev-parse --show-toplevel)")
current_branch=$(git rev-parse --abbrev-ref HEAD)

echo -e "🚀 ${CYAN}${BOLD}Git Ninja - Fast Mode ⚡${RESET}"
echo -e "🗂️  ${CYAN}Repositorio:${RESET} $repo_name"
echo -e "🔢 ${CYAN}Rama actual:${RESET} $current_branch"

# Agregar todos los cambios
git add .

# Si no hay cambios para commitear, salir
if git diff --cached --quiet; then
    echo -e "${GREEN}✔ No hay cambios para subir.${RESET}"
    exit 0
fi

# Pedir mensaje de commit
read -p "📝 Ingresa el mensaje del commit: " commit_message
git commit -m "$commit_message"

# Animación de carga
echo -ne "📤 Subiendo cambios"
for i in {1..3}; do
    echo -ne "."
    sleep 0.5
done
echo ""

# Hacer push a la rama actual
git push

echo -e "✅ ${GREEN}Cambios subidos correctamente a '${BOLD}$current_branch'${RESET}"

#!/bin/bash

set -e

# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

output() {
  echo "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

panel=false
wings=false

output "Pterodactyl installation script"
output "This script is not associated with the official Pterodactyl Project."

output

while [ "$panel" == false ] && [ "$wings" == false ]; do
  output "What would you like to do?"
  output "[1] Install the panel"
  output "[2] Install the daemon (Wings)"
  output "[3] Install both on the same machine"

  echo -n "* Input 1-3: "
  read -r action

  case $action in
      1 )
          panel=true ;;
      2 )
          wings=true ;;
      3 )
          panel=true
          wings=true ;;
      * )
          error "Invalid option" ;;
  esac
done

[ "$panel" == true ] && bash <(curl -s https://raw.githubusercontent.com/ForestRacks/pterodactyl-installer/main/install-panel.sh)
[ "$wings" == true ] && bash <(curl -s https://raw.githubusercontent.com/ForestRacks/pterodactyl-installer/main/install-wings.sh)
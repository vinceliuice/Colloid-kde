#!/bin/bash

ROOT_UID=0
THEME_DIR="/usr/share/sddm/themes"
REO_DIR="$(cd $(dirname $0) && pwd)"

MAX_DELAY=20                                  # max delay for user to enter root password

#COLORS
CDEF=" \033[0m"                               # default color
CCIN=" \033[0;36m"                            # info color
CGSC=" \033[0;32m"                            # success color
CRER=" \033[0;31m"                            # error color
CWAR=" \033[0;33m"                            # waring color
b_CDEF=" \033[1;37m"                          # bold default color
b_CCIN=" \033[1;36m"                          # bold info color
b_CGSC=" \033[1;32m"                          # bold success color
b_CRER=" \033[1;31m"                          # bold error color
b_CWAR=" \033[1;33m"                          # bold warning color

# echo like ...  with  flag type  and display message  colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;    # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;    # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;    # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;    # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

install () {
  prompt -i "\n * Install Colloid${color} in ${THEME_DIR}... "
  rm -rf "${THEME_DIR}/Colloid${color}"
  cp -r "${REO_DIR}/Colloid" "${THEME_DIR}/Colloid${color}"
  cp -r "${REO_DIR}/images/Colloid${color}.png" "${THEME_DIR}/Colloid${color}/background.png"
  cp -r "${REO_DIR}/images/Preview${color}.png" "${THEME_DIR}/Colloid${color}/Preview.png"
  sed -i "/\Name=/s/Colloid/Colloid${color}/" "${THEME_DIR}/Colloid${color}/metadata.desktop"
  sed -i "/\Theme-Id=/s/Colloid/Colloid${color}/" "${THEME_DIR}/Colloid${color}/metadata.desktop"
  sed -i "s/Colloid/Colloid${color}/g" "${THEME_DIR}/Colloid${color}/Main.qml"
  # Success message
  prompt -s "\n * All done!"
}

# Checking for root access and proceed if it is present
if [ "$UID" -eq "$ROOT_UID" ]; then
  color="-light" && install
  color="-dark" && install
else
  # Error message
  prompt -e "\n [ Error! ] -> Run me as root ! "

  # persisted execution of the script as root
  read -p "[ Trusted ] Specify the root password : " -t${MAX_DELAY} -s
  [[ -n "$REPLY" ]] && {
    sudo -S <<< $REPLY $0
  } || {
    clear
    prompt -i "\n Operation canceled by user, Bye!"
    exit 1
  }
fi


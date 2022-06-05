#! /usr/bin/env bash

SRC_DIR=$(cd $(dirname $0) && pwd)

AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

THEME_NAME=Colloid
LATTE_DIR="$HOME/.config/latte"

COLOR_VARIANTS=('-light' '-dark')
THEME_VARIANTS=('' '-nord')

cp -rf "${SRC_DIR}"/configs/Xresources "$HOME"/.Xresources

mkdir -p                                                                                     ${AURORAE_DIR}
mkdir -p                                                                                     ${SCHEMES_DIR}
mkdir -p                                                                                     ${PLASMA_DIR}
mkdir -p                                                                                     ${LOOKFEEL_DIR}
mkdir -p                                                                                     ${KVANTUM_DIR}
mkdir -p                                                                                     ${WALLPAPER_DIR}

install() {
  local name=${1}
  local color=${2}
  local theme=${3}

  [[ ${color} == '-dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'
  [[ ${theme} == '-nord' ]] && local ELSE_THEME='Nord'

  local AURORAE_THEME="${AURORAE_DIR}/${name}${color}${theme}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}${color}${theme}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}${theme}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${ELSE_COLOR}${ELSE_THEME}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}${ELSE_THEME}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}${color}${theme}"
  local LATTE_THEME="${LATTE_DIR}/${name}.layout.latte"

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -f ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME}
  [[ -f ${LATTE_THEME} ]] && rm -rf ${LATTE_THEME}

  cp -r ${SRC_DIR}/aurorae/${name}${color}${theme}                                           ${AURORAE_DIR}
  cp -r ${SRC_DIR}/aurorae/${name}${color}-round${theme}                                     ${AURORAE_DIR}
  cp -r ${SRC_DIR}/aurorae/common${theme}/*                                                  ${AURORAE_DIR}/${name}${color}${theme}
  cp -r ${SRC_DIR}/aurorae/common${theme}/*                                                  ${AURORAE_DIR}/${name}${color}-round${theme}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}${ELSE_THEME}.colors                    ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}${ELSE_THEME}                                              ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}-dark                                          ${PLASMA_THEME}

  if [[ "${color}" == '-light' ]]; then
    cp -r ${SRC_DIR}/plasma/desktoptheme/${name}-light/*                                     ${PLASMA_THEME}
  fi

  if [[ "${theme}" == '-nord' ]]; then
    sed -i "s/${name}${color}/${name}${color}${theme}/g"                                     ${PLASMA_THEME}/metadata.desktop
  fi

  cp -r ${SRC_DIR}/plasma/desktoptheme/icons                                                 ${PLASMA_THEME}
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}${theme}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${color}${theme}                                         ${WALLPAPER_DIR}
  mkdir -p                                                                                   ${PLASMA_THEME}/wallpapers
  cp -r ${SRC_DIR}/wallpaper/${name}${color}${theme}                                         ${PLASMA_THEME}/wallpapers
  cp -r ${SRC_DIR}/latte-dock/${name}.layout.latte                                           ${LATTE_THEME}
}

echo "Installing '${THEME_NAME} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
    install "${name:-${THEME_NAME}}" "${color}" "${theme}"
  done
done

echo "Install finished..."

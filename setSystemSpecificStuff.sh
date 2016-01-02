#!/bin/bash
STARTING_DIR=`pwd`
TMP_DIR=${STARTING_DIR}/tmp
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
BIN_DIR=/usr/bin


case "$DESKTOP_SESSION" in
"gnome" | "GNOME")
	DROPDOWN_TERMINAL="guake"
    USER_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
    ;;
"mate" | "MATE" | "lxde" | "LXDE")
	DROPDOWN_TERMINAL="tilda"
    ;;
"kde" | "KDE")
	DROPDOWN_TERMINAL="yakuake"
    ;;
*)
    error "Not supported graphical environment: $DESKTOP_SESSION"
    ;;
esac


if hash apt-get 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="apt-get install"
    PACKAGE_MANAGER="apt-get"
elif hash yum 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="yum install"
    PACKAGE_MANAGER="yum"
elif hash pacman 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="pacman -S"
    PACKAGE_MANAGER="packman"
elif hash pact 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="pact install"
    PACKAGE_MANAGER="pact"
elif hash brew 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="brew install"
    PACKAGE_MANAGER="brew"
else
    error "Did not find any of the supported package managers (apt-get/yum/pacman)";
fi

if [[ `arch` =~ .*64.* ]]
then
    ARCH=64
else
    ARCH=32
fi

#!/bin/bash
STARTING_DIR=`pwd`
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR=${STARTING_DIR}/tmp
USER_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
BIN_DIR=/usr/bin
SERVICES_DIR=/etc/systemd/system

if hash apt-get 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="apt-get update; apt-get install"
    PACKAGE_MANAGER="apt-get"
elif hash yum 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="yum install"
    PACKAGE_MANAGER="yum"
elif hash pacman 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="pacman -Syu"
    PACKAGE_MANAGER="pacman"
elif hash pact 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="pact install"
    PACKAGE_MANAGER="pact"
elif hash brew 2>/dev/null;
then
    PACKAGE_MANAGER_INSTALL_CMD="brew install"
    PACKAGE_MANAGER="brew"
else
    echo "WARNING: Did not find any of the supported package managers (apt-get/yum/pacman), packages installation not supported";
    PACKAGE_MANAGER_INSTALL_CMD="echo 'ERROR: No package managers detected, cannot install'"
    PACKAGE_MANAGER="NONE"
fi

ARCH=$(getconf LONG_BIT)

#!/bin/bash

. functions.sh
#INSTALL_DIR=/opt/devtools
#sudo_or_fail mkdir -p $INSTALL_DIR
STARTING_DIR=`pwd`
TMP_DIR=${STARTING_DIR}/tmp
echo "Creating temporary installation directory at $INSTALL_DIR"
run_or_fail mkdir $TMP_DIR
git config --global credential.helper "cache --timeout=5"

function install_base_packages {
    echo 'Installing base packages'
    echo '|'
    echo '*--installing drop-down terminal'
    install_package $DROPDOWN_TERMINAL
    echo '|'
    echo '*--installing git'
    install_package git
    echo '|'
    echo '*--installing vim'
    install_package vim
    echo '|'
    echo '*--installing curl'
    install_package curl
}; do_or_skip install_base_packages

function recompile_vim_from_sources {
    echo 'Compiling vim: '
    ./compile_vim.sh
}; do_or_skip recompile_vim_from_sources

function install_bashrc {
    echo '|'
    echo '*--installing my bashrc'
    cd $TMP_DIR
    run_or_fail git clone https://bitbucket.org/mexorsu/bashrc
    cd bashrc
    sudo_or_fail ./install.sh
}; do_or_skip install_bashrc

function install_vimrc {
    echo '|'
    echo '*--installing my vimrc'
    cd $TMP_DIR
    run_or_fail git clone https://bitbucket.org/mexorsu/vimrc
    cd vimrc
    sudo_or_fail ./install.sh
}; do_or_skip install_vimrc

function install_java {
    echo '|'
    echo '*--installing newest jdk'
    cd $TMP_DIR
    run_or_fail git clone https://bitbucket.org/mexorsu/java-installer
    cd java-installer
    ./java_installator.sh --jdk `yes | ./java_installator.sh 2>/dev/null 1>&2; ./java_installator.sh -l | grep '[09]\.[09]\.[09]_[09][09]*' | sort -V | tail -1`
}; do_or_skip install_java

cd $STARTING_DIR

echo "Removing temporary installation directory: $INSTALL_DIR"
run_or_fail rm -rf $TMP_DIR

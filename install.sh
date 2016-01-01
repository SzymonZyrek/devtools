#!/bin/bash

. functions.sh
#INSTALL_DIR=/opt/devtools
#sudo_or_fail mkdir -p $INSTALL_DIR
echo "Creating temporary installation directory at $INSTALL_DIR"
run_or_fail mkdir $TMP_DIR
git config --global credential.helper "cache --timeout=5"

function install_base_packages {
    cat packages.general > packages.list
    cat "packages.$PACKAGE_MANAGER" > packages.list
    PACKAGES=`cat packages.list`
    echo "Installing base packages: $PACKAGES"
    #rm packages.list
    sudo_or_warn apt-get install $PACKAGES
}; 


function recompile_vim_from_sources {
    echo 'Compiling vim: '
    ./compile_vim.sh
};

function install_bashrc {
    echo '|'
    echo '*--installing my bashrc'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/bashrc
    cd bashrc
    sudo_or_warn ./install.sh
};


function install_vimrc {
    echo '|'
    echo '*--installing my vimrc'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/vimrc
    cd vimrc
    sudo_or_warn ./install.sh
}; 

function install_java {
    echo '|'
    echo '*--installing newest jdk'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/java-installer
    cd java-installer
    ./java_installator.sh --jdk `yes | ./java_installator.sh 2>/dev/null 1>&2; ./java_installator.sh -l | grep '[0-9]\.[0-9]\.[0-9]_[0-9][0-9]*' | sort -V | tail -1`
};

do_or_skip install_base_packages
do_or_skip recompile_vim_from_sources
do_or_skip install_bashrc
do_or_skip install_vimrc
do_or_skip install_java

cd $STARTING_DIR

echo "Removing temporary installation directory: $INSTALL_DIR"
run_or_fail rm -rf $TMP_DIR

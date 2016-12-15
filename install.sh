#!/bin/bash

source $(echo 'y' | wget https://bitbucket.org/mexorsu/installutil/get/master.zip -q -O master.zip ; echo 'y' | unzip master.zip 2>/dev/null 1>&2 -d master ; find master -name util.sh)

#INSTALL_DIR=/opt/devtools
#sudo_or_fail mkdir -p $INSTALL_DIR

function install_dropdown_terminal {
    echo '|'
    echo "*--installing $DROPDOWN_TERMINAL"
    sudo_or_warn $PACKAGE_MANAGER_INSTALL_CMD $DROPDOWN_TERMINAL
};

function recompile_vim_from_sources {
    echo '|'
    echo '*--compiling vim: '
    ./compile_vim.sh
};

function install_bashrc {
    echo '|'
    echo '*--installing my bashrc'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/bashrc
    cd bashrc
    run_or_warn ./install.sh
};

function install_vimrc {
    echo '|'
    echo '*--installing my vimrc'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/vimrc
    cd vimrc
    run_or_warn ./install.sh
};

function install_java {
    echo '|'
    echo '*--installing newest jdk'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/java-installer
    cd java-installer
    ./java_installator.sh --jdk `yes | ./java_installator.sh 2>/dev/null 1>&2; ./java_installator.sh -l | grep '[0-9]\.[0-9]\.[0-9]_[0-9][0-9]*' | sort -V | tail -1` --target /usr/lib/jvm
};

function install_eclipse {
    echo '|'
    echo '*--installing eclipse from dropbox'
    cd $TMP_DIR
    run_or_warn . $SCRIPT_DIR/installEclipse.sh
};

function install_eclim {
    echo '|'
    echo '*--installing eclim from dropbox'
    cd $TMP_DIR
    run_or_warn . $SCRIPT_DIR/installEclim.sh
};

function install_zsh {
    echo '|'
    echo '*--installing zsh'
    sudo_or_warn $PACKAGE_MANAGER_INSTALL_CMD zsh
    echo '|'
    echo '*--installing oh-my-zsh'
    cd $TMP_DIR
    run_or_warn sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
};

function install_powerline_fonts {
    echo '|'
    echo '*--installing powerline fonts'
    cd $TMP_DIR
    run_or_warn git clone https://github.com/powerline/fonts
    cd fonts
    ./install.sh
}

function install_base_packages {
    sudo_or_warn cat packages/${PACKAGE_MANAGER} | xargs -I% sudo $PACKAGE_MANAGER_INSTALL_CMD %
}

function install_wallpaper_rotator {
    echo '|'
    echo '*--installing my wallpaper_rotator'
    cd $TMP_DIR
    run_or_warn git clone https://bitbucket.org/mexorsu/wallpaper-rotator
    cd wallpaper-rotator
    run_or_warn ./install.sh
}

do_or_skip install_base_packages
do_or_skip install_zsh
do_or_skip recompile_vim_from_sources
do_or_skip install_bashrc
do_or_skip install_vimrc
do_or_skip install_powerline_fonts
do_or_skip install_java
do_or_skip install_eclipse
do_or_skip install_eclim
do_or_skip install_wallpaper_rotator
cd $STARTING_DIR

the_end

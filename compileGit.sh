#!/bin/bash

START_DIR="$(pwd)"

function get_git_sources {
    if [[ "$1" != "" ]]; then
        GIT_SOURCE_DIR="$1"
    elif hash git 2>/dev/null; then
        git clone https://github.com/git/git.git git
        GIT_SOURCE_DIR="$(pwd)/git"
    elif hash wget 2>/dev/null; then
        wget https://github.com/git/git/archive/master.zip
        unzip master.zip
        GIT_SOURCE_DIR="$(pwd)/git-master"
    else
        echo "No git or wget found on the system, you need to provide git source folder path manually (as a command line arg)"
        exit 1
    fi
}

function install_required_packages {
    if hash apt-get 2>/dev/null; then
        sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
            libz-dev libssl-dev asciidoc xmlto docbook2x wget
    elif hash yum 2>/dev/null; then
        sudo yum install curl-devel expat-devel gettext-devel \
              openssl-devel perl-devel zlib-devel asciidoc xmlto docbook2x wget
    fi  
}

function compile_git {
    cd $GIT_SOURCE_DIR
    ./configure --prefix=/usr
    make all doc info
    sudo make install install-doc install-html install-info
    cd $START_DIR
}

function cleanup {
    rm -rf $GIT_SOURCE_DIR
}

install_required_packages
get_git_sources
compile_git
cleanup
exit 0

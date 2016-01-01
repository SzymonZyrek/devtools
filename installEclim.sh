#!/bin/bash
if [[ "$FUNCTIONS_ARE_THERE" == "" ]]
then
    . functions.sh
fi

DEFAULT_ECLIPSE_INSTALLATION_DIR=/opt/eclipse
ECLIPSE_INSTALLATION_DIR=""
while [[ "$ECLIPSE_INSTALLATION_DIR" == "" ]]
do
    echo "Your eclipse installation folder?: ($DEFAULT_ECLIPSE_INSTALLATION_DIR)"
    read LINE
    if [[ $LINE != "" ]]
    then
        if [[ "`check_if_root_place $LINE`" == "true" ]]
        then
            echo "You've got your eclipse installed on the root's path, and it's gonna be a pain in the ass to use eclim like this. Give me another eclipse path or crtl+c"
        else
            ECLIPSE_INSTALLATION_DIR=$LINE
        fi
    else
        ECLIPSE_INSTALLATION_DIR=$DEFAULT_ECLIPSE_INSTALLATION_DIR
    fi
done

DEFAULT_VIM_INSTALLATION_DIR=$HOME/.vim
VIM_INSTALLATION_DIR=""
while [[ "$VIM_INSTALLATION_DIR" == "" ]]
do
    echo "Your .vim folder?: ($DEFAULT_VIM_INSTALLATION_DIR)"
    read LINE
    if [[ $LINE != "" ]]
    then
        if [[ "`check_if_root_place $LINE`" == "true" ]]
        then
            echo "Yeah, you just can't install eclim it if you're .vim is in root's path, give me another .vim or crtl+c"
        else
            VIM_INSTALLATION_DIR=$LINE
        fi
    else
        VIM_INSTALLATION_DIR=$DEFAULT_VIM_INSTALLATION_DIR
    fi
done

run_or_fail wget https://www.dropbox.com/s/df368ifu9qerznb/eclim.jar?dl=0 -O eclim.jar
run_or_fail java -Dvim.files=$VIM_INSTALLATION_DIR -Declipse.home=$ECLIPSE_INSTALLATION_DIR -jar eclim.jar install

rm -rf eclim.jar

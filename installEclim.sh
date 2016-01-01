#!/bin/bash
if [[ "$FUNCTIONS_ARE_THERE" == "" ]]
then
    . functions.sh
fi

DEFAULT_ECLIPSE_INSTALLATION_DIR=/opt/eclipse
echo "Your eclipse installation folder?: ($DEFAULT_ECLIPSE_INSTALLATION_DIR)"
read LINE
if [[ $LINE != "" ]]
then
    ECLIPSE_INSTALLATION_DIR=$LINE
else
    ECLIPSE_INSTALLATION_DIR=$DEFAULT_ECLIPSE_INSTALLATION_DIR
fi

DEFAULT_VIM_INSTALLATION_DIR=$HOME/.vim
echo "Your .vim folder?: ($DEFAULT_VIM_INSTALLATION_DIR)"
read LINE
if [[ $LINE != "" ]]
then
    VIM_INSTALLATION_DIR=$LINE
else
    VIM_INSTALLATION_DIR=$DEFAULT_VIM_INSTALLATION_DIR
fi

run_or_fail wget https://www.dropbox.com/s/df368ifu9qerznb/eclim.jar?dl=0 -O eclim.jar
if [[ "`check_if_root_place $VIM_INSTALLATION_DIR`" == "true" ]] || [[ "`check_if_root_place $ECLIPSE_INSTALLATION_DIR`" == "true" ]]
then
    sudo_or_fail java -Dvim.files=$VIM_INSTALLATION_DIR -D eclipse.home=$ECLIPSE_INSTALLATION_DIR -jar eclim.jar install
else
    run_or_fail java -Dvim.files=$VIM_INSTALLATION_DIR -D eclipse.home=$ECLIPSE_INSTALLATION_DIR -jar eclim.jar install
fi
rm -rf eclim.jar

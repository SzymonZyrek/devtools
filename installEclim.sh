#!/bin/bash
if [[ "$FUNCTIONS_ARE_THERE" == "" ]]
then
    . functions.sh
fi

DEFAULT_ECLIPSE_INSTALLATION_DIR=/opt/eclipse
ECLIPSE_INSTALLATION_DIR=""
while [[ "$ECLIPSE_INSTALLATION_DIR" == "" ]]
do
    echo "Your eclipse installation folder?"
    read LINE
    if [[ $LINE != "" ]]
    then
        if [[ "`check_if_root_place $LINE`" == "true" ]]
        then
            ECLIPSE_INSTALLATION_DIR=$LINE
            DEFAULT_ECLIPSE_LOCAL_HOME=$HOME/.eclipse
            ECLIPSE_LOCAL_HOME=""
            while [[ "$ECLIPSE_LOCAL_HOME" == "" ]]
            do
               echo "You've got your eclipse installed on the root's path, so instead of installing eclim there, point to your users local eclipse directory.($DEFAULT_ECLIPSE_LOCAL_HOME)"
                read INNER_LINE
                if [[ $INNER_LINE != "" ]]
                then
                    if [[ "`check_if_root_place $INNER_LINE`" == false ]]
                    then
                        echo "Ok, you're eclipse local dir rly rly can't be on a root's path. Cmon, just give me some dir inside your /home folder mate.."
                    else
                        ECLIPSE_LOCAL_HOME=$INNER_LINE
                        if ! [[ -e $ECLIPSE_LOCAL_HOME ]]
                        then
                            mkdir -p $ECLIPSE_LOCAL_HOME
                        fi
                    fi
                else
                    ECLIPSE_LOCAL_HOME=$DEFAULT_ECLIPSE_LOCAL_HOME
                fi
            done
        else
            ECLIPSE_INSTALLATION_DIR=$LINE
        fi
    else
        echo "Dude, you really must tell me where is your eclipse, no defaults here.."
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
if [[ "$ECLIPSE_LOCAL_HOME" == "" ]]
then
    run_or_fail java -Dvim.files=$VIM_INSTALLATION_DIR -Declipse.home=$ECLIPSE_INSTALLATION_DIR -jar eclim.jar install
else
    run_or_fail java -Dvim.files=$VIM_INSTALLATION_DIR -Declipse.home=$ECLIPSE_INSTALLATION_DIR -Declipse.local=$ECLIPSE_LOCAL_HOME -jar eclim.jar install
fi

rm -rf eclim.jar

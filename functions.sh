#!/bin/bash


function error {
    echo -e $@
    rm -rf $TMP_DIR
    exit 1
}; trap "error '*--Terminated!'" SIGINT SIGTERM

. setSystemSpecificStuff.sh

function run_or_fail {
    echo "\$ $@"
    $@ 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        error "Command execution failed:\n\t\$ $@\nReason:\n\t$ERR_MSG";	
	fi
}

function run_or_warn {
    echo "\$ $@"
    $@ 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        echo "Command execution failed:\n\t\$ $@\nReason:\n\t$ERR_MSG";	
        while true; do
            read -p "Do you want to continue?" ysn
            case $ysn in
                [Yy]* ) echo "M'kay, moving along, nothing to see here.."; break;;
                [Nn]* ) error $ERR_MSG; break;;
                * ) echo "It's an yes/no question m8..";;
            esac
        done
	fi
}

function sudo_or_fail {
    CMD="sudo $@"
    echo "\$ $CMD"
    $CMD 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        error "Command execution failed:\n\t\$ $@\nReason:\n\t$ERR_MSG";	
	fi
}

function sudo_or_warn {
    CMD="sudo $@"
    echo "\$ $CMD"
    $CMD 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        echo "Command execution failed:\n\t\$ $@\nReason:\n\t$ERR_MSG";	
        while true; do
            read -p "Do you want to continue?" yn
            case $yn in
                [Yy]* ) echo "M'kay, moving along, nothing to see here.."; break;;
                [Nn]* ) error $ERR_MSG; break;;
                * ) echo "It's an yes/no question m8..";;
            esac
        done
	fi
}

function install_package {
    echo "--installing $@";
    if hash apt-get 2>/dev/null; 
    then
        run_or_warn "sudo apt-get install $@";
    elif hash yum 2>/dev/null;
    then
        run_or_warn "sudo yum install $@";
    else
        error "Did not find any of the supported package managers (apt-get/yum)";
    fi
}

# path
function check_if_root_place {
    if [[ -e $1 ]]
    then
        if [[ "`stat -c %U $1 | grep root | wc -l`" == "1" ]]
        then
            echo true
        else
            echo false
        fi
    else
        check_if_root_place `echo $1 | sed -e 's#^\(.*\)/[^/]*$#\1#'`
    fi
}

# name, path
function create_shortcut {
    echo "SCRIPT_DIR:$SCRIPT_DIR"
    APP_NAME=$1
    EXEC_PATH=$2
    ICON_PATH=$3
    FILE_NAME="${APP_NAME}.desktop"
    FILE_PATH=$SCRIPT_DIR/$FILE_NAME
    if [[ "$ICON_PATH" == "" ]]
    then
        ICON_PATH=$SCRIPT_DIR/default-icon.png
    fi
    cp $SCRIPT_DIR/template.desktop $FILE_PATH
    
    SED_CMD="s#^\\(Name=\\)#\\1$APP_NAME#"
    #SED_CMD="'$SED_CMD'"
    echo "sed -i $SED_CMD $FILE_PATH"
    sed -i $SED_CMD $FILE_PATH
    
    SED_CMD="s#^\\(Exec=\\)#\\1$EXEC_PATH#"
    #SED_CMD="'$SED_CMD'"
    echo "sed -i $SED_CMD $FILE_PATH"
    sed -i $SED_CMD $FILE_PATH
    
    SED_CMD="s#^\\(Icon=\\)#\\1$ICON_PATH#"
    #SED_CMD="'$SED_CMD'"
    echo "sed -i $SED_CMD $FILE_PATH"
    sed -i $SED_CMD $FILE_PATH
    
    chmod +x $FILE_PATH
    mv $FILE_PATH $USER_DESKTOP_DIR

    #sudo update-alternatives --install /usr/bin/$1 $1 $2 1
}

function do_or_skip {
    yn=""
    TEXT="**** Do you want to run: '$@' ?****"
	while true; do
        read -p "$TEXT" yn
        case $yn in
            [Yy]* ) $@; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
	done
}

#path, [icon]
function install_bin {
    EXEC_PATH=$(realpath $1)
    APP_NAME=$(basename $EXEC_PATH)
    BIN_PATH=${BIN_DIR}/${APP_NAME}
    echo "Installing $APP_NAME"
    sudo_or_fail update-alternatives --install $BIN_PATH $APP_NAME $EXEC_PATH 1
    run_or_fail create_shortcut $APP_NAME $BIN_PATH $2
}

FUNCTIONS_ARE_THERE="true"

#!/bin/bash
if [[ $FUNCTIONS_ARE_THERE == 1 ]]
then
    exit 0
else
    FUNCTIONS_ARE_THERE=1
fi

declare -A SCRIPTS_LOADED
. setSystemSpecificStuff.sh
echo "Creating temporary installation directory at $TMP_DIR"



#################### FUNCTIONS ######################

#args: script_path
function load {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    if ! [ $((SCRIPTS_LOADED[$1])) -eq 1 ]
    then
        . $1
        SCRIPTS_LOADED[$1]=1
    fi
}

#args: [message]
function error {
    echo -e $@
    the_end
    exit 1
}; trap "error '*--Terminated!'" SIGINT SIGTERM

function the_end {
    echo "Removing temporary installation directory: $TMP_DIR"
    run_or_fail rm -rf $TMP_DIR
}

#args: command
function run_or_fail {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    echo "\$ $@"
    $@ 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        error "Command execution failed:\n\t\n\$ $@\nReason:\n\t$ERR_MSG";	
	fi
}


#args: command
function run_or_warn {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    echo "\$ $@"
    $@ 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        printf "$@ command execution failed, because:\n\t$ERR_MSG\n";	
        if get_yes_no "Do you want to continue?" 
        then
            echo "M'kay, moving along, nothing to see here..";
        else
            error $ERR_MSG;
        fi
	fi
}

#args: command
function sudo_or_fail {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
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

#args: command
function sudo_or_warn {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    CMD="sudo $@"
    echo "\$ $CMD"
    $CMD 2>.err.tmp;
    RESULT=$?
    ERR_MSG=`cat .err.tmp 2>/dev/null`;
    rm .err.tmp 2>/dev/null; 
    
	if [ $RESULT -ne 0 ]
    then
        echo "Command execution failed:\n\t\$ $@\nReason:\n\t$ERR_MSG";	
        if get_yes_no "Do you want to continue?" 
        then
            echo "M'kay, moving along, nothing to see here..";
        else
            error $ERR_MSG;
        fi
	fi
}

#args: path
function check_if_root_place {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
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

#args:  app_name, exec_path, [icon]
function create_shortcut {
    if [[ $# < 2  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
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
    run_or_warn sed -i $SED_CMD $FILE_PATH
    
    SED_CMD="s#^\\(Exec=\\)#\\1$EXEC_PATH#"
    run_or_warn sed -i $SED_CMD $FILE_PATH
    
    SED_CMD="s#^\\(Icon=\\)#\\1$ICON_PATH#"
    run_or_warn sed -i $SED_CMD $FILE_PATH
    
    chmod +x $FILE_PATH
    mv $FILE_PATH $USER_DESKTOP_DIR

}

#args: [text_to_ask]
#returns: true/false using exit codes (0/1 respectively- yeah, mindfuck)
function get_yes_no {
    yn=""
    while true; do
        read -p "$1" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "(y/n)";;
        esac
	done
}

#args: command
function do_or_skip {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    if get_yes_no "**** Do you want to run: '$@' ****"
    then
        $@;
    fi
}


#args: exec_path
function install_bin {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi
    EXEC_PATH=$(realpath $1)
    APP_NAME=$(basename $EXEC_PATH | sed -e 's#^\(.*\)\.[^.]*$#\1#')
    BIN_PATH=${BIN_DIR}/${APP_NAME}
    echo "Installing $APP_NAME to $BIN_PATH"
    if hash update-alternatives 2>/dev/null;
    then
        sudo_or_fail update-alternatives --install $BIN_PATH $APP_NAME $EXEC_PATH 1
    else
        sudo_or_fail ln -sf $EXEC_PATH $BIN_PATH
    fi
}

#args: exec_path, [icon]
function install_app {
    install_bin $1
    run_or_fail create_shortcut $APP_NAME $BIN_PATH $2
}

#args: exec_path, [stage]
function install_service {
    if [[ $# < 1  ]]; then error "$(basename $0):${LINENO}:  not enough args supplied to ${FUNCNAME[0]} function" ; fi   
    install_bin $1
    sudo_or_fail chmod 755 $BIN_PATH

    TEMPLATE_FILE="$SCRIPT_DIR/template.service"
    FILE_PATH="$SCRIPT_DIR/$APP_NAME.service"
    cp $TEMPLATE_FILE $FILE_PATH
    
    SED_CMD="s#^\\(Description=\\)#\\1$APP_NAME-service#"
    run_or_warn sed -i $SED_CMD $FILE_PATH
    
    SED_CMD="s#^\\(ExecStart=\\)#\\1$BIN_PATH#"
    run_or_warn sed -i $SED_CMD $FILE_PATH
    
    if [[ $# -ge 2 ]]
    then
        SED_CMD="s#^\\(WantedBy=.*\\)#\\1$2#"
        run_or_warn sed -i $SED_CMD $FILE_PATH
    fi
    
    SERVICE_NAME=$(basename $FILE_PATH)

    sudo_or_fail mv $FILE_PATH $SERVICES_DIR
    sudo_or_fail systemctl enable $SERVICE_NAME 
}
run_or_warn mkdir $TMP_DIR

install_service netstart.sh

#!/bin/bash
source $(echo 'y' | wget https://bitbucket.org/mexorsu/installutil/get/master.zip -q -O master.zip ; echo 'y' | unzip master.zip 2>/dev/null 1>&2 -d master ; find master -name util.sh)
DEFAULT_INSTALLATION_DIR=/opt

if [[ "$ARCH" =~ "64" ]]
then
   DOWNLOAD_LINK="https://www.dropbox.com/s/fxhyitiif71u5l4/eclipse64.tar.gz?dl=0"
else
   DOWNLOAD_LINK="https://www.dropbox.com/s/89qosah4ui7legx/eclipse32.tar.gz?dl=0"
fi

echo "Eclipse installation folder: (/opt)"
read LINE
if [[ $LINE != "" ]]
then
    ECLIPSE_INSTALLATION_DIR=$LINE
else
    ECLIPSE_INSTALLATION_DIR=$DEFAULT_INSTALLATION_DIR
fi


run_or_fail wget $DOWNLOAD_LINK -O eclipse.tar.gz
run_or_fail tar -xzf eclipse.tar.gz
run_or_warn rm eclipse.tar.gz

if [[ "`check_if_root_place $ECLIPSE_INSTALLATION_DIR`" == "true" ]]
then
    sudo_or_warn mkdir -p $ECLIPSE_INSTALLATION_DIR
    sudo_or_fail mv eclipse $ECLIPSE_INSTALLATION_DIR
    sudo_or_fail chown root $ECLIPSE_INSTALLATION_DIR/eclipse
    sudo_or_fail chmod +x $ECLIPSE_INSTALLATION_DIR/eclipse/eclipse
else
    run_or_warn mkdir -p $ECLIPSE_INSTALLATION_DIR
    run_or_fail mv eclipse $ECLIPSE_INSTALLATION_DIR
fi

install_app $ECLIPSE_INSTALLATION_DIR/eclipse/eclipse $ECLIPSE_INSTALLATION_DIR/eclipse/icon.xpm

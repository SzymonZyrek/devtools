#!/bin/bash
source $(echo 'y' | wget https://bitbucket.org/mexorsu/installutil/get/master.zip -q -O master.zip ; echo 'y' | unzip master.zip 2>/dev/null 1>&2 -d master ; find master -name util.sh)

install_service $SCRIPT_DIR/netstart.sh
sudo_or_fail chmod 755 $BIN_DIR/netstart
sudo_or_fail mv netstart.service /etc/systemd/system
sudo_or_fail systemctl enable netstart.service

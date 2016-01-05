#!/bin/bash
. ../devtools/util.sh
install_service $SCRIPT_DIR/netstart.sh
sudo_or_fail chmod 755 $BIN_DIR/netstart
sudo_or_fail mv netstart.service /etc/systemd/system
sudo_or_fail systemctl enable netstart.service

#!/bin/bash
source $(echo 'y' | wget https://bitbucket.org/mexorsu/installutil/get/master.zip -q -O master.zip ; echo 'y' | unzip master.zip 2>/dev/null 1>&2 -d master ; find master -name util.sh)
install_bin $SCRIPT_DIR/kupka.sh
the_end

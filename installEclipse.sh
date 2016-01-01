#!/bin/bash

. functions.sh

if [[ "$ARCH" == "64" ]]
then
   DOWNLOAD_LINK="https://www.dropbox.com/s/89qosah4ui7legx/eclipse32.tar.gz?dl=0"
else
   DOWNLOAD_LINK="https://www.dropbox.com/s/fxhyitiif71u5l4/eclipse64.tar.gz?dl=0"
fi

run_or_fail wget $DOWNLOAD_LINK -O eclipse.tar.gz




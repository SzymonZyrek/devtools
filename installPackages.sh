#!/bin/bash
. util
TMP_PCK_FILE_NAME="packages.list"
load setSystemSpecificStuff.sh

cat "packages/packages.general" > $TMP_PCK_FILE_NAME
cat "packages/packages.$PACKAGE_MANAGER" >> $TMP_PCK_FILE_NAME
PACKAGES=`cat $TMP_PCK_FILE_NAME`
echo "Installing base packages: $PACKAGES"
rm $TMP_PCK_FILE_NAME
sudo_or_warn $PACKAGE_MANAGER_INSTALL_CMD $PACKAGES

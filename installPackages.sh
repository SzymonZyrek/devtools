#!/bin/bash
. util.sh
TMP_PCK_FILE_NAME="$SCRIPT_DIR/packages.list"

cat "$SCRIPT_DIR/packages/general" > $TMP_PCK_FILE_NAME

cat "$SCRIPT_DIR/packages/$PACKAGE_MANAGER" >> $TMP_PCK_FILE_NAME
PACKAGES=`cat $TMP_PCK_FILE_NAME`
echo "Installing base packages: $PACKAGES"
#rm $TMP_PCK_FILE_NAME
sudo $PACKAGE_MANAGER_INSTALL_CMD $PACKAGES

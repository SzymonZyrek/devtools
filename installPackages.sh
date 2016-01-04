#!/bin/bash

if [[ "$SYSTEM_SPECIFIC_STUFF" != "true" ]]
then
    . setSystemSpecificStuff.sh
fi

cat packages.general > packages.list
cat "packages.$PACKAGE_MANAGER" >> packages.list
PACKAGES=`cat packages.list`
echo "Installing base packages: $PACKAGES"
rm packages.list
sudo_or_warn $PACKAGE_MANAGER_INSTALL_CMD $PACKAGES


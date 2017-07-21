#!/bin/bash
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    ruby-dev git checkinstall
sudo apt-get remove vim vim-runtime gvim vim-common vim-tiny vim-gui-common
mkdir tmp
cd tmp
git clone https://github.com/vim/vim.git
cd vim

MAJ_VER=$(find . -name gvim_version.nsh | xargs sed -ne 's/!define VER_MAJOR //p')
MIN_VER=$(find . -name gvim_version.nsh | xargs sed -ne 's/!define VER_MINOR //p')
VIM_VERSION=${MAJ_VER}${MIN_VER}
if [[ "$VIM_VERSION" == "" ]]
then
	VIM_VERSION=$(git tag | tail -1 | sed -e 's/v\([0-9]\+\)\.\([0-9]\+\)\..*/\1\2/')
fi
if [[ "$VIM_VERSION" == "" ]]
then
	VIM_VERSION='generic'
fi
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim${VIM_VERSION}
sudo checkinstall
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
cd ../..
sudo rm -rf tmp
sudo apt-mark manual vim
vim --version
exit 0

#!/bin/bash
#
# bash-ftw installer
# author: Jonathan Tsai <hello@jontsai.com>
#

KERNEL=`uname -s`

##################################################
echo 'Installing bash-ftw...'
echo ''

##################################################
DIRECTORIES='bin code var tmp .ssh'

echo 'Creating directories...'

for DIR in $DIRECTORIES
do
    echo $HOME/$DIR
    mkdir -p $HOME/$DIR
done

echo ''

##################################################
echo "Installing scripts into $HOME/bin..."
cp bin/* $HOME/bin

echo ''

##################################################
echo "Setting up SSH..."

# Observe directory permissions for SSH carefully!
chmod 700 $HOME/.ssh
touch $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

echo ''

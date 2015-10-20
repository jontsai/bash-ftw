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
    mkdir -v -p $HOME/$DIR
done

echo ''

##################################################
echo "Installing scripts into $HOME/bin..."
cp -v bin/* $HOME/bin

echo ''

##################################################
echo "Setting up SSH..."

# Observe directory permissions for SSH carefully!
chmod 700 $HOME/.ssh
touch $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

echo ''

##################################################
echo "Installing dotfiles (.bashrc*)..."

if [ $KERNEL == 'Darwin' ] && [ -f $HOME/.bash_profile ]
then
    BASHRC_FILE=$HOME/.bash_profile
elif [ -f $HOME/.bash_aliases ]
then
    BASHRC_FILE=$HOME/.bash_aliases
elif [ -f $HOME/.bashrc ]
then
    BASHRC_FILE=$HOME/.bashrc
else
    BASHRC_FILE=''
fi

if [[ $BASHRC_FILE ]]
then 
    cp -v dotfiles/.bashrc.ftw $HOME/
    cp -v dotfiles/.git-completion.bash $HOME/
    INSTALL_BASHRC_SOURCE="[[ -s \"$HOME/.bashrc.ftw\" ]] && source $HOME/.bashrc.ftw"
    echo "$INSTALL_BASHRC_SOURCE" >> $BASHRC_FILE
    if [ $KERNEL == 'Darwin' ]
    then
        echo .bashrc.ftw.mac
        cp -v dotfiles/.bashrc.ftw.mac $HOME/
    fi
else
    echo 'Not installing .bashrc.ftw'
fi

echo ''

##################################################
echo 'Finished installing bash-ftw!'
echo ''

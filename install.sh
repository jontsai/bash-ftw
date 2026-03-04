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
    INCLUDE_BASHRC_SOURCE="[[ -s \"\$HOME/.bashrc.ftw\" ]] && source \$HOME/.bashrc.ftw"
    # Check if line exists anywhere in the file
    if grep -qF "$INCLUDE_BASHRC_SOURCE" "$BASHRC_FILE"; then
        # Line exists - check if it's at the end
        LAST_LINE=$(tail -n 1 "$BASHRC_FILE")
        if [ "$LAST_LINE" == "$INCLUDE_BASHRC_SOURCE" ]; then
            echo "bash-ftw is already at the end of $BASHRC_FILE"
        else
            echo "Moving bash-ftw to end of $BASHRC_FILE"
            # Remove existing line(s) and re-add at end
            grep -vF "$INCLUDE_BASHRC_SOURCE" "$BASHRC_FILE" > "${BASHRC_FILE}.tmp"
            mv "${BASHRC_FILE}.tmp" "$BASHRC_FILE"
            echo "$INCLUDE_BASHRC_SOURCE" >> "$BASHRC_FILE"
        fi
    else
        echo "Adding bash-ftw include to $BASHRC_FILE"
        echo "$INCLUDE_BASHRC_SOURCE" >> "$BASHRC_FILE"
    fi
    if [ $KERNEL == 'Darwin' ]
    then
        echo .bash-ftw.mac
        cp -v dotfiles/.bashrc.ftw.mac $HOME/
    fi
    if [ $KERNEL == 'Linux' ]
    then
        echo .bash-ftw.linux
        cp -v dotfiles/.bashrc.ftw.linux $HOME/
    fi
else
    echo 'Not installing .bashrc.ftw'
fi

echo ''

##################################################
echo 'Finished installing bash-ftw!'
echo ''

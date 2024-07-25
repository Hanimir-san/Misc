#! /bin/bash

# set -o errexit
set -o nounset
set -o pipefail

# Check that script is being run with user admin privileges
if [ $EUID != 0 ];
then
    echo "This script must be run with superuser privileges!"
    exit 1 
fi

# Get distribution. Also test this whole thing. Running out of time so I'm pushing it without running.
declare -A OS_RELEASE;
OS_RELEASE[/etc/redhat-release]=yum
OS_RELEASE[/etc/arch-release]=pacman
OS_RELEASE[/etc/gentoo-release]=emerge
OS_RELEASE[/etc/SuSE-release]=zypp
OS_RELEASE[/etc/debian_version]=apt-get
OS_RELEASE[/etc/alpine-release]=apk

declare -s PKG_MAN;

for rel_file in ${OS_RELEASE[@]};
do
    if [ -f $rel_file];
    then
        PKG_MAN=${OS_RELEASE[$rel_File]}
    fi
done

# Install additional packages. Add more to intall.
PKG_MAN install neofetch

# TODO: Install Docker using their setup script

# Get current session user. This is important as the executing user will not have their rc file modified otherwise
# if env variable is unset for any reason, acquire it
USER_CURRENT=$USERNAME

if [ ! $USER_CURRENT ] ;
then
    USER_CURRENT=$(logname)
fi

echo "Running environment initialization for user $USER_CURRENT..."

# Get current user home directory. Cannot use HOME env variable as the script must be used with sudoer privileges
if [ $USER_CURRENT == "root" ]
then
    USER_CURRENT_HOME="/root"
else
    USER_CURRENT_HOME="/home/$USER_CURRENT"
fi

# Get appropriate read command file. Add other shell types as needed.
if [ $SHELL == "/bin/zsh" ] ;
then
    RC_FILE="zshrc"
elif [ $SHELL == "/bin/tcsh" ] ;
then
    RC_FILE="tcshrc"
elif [ $SHELL == "/bin/csh" ] ;
then
    RC_FILE="cshrc"
else
    RC_FILE="bashrc"
fi

RC_SYSTEM="/etc/$RC_FILE"
RC_TEMPLATE="/etc/skel/.$RC_FILE"
RC_USER_CURRENT="$USER_CURRENT_HOME/.$RC_FILE"

# Create a dummy file for testing the script. This section will be removed later
RC_SYSTEM=$RC_SYSTEM.test
RC_TEMPLATE=$RC_TEMPLATE.test
RC_USER_CURRENT=$RC_USER_CURRENT.test

touch RC_SYSTEM
touch RC_TEMPLATE
touch RC_USER_CURRENT

# Create backup of rc files 
cp -pr $RC_SYSTEM $RC_SYSTEM.bak
cp -pr $RC_TEMPLATE $RC_TEMPLATE.bak
cp -pr $RC_USER_CURRENT $RC_USER_CURRENT.bak

# Ensure system default umask is restrictive
echo "umask 0022" > $RC_SYSTEM

# Add common aliases to rc files
for RC in $RC_TEMPLATE $RC_USER_CURRENT ;
do
    if [ $(grep -c "alias ll=" $RC) -lt 1 ] ;
    then
        echo alias ll='ls -al' >> $RC
    fi
    if [ $(grep -c "alias now=" $RC) -lt 1 ] ;
    then
        echo alias now='date +"%T"' >> $RC
    fi
    if [ $(grep -c "alias vi=" $RC) -lt 1 ] ;
    then
    	echo alias vi='vim' >> $RC
    fi
    if [ $(grep -c "alias userls=" $RC) -lt 1 ] ;
    then
    	echo alias userls='cut -d : -f 1 /etc/passwd|sort' >> $RC
    if [ $(grep -c "alias groupls=" $RC) -lt 1 ] ;
    then
        echo alias groupls='cut -d : -f 1 /etc/group|sort' >> $RC
    fi
done
echo $RC_TEMPLATE
echo $RC_USER_CURRENT

# Add default groups and users if any
# Default should already exist and is "sudo" on Ubuntu and "wheel" on RHE

# Change sudo timeout to appropriate value
# Perform operation on a test file for now to not destroy the entire system
cp -p /etc/sudoers /etc/sudoers.test

# TODO: Add user welcome message to /etc/motd/
# TODO: Add docker container status to motd
# TODO: Add container status supervision script to crontab
# TODO: Add system resource supervision script to crontab
# TODO: Disallow SSH root access
# TODO: setup UFW
# TODO: Create default user with pw if current user is root
# TODO: Remove pw from bash history immediately

# Reloading shell for changes to take effect.
exec $SHELL

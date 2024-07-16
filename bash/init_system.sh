#! /bin/bash

# Check that script is being run with user admin privileges
if [ $EUID != 0 ];
then
    echo "This script must be run with superuser privileges!"
    exit 1 
fi

# Get current session user. If env variable is unset for any reason, acquire it
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
    if [ $(grep -c "alias groupls=" $RC) -lt 1 ] ;
    then
    	echo alias groupls='cat /etc/group|grep -Eo "^[^:]+"' >> $RC
    if [ $(grep -c "alias groupls=" $RC) -lt 1 ] ;
    then
        echo alias userls='cat /etc/passwd|grep -Eo "^[^:]+"' >> $RC
    fi
done
echo $RC_TEMPLATE
echo $RC_USER_CURRENT

# Add default groups and users

# Set appropriate default file and directory permissions

# Install docker
# Add user welcome message to /etc/motd/
# Add docker container status to motd
# Add container status supervision script to crontab
# Add system resource supervision script to crontab
# Disallow SSH root access
# setup UFW
# Create default user with pw
# Remove pw from bash history immediately

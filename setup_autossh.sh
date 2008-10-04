#!/bin/bash

# Create rsa keys on new server as root
sudo su root
ssh-keygen -t rsa

# copy the public rsa key to baobabhealth.org
# Your public key should allow you ssh access to baobab@baobabhealth.org
scp .ssh/id_rsa.pub baobab@baobabhealth.org
ssh baobab@baobabhealth.org "cat id_rsa.pub >> .ssh/authorized_keys"

# setup autossh
apt-get install autossh
echo "Select a port (http://spreadsheets.google.com/ccc?key=psoEj8H-O-Bwa9FGhdXmtVw&hl=en)"
read -e PORT

echo "#!/bin/sh
AUTOSSH_GATETIME=0 autossh -M 65218 -o GatewayPorts=yes -f -N -g -R *:$PORT:localhost:22 baobab@baobabhealth.org &" > /etc/init.d/autossh

# make it startup automatically
/usr/sbin/update-rc.d -f autossh defaults

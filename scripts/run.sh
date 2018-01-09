#!/bin/bash

useradd -m -d /home/$USERNAME -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME

# Enable user to sudo 
usermod -aG sudo $USERNAME

htpasswd -cb /etc/apache2/webdav.password $USERNAME $PASSWORD
chown root:$USERNAME /etc/apache2/webdav.password
chmod 640 /etc/apache2/webdav.password

mkdir -p /var/tmp/run
mkdir -p /var/tmp/lock/apache2
mkdir -p /var/tmp/log/apache2

chmod 777 -R /var/tmp

# Run upervisord
supervisord -c /etc/supervisor/supervisord.conf


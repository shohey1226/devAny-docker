#!/bin/bash

# create user
useradd -m -d /home/$USERNAME -u 7777 -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
usermod -aG sudo $USERNAME
cd /home/$USERNAME
ttyd -u 7777 -p 8080 /bin/bash &

htpasswd -cb /etc/apache2/webdav.password $USERNAME $PASSWORD
chown root:www-data /etc/apache2/webdav.password
chmod 640 /etc/apache2/webdav.password

apache2 -D FOREGROUND 


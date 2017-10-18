#!/bin/bash

# create user
useradd -m -d /home/$USERNAME -u 7777 -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
usermod -aG sudo $USERNAME

cd /home/$USERNAME
ttyd -c $USERNAME:$PASSWORD -u 7777 -p 8080 /bin/bash &  

htpasswd -cb /etc/apache2/webdav.password $USERNAME $PASSWORD
chown root:$USERNAME /etc/apache2/webdav.password
chmod 640 /etc/apache2/webdav.password

APACHE_RUN_USER=$USERNAME APACHE_RUN_GROUP=$USERNAME apache2 -D FOREGROUND


#! /bin/bash

#install apache
sudo apt-get --assume-yes update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install apache2

# Apply FW rules to accept connections on 22, 80 and 443
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable 

#restart apache service
sudo systemctl restart apache2
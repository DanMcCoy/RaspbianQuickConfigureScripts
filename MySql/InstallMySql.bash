#!/bin/bash
echo "Installing MySql"

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password onezeroone101'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password onezeroone101'
sudo apt-get -y install mysql-server

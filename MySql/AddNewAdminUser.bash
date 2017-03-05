mysql -uroot -ponezeroone101 -e "CREATE USER dan@'192.168.0.10' IDENTIFIED BY 'onezeroone101';"
mysql -uroot -ponezeroone101 -e "GRANT ALL PRIVILEGES ON *.* TO 'dan'@'192.168.0.10';"

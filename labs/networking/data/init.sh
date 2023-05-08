#!/bin/bash

sudo yum install mariadb-server -y
sudo systemctl enable mariadb

echo "[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
bind-address=0.0.0.0
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

\!includedir /etc/my.cnf.d" | sudo tee /etc/my.cnf > /dev/null

sudo systemctl start mariadb
mysql -u root -e "CREATE USER 'student'@'%' IDENTIFIED BY 'password';"
mysql -u root -e "CREATE DATABASE is311;"
mysql -u root is311 < /tmp/data/movies.sql
mysql -u root is311 -e "SELECT * from movies limit 1"

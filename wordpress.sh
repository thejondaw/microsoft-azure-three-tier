#!/bin/bash

# Install and configure Apache
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Install WGET and Unzip
yum install wget unzip -y

# Download and extract website template
wget https://www.free-css.com/assets/files/free-css-templates/download/page295/carint.zip
unzip carint.zip
mv carint-html/* /var/www/html/
setenforce 0

# Install and configure PHP 7.3
yum install epel-release yum-utils -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php73
yum install php php-mysqli -y
systemctl restart httpd

# Install WordPress
wget https://en-gb.wordpress.org/latest-en_GB.tar.gz
tar -xf latest-en_GB.tar.gz
rm -rf /var/www/html/*
mv wordpress/* /var/www/html/
chown -R apache:apache /var/www/html

# Install and configure MariaDB
yum install mariadb mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

# Secure MariaDB installation
mysql_secure_installation <<EOF
n
y
y
y
y
EOF

# Create database and user for WordPress
DB_NAME="${project-db}"
DB_USER="${adminuser}"
DB_PASSWORD="${pa$$w0rd}"

mysql -e "CREATE DATABASE $DB_NAME;"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'project-mysql-server.mysql.database.azure.com' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "FLUSH PRIVILEGES;"

# Log in to MySQL as the WordPress user
mysql -u $DB_USER -p
#!/bin/bash

# Disable SELinux
sudo getenforce
sudo sed 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/sysconfig/selinux -i
sudo setenforce 0

# Install Apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Install and configure MariaDB
sudo yum install mariadb mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
mysql_secure_installation <<EOF
n
y
y
y
y
EOF

# Install PHP 7.3
sudo yum install epel-release yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi-php73
sudo yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
sudo systemctl restart httpd

# Install WGET and Unzip
sudo yum install wget unzip -y

# Download and extract website template
wget https://www.free-css.com/assets/files/free-css-templates/download/page296/finexo.zip
unzip finexo.zip
mv finexo-html/* /var/www/html/

# Install Wordpress
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xf latest.tar.gz -C /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo chown -R apache:apache /var/www/html/

# Set-Up Database credentials
sudo sed 's/database_name_here/project-db/g' /var/www/html/wp-config.php -i
sudo sed 's/username_here/adminuser@project-mysql-server/g' /var/www/html/wp-config.php -i
sudo sed 's/password_here/pa$$w0rd/g' /var/www/html/wp-config.php -i
sudo sed 's/localhost/project-mysql-server.mysql.database.azure.com/g' /var/www/html/wp-config.php -i
#!/bin/bash

# Disable SELinux
sudo getenforce
sudo setenforce 0

# Install Apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Install WGET and Unzip
sudo yum install wget unzip -y

# Download and extract website template
wget https://www.free-css.com/assets/files/free-css-templates/download/page296/finexo.zip
unzip finexo.zip
mv finexo-html/* /var/www/html/



# Install PHP 7.3
sudo yum install epel-release yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi-php73
sudo yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
sudo systemctl restart httpd

# Install Wordpress
sudo wget https://en-gb.wordpress.org/latest-en_GB.tar.gz
sudo tar -xf latest-en_GB.tar.gz -C /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo chown -R apache:apache /var/www/html/

# Set-Up Database credentials
sudo sed -i 's/database_name_here/project-db/g' /var/www/html/wp-config.php
sudo sed -i 's/username_here/adminuser@project-mysql-server/g' /var/www/html/wp-config.php
sudo sed -i 's/password_here/pa$$w0rd/g' /var/www/html/wp-config.php
sudo sed -i 's/localhost/project-mysql-server.mysql.database.azure.com/g' /var/www/html/wp-config.php

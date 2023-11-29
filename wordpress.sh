#!/bin/bash

# Disable SELinux
getenforce
setenforce 0

# Install Apache
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Install WGET and Unzip
yum install wget unzip -y

# Download and extract website template
wget https://www.free-css.com/assets/files/free-css-templates/download/page296/finexo.zip
unzip finexo.zip
mv finexo-html/* /var/www/html/



# Install PHP 7.3
yum install epel-release yum-utils -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php73
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
systemctl restart httpd

# Install Wordpress
wget https://en-gb.wordpress.org/latest-en_GB.tar.gz
tar -xf latest-en_GB.tar.gz -C /var/www/html/
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
chown -R apache:apache /var/www/html/


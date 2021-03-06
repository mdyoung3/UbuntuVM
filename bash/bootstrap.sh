#!/bin/bash
#Variables used for testing

APPENV=local
DBHOST=localhost
DBNAME=drupal_dev
DBUSER=dbuser
DBPASSWD=oked_dev
##Setup and Initial Tools

sudo apt-get update

#Installing Apache Server
    sudo apt-get install -y -f apache2 
    #Verify Apache installed correctly
    
    #Make things easier for different users
    if ! apache2 -v 
    then
        sudo ln -s /usr/sbin/apache2 /usr/local/bin/
        alias apache="apache2"
        alias httpd="apache2"
    fi
    if apache2 -v
    then
        echo "Apache Successfully Installed"
    else
        echo "Apache Failed or is already installed"
    fi

#Configure Apache2
    sudo a2enmod rewrite
    sudo sed -i 11s/None/All/ /etc/apache2/sites-available/default
    sudo service apache2 restart

#Install assorted tools for version control and file editing
    sudo apt-get install -y -f vim curl git debconf-utils
    if git --version 
    then
        echo "Vim, Curl, and Git, Successfully Installed"
    else
        echo "Vim, Curl, and Git, Failed to Install"
    fi

echo -e "\n--- Install MySQL specific packages and settings ---\n"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password oked_dev'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password oked_dev'
sudo apt-get -y install mysql-server

echo -e "\n--- Setting up our MySQL user and db ---\n"
sudo mysql -u root -p $DBPASSWD -e "CREATE DATABASE $DBNAME"
sudo mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to 'root'@'localhost' identified by '$DBPASSWD'"

##Install PHP
echo "Begninning PHP installation"
    sudo apt-get install -y -f php5 php-pear php5-suhosin php5-mysql
    service apache2 restart
    if php -v 
    then
        echo "Php is now installed successfully"
    else
        echo "Php failed to install"
    fi

#Installing PhpMyAdmin
if [ ! -f /etc/phpmyadmin/config.inc.php ];
then

	# Used debconf-get-selections to find out what questions will be asked
	# This command needs debconf-utils

	# Handy for debugging. clear answers phpmyadmin: echo PURGE | debconf-communicate phpmyadmin

	sudo echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

	sudo echo 'phpmyadmin phpmyadmin/app-password-confirm password oked_dev' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/mysql/admin-pass password oked_dev' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/password-confirm password oked_dev' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/setup-password password oked_dev' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/database-type select mysql' | debconf-set-selections
	sudo echo 'phpmyadmin phpmyadmin/mysql/app-pass password oked_dev' | debconf-set-selections

	sudo echo 'dbconfig-common dbconfig-common/mysql/app-pass password oked_dev' | debconf-set-selections
	sudo echo 'dbconfig-common dbconfig-common/mysql/app-pass password' | debconf-set-selections
	sudo echo 'dbconfig-common dbconfig-common/password-confirm password oked_dev' | debconf-set-selections
	sudo echo 'dbconfig-common dbconfig-common/app-password-confirm password oked_dev' | debconf-set-selections
	sudo echo 'dbconfig-common dbconfig-common/app-password-confirm password oked_dev' | debconf-set-selections
	sudo echo 'dbconfig-common dbconfig-common/password-confirm password oked_dev' | debconf-set-selections

	sudo apt-get -y install phpmyadmin
fi

sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

sudo apt-get -y install zip
sudo apt-get -y install unzip
sudo apt-get -y install sl


sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 9M/' /etc/php5/apache2/php.ini
sudo service apache2 restart

echo "Your Virtual Machine is now ready, thank you for installing Project Deviant by David C. Rynearson at ASU OKED

Be sure to implement Drupal-addon.sh and module.sh to quickly spin up a Drupal site. "
exit

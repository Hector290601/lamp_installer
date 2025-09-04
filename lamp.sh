#!/bin/bash

function display_help {
	echo "Procesa.APP Installer"
	echo "AGPL3V0, Made by Hector Robles"
	echo "Contact: hector@roblesm.mx"
	echo "This script need to be runned as sudo user"
	echo "Simple usage: $ sudo bash lamp.sh"
	echo "By this way, the script will prompt you all the required params"
	echo
	echo "Flags"
	echo
	echo " -u			Unattended flag, suprimes all the conf"
	echo "				irm prompts"
	echo " -U			Same as [-u]"
	echo " --unattended		Same as [-u]"
	echo
	echo " --dbname			Creates a db named as specified and gi"
	echo "				ves all privileges to 'dbusr' user"
	echo
	echo " --dbusr			Creates a db user named as specified w"
	echo "				it password 'dbpass' and gives permiss"
	echo "				ion to 'dbname'"
	echo
	echo " --dbpass			Set the root and user db password (rec"
	echo "				ommended to change after installation)"
	echo
	echo " --dumpable		Specifies the sqldump to load to the "
	echo " 				'dbname' db, IMPORTANT: the dump need"
	echo " 				s to be compressed as a .sql.tar.gz fi"
	echo "				le"
	echo
	echo " --targz			Specifies the compressed file to extra"
	echo " 				ct to /var/www/'servername' route"
	echo
	echo " --servername		Specifies the vhost name and configure"
	echo " 				s all the needed things on apache"
	echo
	echo " --serveradmin		Specifies the vhost admin contact mail"
	echo
	echo " --memory_limit		Set the memory_limit to the specified"
	echo "				value"
	echo
	echo " --max_execution_time	Set the max_execution_time to the spe"
	echo "				cified value"
	echo
	echo " --max_input_time		Set the max_input_time to the specified"
	echo "				value"
	echo
	echo " --post_max_size		Set the post_max_size to the specified "
	echo "				value"
	echo
	echo " --upload_max_filesize	Set the upload_max_filesize to the spec"
	echo "				ified value"
	echo
	echo " --max_input_vars		Set the max_input_vars to the specified"
	echo "				value"
	echo
	echo " --webadmin		Installs the webadmin panel (webmin)"
	echo
	echo " Full flags example:"
	echo " $ sudo bash lamp.sh "
	echo " 		-u 	# For unattended installation"
	echo " 		--dbname beautyfullDbName 	# Creates the"
	echo "			# beautyfullDbName db"
	echo "		--dbusr runnerUser 	# Creates the runnerUser with"
	echo "			# all the privileges on the  dbname database"
	echo "		--dbpass PasswordDB 	# Set the password PasswordDB"
	echo "			# to the root user and runnerUser user"
	echo "		--dumpable beautyfullDbNameDump.sql.tar.gz	# Load"
	echo "			# the beautyfullDbNameDump.sql.tar.gz dump to"
	echo "			# the beautyfullDbName database"
	echo "		--targz httpdocs.tar.gz	# Extract the contents from"
	echo "			# httpdocs.tar.gz to /var/www/beautyVhostName/"
	echo "		--servername beautyVhostName	# Set the vhost name"
	echo "			# to beautyVhostName and configures it"
	echo "		--serveradmin beauty.admin@example.com	# Set the adm"
	echo "			# in email in the apache config"
	echo "		--webadmin		#Installs the webadmin panel"
	echo
	echo "Oneliner:"
	echo " $ sudo bash lamp.sh -u --dbname beautyfullDbName --dbusr runner"
	echo "User --dbpass PasswordDB --dumpable beautyfullDbNameDump.sql.tar"
	echo ".gz --targz httpdocs.tar.gz --servername beautyVhostName --serve"
	echo "radmin beauty.admin@example.com --webadmin"
	echo
	echo " This script:"
	echo " * Run on a fresh new installation"
	echo " * Install the php 7.4 from the  ppa:ondrej/php repository"
	echo " * Install php 8.4"
	echo " * Install the latest Mysql version"
	echo " * Configure a password to the mysql root user"
	echo " * Configure a new non-root mysql user"
	echo " * Create a new database to the project"
	echo " * Extracts and load a mysqldump to the recently created database"
	echo " * Configues a simple new vhost and enables it to apache"
	echo " * Set the needed php.ini flags"
	echo " * Installs a simple webadmin panel (if specified)"
	echo
	echo " Tis script NOT: "
	exit
}

unattended=''
dbpass=''
dbusr=''
dbname=''
dumplable=''
targz=''
server_name=''
server_admin=''
memory_limit='800M'
max_execution_time='500'
max_input_time='800'
post_max_size='800M'
upload_max_filesize='50M'
max_input_vars='60000'
webadmin='N'

while [ $# -gt 0 ]; do
	case $1 in
		-u | -U | --unattended)
			unattended='-y'
		;;
		--dbpass)
			dbpass="$2"
		;;
		--dbusr)
			dbusr="$2"
		;;
		--dbname)
			dbname="$2"
		;;
		--dumpable)
			dumpable="$2"
		;;
		--targz)
			targz="$2"
		;;
		--servername)
			server_name="$2"
		;;
		--serveradmin)
			server_admin="$2"
		;;
		--memory_limit)
			memory_limit="$2"
		;;
		--max_execution_time)
			max_execution_time="$2"
		;;
		--max_input_time)
			max_input_time="$2"
		;;
		--post_max_size)
			post_max_size="$2"
		;;
		--upload_max_filesize)
			upload_max_filesize="$2"
		;;
		--max_input_vars)
			max_input_vars="$2"
		;;
		--webadmin)
			webadmin=''
		;;
		-h | --help)
			display_help
		;;
	esac
	shift
done


server_conf="<VirtualHost *:80>
	ServerName $server_name
	ServerAlias www.$server_name
	ServerAdmin $server_admin
	DocumentRoot /var/www/$server_name
	ErrorLog ${APACHE_LOG_DIR}/$server_name.error.log
	CustomLog ${APACHE_LOG_DIR}/$server_name.access.log combined
	<FilesMatch \.php$>
		SetHandler \"proxy:unix:/run/php/php7.4-fpm.sock|fcgi://localhost/\"
	</FilesMatch>
</VirtualHost>
"

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi


while [[ -z "$dbpass" ]]; do
	echo "Enter your desired password to your DB installation"
	read dbpass
done

while [[ -z "$dbusr" ]]; do
	echo "Enter your desired user to your DB installation"
	read dbusr
done

while [[ -z "$dbname" ]]; do
	echo "Enter your desired database name to your DB installation"
	read dbname
done

while [[ -z "$dumpable" ]]; do
	echo "Enter the location from your dump"
	read dumpable
done

while [[ -z "$targz" ]]; do
	echo "Enter the location from your targz files"
	read targz
done

while [[ -z "$server_name" ]]; do
	echo "Enter the vhost name"
	read server_name
done

while [[ -z "$server_admin" ]]; do
	echo "Enter the vhost admin email"
	read server_admin
done

### Update dependencies
echo "Updating dependencies"
### Update packageslists via apt-get
sudo apt-get update
### update dependencies via apt-get
sudo apt-get upgrade $unattended
### Update packageslists via apt
sudo apt update
### update dependencies via apt
sudo apt upgrade $unattended

### Installing UFW
echo "Installing UFW"
sudo apt install ufw $unattended
echo "UFW Installed"

### Installing Apache
echo "Installing apache2"
sudo apt install apache2 $unattended
echo "Installed apache2"

### Allow apache in UFW
sudo ufw allow 443
sudo ufw allow 80

### Reloading UFW
sudo ufw reload
ip a | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'

### Installing tar
echo "Installing tar build-essential xz-utils"
sudo apt install $unattended tar build-essential xz-utils
echo "Installed tar build-essential xz-utils"

### Installing sed
echo "Installing sed"
sudo apt install $unattended sed
echo "Installed sed"

### Installing mysql and mariadb
## Set unnattended install
## Install MySQL server
echo "Installing mysql-server"
sudo apt install $unattended mariadb-server mariadb-client
echo "Installed mysql-server"
## Change root user password
## Remove the anonymous users
mysql -e "DROP USER ''@'localhost'"
mysql -e "DROP USER ''@'$(hostname)'"
## Remove test database
mysql -e "DROP DATABASE test"
## Flush privileges
mysql -e "FLUSH PRIVILEGES"
echo "Installed mysql version: " $(mysql --version)

### Installing PHP 7.4
## Updating repositories
sudo apt update
## Installing dependencies
echo "Installing software-properties-common"
sudo apt install $unattended software-properties-common
echo "Installed software-properties-common"
## Adding php 7.4 repository
sudo add-apt-repository $unattended ppa:ondrej/php
## Updating repositories
sudo apt update
## Installing php 7.4
echo "Installing PHP7.4"
sudo apt install $unattended php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml php7.4-gd php7.4-zip libapache2-mod-php7.4
echo "Installed PHP7.4"
## Installing php 8.4
echo "Installing PHP8.4"
sudo apt install $unattended php8.4 php8.4-cli php8.4-fpm php8.4-mysql php8.4-curl php8.4-mbstring php8.4-xml php8.4-gd php8.4-zip libapache2-mod-php8.4
echo "Installed PHP8.4"
#Install phpmyadmin
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${dbpass}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${dbpass}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${dbpass}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
echo "Installing PHP MyAdmin"
sudo apt install $unattended phpmyadmin
echo \"Installed PHP version: \" $(php -v | head -n1 )
## Restarting apache service
sudo echo "DirectoryIndex at_domains_index.html index.html index.cgi index.pl index.php index.xhtml index.htm index.shtml index.cfm" > /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2
### Setting up virtual server
## Create site folder
sudo mkdir /var/www/$server_name
## Giving current user r/w permissions
sudo chown -R $USER:$USER /var/www/$server_name
## Write basic vhost config to vhost config file
sudo echo "$server_conf" > /etc/apache2/sites-available/$server_name.conf
## Set global servername on apache
sudo echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf
## Allow Apache to run php 8.4
sudo a2enmod php7.4
sudo a2enmod proxy proxy_fcgi
## Adding site to apache
sudo a2ensite $server_name
## Testing config
sudo apache2ctl configtest
## Reloading apache service
sudo systemctl reload apache2
echo "<?php phpinfo(); ?>" > /var/www/$server_name/index.php
sudo sed -i "s/^memory_limit =.*/memory_limit = ${memory_limit}/" "/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/^max_execution_time =.*/max_execution_time = ${max_execution_time}/" "/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/^max_input_time =.*/max_input_time = ${max_input_time}/" "/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/^post_max_size =.*/post_max_size = ${post_max_size}/" "/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/^upload_max_filesize =.*/upload_max_filesize = ${upload_max_filesize}/" "/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/^;max_input_vars =.*/max_input_vars = ${max_input_vars}/" "/etc/php/7.4/apache2/php.ini"
sudo systemctl restart php7.4-fpm php8.4-fpm apache2
sudo a2dismod php7.4
sudo a2enmod php8.4
sudo systemctl restart php7.4-fpm php8.4-fpm apache2

### Add DB User
mysql -e "CREATE USER '$dbusr'@'localhost' IDENTIFIED BY '$dbpass';"
mysql -e "CREATE DATABASE $dbname;"
mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbusr'@'localhost';"
mysql -e "FLUSH PRIVILEGES"
sudo tar -xOzf $dumpable > /var/www/$server_name/dump.sql
mysql -v -u $dbusr -p$dbpass $dbname -e "SOURCE /var/www/$server_name/dump.sql"
sudo tar -xvzf $targz -C /var/www/$server_name

if [[ -z "$webadmin" ]]; then
	curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
	sudo sh webmin-setup-repo.sh
	sudo apt-get install webmin usermin --install-recommends $unattended
fi


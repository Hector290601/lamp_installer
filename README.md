# Procesa.App

## Requirements

### PHP

* Version: PHP 7.4.33
* Served as : FastCGI Application serveded by Apache

#### Extra PHP Configs (php.ini file)

* memory_limit: 800M
* max_execution_time: 500
* max_input_time: 800
* post_max_size : 800M
* upload_max_filesize: 50M
* max_input_vars: 60000

### O.S

Any Linux Distro which supports PHP 7.4, Apache 2.4 and MySQL 15.1

Recommended architecture: x86_64

### SQL

* Engine: MySQL
* Version: 15.1
* Recommended RDBMS: 10.11.13-MariaDB

### Contact

* [ayuda.ti@procesa.mx](mailto:ayuda.ti@procesa.mx)
* [rafael.thomas@procesa.mx](mailto:rafael.thomas@procesa.mx)
* [hector.robles@procesa.mx](mailto:hector.robles@procesa.mx)
* [hector@roblesm.mx](mailto:hector@roblesm.mx)

## Installation

### Ubuntu 24.04

Download the lamp.sh installation script, or clone the repo: [https://github.com/Hector290601/lamp_installer](https://github.com/Hector290601/lamp_installer) the database and the compressed httpdocs folder

This script configures a lamp stack on a new fresh installed ubuntu 24.04. To run this script, you need

1 The db dump compressed as .sql.tar.gz

2 The httpdocs compressed as .tar.gz

Also, this script will read as named args, or prompt you to:
1. Database Name
2. Database User
3. Database Password
4. VHost name
5. VHost admin email

Also, you can specify the next php flags:
1. memory_limit
2. max_execution_time
3. max_input_time
4. post_max_size
5. upload_max_filesize
6. max_input_vars

This script installs the next lampstack:
* Php 7.4
* Mysql Latest
* Apache2 Latest

To run this script, you need to make it executable by:

    $ sudo chmod +x lamp.sh

And next, run it by:

    $ sudo bash lamp.sh

It's highly reccommended to run:

    $ sudobash lamp.sh -h

To display script help.

This script has the following flags:

* -u                    Unattended flag, suprimes all the confirm prompts
* -U                    Same as [-u]
* --unattended          Same as [-u]
* --dbname              Creates a db named as specified and gives all privileges to 'dbusr' user
* --dbusr               Creates a db user named as specified wit password 'dbpass' and gives permission to 'dbname'
* --dbpass              Set the root and user db password (recommended to change after installation)
* --dumpable            Specifies the sqldump to load to the 'dbname' db, IMPORTANT: the dump needs to be compressed as a .sql.tar.gz file
* --targz               Specifies the compressed file to extract to /var/www/'servername' route
* --servername          Specifies the vhost name and configures all the needed things on apache
* --serveradmin         Specifies the vhost admin contact mail
* --memory_limit        Set the memory_limit to the specifiedvalue
* --max_execution_time  Set the max_execution_time to the specified value
* --max_input_time      Set the max_input_time to the specifiedvalue
* --post_max_size       Set the post_max_size to the specified value
* --upload_max_filesize Set the upload_max_filesize to the specified value
* --max_input_vars      Set the max_input_vars to the specifiedvalue

Full flags example:

    $ sudo bash lamp.sh -u                          # For unattended installation
        --dbname beautyfullDbName                   # Creates the beautyfullDbName db
        --dbusr runnerUser                          # Creates the runnerUser with all the privileges on the  dbname database
        --dbpass PasswordDB                         # Set the password PasswordDB to the root user and runnerUser user
        --dumpable beautyfullDbNameDump.sql.tar.gz  # Load the beautyfullDbNameDump.sql.tar.gz dump to the beautyfullDbName database
        --targz httpdocs.tar.gz                     # Extract the contents from httpdocs.tar.gz to /var/www/beautyVhostName/
        --servername beautyVhostName                # Set the vhost name to beautyVhostName and configures it
        --serveradmin beauty.admin@example.com      # Set the admin email in the apache config


Oneliner:
```
sudo bash lamp.sh -u --dbname beautyfullDbName --dbusr runnerUser --dbpass PasswordDB --dumpable beautyfullDbNameDump.sql.tar.gz --targz httpdocs.tar.gz --servername beautyVhostName --serveradmin beauty.admin@example.com
```
### Manual installation

To achieve the procesa.app running on a fresh new server, you need to:
1. Install php7.4
2. Install Mysql 15.1
3. Install Apache 2
4. Configure a new VHost
5. Load the db dump
6. Copy the php scripts

#!/bin/bash

# <description>
# This script will build and deploy postgres DB automatically.
# This script works on Ubuntu operation system.

pass=$2
function  usage() {
	#<description>
	# This function print the help menu for the user.
    echo "call this script with 2 arguments of the postgre user and password:
                
	Example: ./db.sh 'user' 'password'" ; 
    exit 1; 
}

function  validation(){
	#<description>
	# This function valdate all the arguments from the user.

    if [ -z "${pass}" ]; then
        usage
    fi
}

function installtion(){
	#<description>
	# This function install using apt all the  requirements for the db.

    sudo apt-get update
    #sudo apt-get install git
    #git clone https://github.com/lahad230/weightTracker.git
    sudo apt-get -y install postgresql    
}

function editConfig(){
    #<description>
    #this function makes changes to pg_hba.conf and postgresql.conf
    #to make the db listen to the outside.
    echo "host    all             all             0.0.0.0/0                    md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
    echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/*/main/postgresql.conf
}

function initDb(){
    #<description>
    #this function creates the table in the db and adds password to the postgres user.
    sudo -u postgres psql -d postgres -c "CREATE TABLE IF NOT EXISTS measurements (id INT NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY, user_id varchar(50) NOT NULL, measure_date date NOT NULL, weight numeric(5,1) NOT NULL)"
    sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${pass}';"
}

function enableService(){
    #<description>
    #this function enables the postgres service.
    sudo systemctl enable postgresql
}


validation
installtion
editConfig
initDb
enableService

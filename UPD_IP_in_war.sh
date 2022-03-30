#!/bin/sh

sudo su -
cd /usr/share/tomcat/webapps

vm_host=
postgres_db_host=
old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$postgres_db_host"

sed -i "s/$old_serverip/$vm_host/g" ./citizen/WEB-INF/classes/com/softserveinc/geocitizen/configuration/MongoConfig.class
sed -i "s/$old_serverip/$vm_host/g" ./citizen/static/js/*
sed -i "s/$old_serverip/$vm_host/g" ./citizen/WEB-INF/classes/application.properties  
sed -i "s/$old_dbip/$new_dbip/g" ./citizen/WEB-INF/classes/application.properties

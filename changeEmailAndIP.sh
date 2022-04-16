#!/bin/sh

#----------------------------------------------------------------------------------------------------
# Update email credentials

. ./emailCredentials

old_mail="[a-z0-9.]\{5,\}@gmail\.com"
old_passwd="email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}"
new_passwd="email.password=$password"

sed -i "s/$old_mail/$email/g" ./src/main/resources/application.properties
sed -i "s/$old_passwd/$new_passwd/g" ./src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Update ip addresses

. ./Terraform/credentials

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432\/ss_demo_1"
new_dbip="postgresql:\/\/$db_host\/ss_demo_1"
 
sed -i "s/$old_serverip/$lb_dns/g" ./src/main/webapp/static/js/*
sed -i "s/$old_serverip/$lb_dns/g" ./src/main/resources/application.properties

sed -i "s/$old_dbip/$new_dbip/g" ./src/main/resources/application.properties

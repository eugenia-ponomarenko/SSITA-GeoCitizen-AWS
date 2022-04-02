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

. ./Terraform/details/credentials

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432\/ss_demo_1"

sed -i "s/$old_serverip/$ubuntu_host/g" ./src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/$old_serverip/$ubuntu_host/g" ./src/main/webapp/static/js/*
sed -i "s/$old_serverip/$ubuntu_host/g" ./src/main/resources/application.properties
sed -i "s/$old_dbip/postgresql:\/\/$db_host\/ss_demo_1/g" ./src/main/resources/application.properties
sed -i "s/5432\n\/ss_dem_1/5432\/ss_demo_1/g" ./src/main/resources/application.properties
sed -i "s/5432\n\/ss_dem_1_test/5432\/ss_demo_1_test/g" ./src/main/resources/application.properties

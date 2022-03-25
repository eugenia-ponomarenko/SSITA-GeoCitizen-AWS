#!/bin/sh

# sudo rm -rf ~/Geocit134
# cd ~/
# git clone https://github.com/mentorchita/Geocit134.git
cd ~/Geocit134

#----------------------------------------------------------------------------------------------------
# Remove old project files from tomcat

sudo rm -rf /usr/share/tomcat/webapps/citizen.war
sudo rm -rf /usr/share/tomcat/webapps/citizen

# #----------------------------------------------------------------------------------------------------
# # Fix pom.xml

# sed -i "s/http:\/\/repo.spring.io/https:\/\/repo.spring.io/g" ~/Geocit134/pom.xml
# sed -i "s/>servlet-api</>javax.servlet-api</g" ~/Geocit134/pom.xml
# sed -i "s/<distributionManagement>/<\!--\n<distributionManagement>/g" ~/Geocit134/pom.xml
# sed -i "s/<\/distributionManagement>/<\/distributionManagement>\n-->/g" ~/Geocit134/pom.xml

# #----------------------------------------------------------------------------------------------------
# Update email credentials

# . ~/emailCredentials

# old_mail="[a-z0-9.]\{5,\}@gmail\.com"
# old_passwd="email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}"
# new_passwd="email.password=$password"

# sed -i "s/$old_mail/$email/g" ~/Geocit134/src/main/resources/application.properties
# sed -i "s/$old_passwd/$new_passwd/g" ~/Geocit134/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Update ip addresses

. ~/credentials

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$db_host"

sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/webapp/static/js/*
sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/resources/application.properties
# sed -i "s/$old_dbip/$new_dbip/g" ~/Geocit134/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Correct path to js directory

# sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

#-----------------------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 5
sudo mv target/citizen.war /usr/share/tomcat/webapps/ 
sleep 5
sudo sh /usr/share/tomcat/bin/startup.sh
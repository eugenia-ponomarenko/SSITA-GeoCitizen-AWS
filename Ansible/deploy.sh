#!/bin/bash
# -------------------------------------------------------------------------------------
# variables

tomcat_path="/opt/tomcat/latest"

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
vm_host=$(curl --silent --url "www.ifconfig.me" | tr "\n" " ")

db_host="lb-geocitizen.cstswihxzihx.eu-central-1.rds.amazonaws.com"

old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$db_host:5432"

# -------------------------------------------------------------------------------------
# Start RDS instance
aws configure set default.region eu-central-1
aws rds start-db-instance --db-instance-identifier lb-geocitizen

# -------------------------------------------------------------------------------------
# Download citizen.war from S3 
aws s3 cp s3://geo-citizen-war/geo-citizen-1.0.5-20220404.173539-1.war  ~/citizen.war

sudo cp ~/citizen.war  $tomcat_path/webapps/

# ----------------------------------------------------------------------------------------
# Fix IPs for webapp
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/WEB-INF/classes/com/softserveinc/geocitizen/configuration/MongoConfig.class
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/app.6313e3379203ca68a255.js.map
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/app.6313e3379203ca68a255.js
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/WEB-INF/classes/application.properties

# Fix IPs for db
sudo sed -i "s/$old_dbip/$new_dbip/g"    $tomcat_path/webapps/citizen/WEB-INF/classes/application.properties

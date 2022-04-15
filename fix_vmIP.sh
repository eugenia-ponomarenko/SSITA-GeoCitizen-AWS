#!/bin/bash

tomcat_path="/usr/share/tomcat"

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
vm_host=$(curl --silent --url "www.ifconfig.me" | tr "\n" " ")

# Fix IPs for webapp
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/WEB-INF/classes/com/softserveinc/geocitizen/configuration/MongoConfig.class
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/app.6313e3379203ca68a255.js.map
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/static/js/app.6313e3379203ca68a255.js
sudo sed -i "s/$old_serverip/$vm_host/g" $tomcat_path/webapps/citizen/WEB-INF/classes/application.properties

resource "local_file" "ansible_inventory" {
  filename = format("%s/%s/%s", abspath(path.root), "deploy1.sh")
  file_permission   = "0755"
  content = <<EOF
#!/bin/bash
sudo apt-get update  -y
sudo apt install default-jdk  -y
sudo apt install awscli -y

# -------------------------------------------------------------------------------------
# variables

tomcat_path="/opt/tomcat/latest"

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
vm_host=$(curl --silent --url "www.ifconfig.me" | tr "\n" " ")

db_id="${aws_db_instance.PostgresDB.id}"
db_host="${aws_db_instance.PostgresDB.endpoint}"

old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$db_host"

# -------------------------------------------------------------------------------------
# Start RDS instance
aws configure set default.region eu-central-1
aws rds start-db-instance --db-instance-identifier $db_id

# -------------------------------------------------------------------------------------
# Install tomcat9
sudo mkdir /opt/tomcat
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
sudo wget http://www.apache.org/dist/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz -P /tmp
sudo tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.62 /opt/tomcat/latest
sudo chown -RH tomcat: /opt/tomcat/latest
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

sudo tee /etc/systemd/system/tomcat.service << EOL
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOL



sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo ufw allow 8080/tcp

sudo tee /opt/tomcat/latest/conf/tomcat-users.xml << EOL
<tomcat-users>
<!--
   Comments
-->
   <role rolename="admin-gui"/>
   <role rolename="manager-gui"/>
   <user username="janedo" password="passwd" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOL


sudo sed -i "s/<Valve className=/<\!--\n<Valve className=/g"  $tomcat_path/webapps/manager/META-INF/context.xml
sudo sed -i "s/<\/Context>/\n-->\n<\/Context>/g"              $tomcat_path/webapps/manager/META-INF/context.xml
sudo sed -i "s/<Valve className=/<\!--\n<Valve className=/g"  $tomcat_path/webapps/host-manager/META-INF/context.xml
sudo sed -i "s/<\/Context>/\n-->\n<\/Context>/g"              $tomcat_path/webapps/host-manager/META-INF/context.xml

sudo systemctl restart tomcat

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

# ----------------------------------------------------------------------------------------
sudo sh $tomcat_path/bin/startup.sh
EOF
}

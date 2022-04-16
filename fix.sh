 #!/bin/bash
#################################################
### Set the environment variables
#################################################

#----------------------------------------------------------------------------------------------------
# Update email credentials

. ./emailCredentials

old_mail="[a-z0-9.]\{5,\}@gmail\.com"
old_passwd="email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}"
new_passwd="email.password=$password"

sed -i "s/$old_mail/$email/g" ./src/main/resources/application.properties
sed -i "s/$old_passwd/$new_passwd/g" ./src/main/resources/application.properties

. ./Terraform/credentials

##################Adjusting_application.properties###############################
sed -i -E \
            "s/(http:\/\/localhost:8080)/http:\/\/$lb_dns:80/g; \
            s/(postgresql:\/\/localhost)/postgresql:\/\/$db_host/g;
            s/(35.204.28.238)/$db_host/g; " src/main/resources/application.properties

##################Repair index.html favicon###############################
sed -i "s/\/src\/assets/\.\/static/g" src/main/webapp/index.html
##################Repair js bundles###############################
find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost:8080/$lb_dns:80/g" {} +
find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost/$lb_dns/g" {} +

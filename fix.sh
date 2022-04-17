 #!/bin/bash
#################################################
# Set the environment variables

. ./Terraform/hosts

#----------------------------------------------------------------------------------------------------
# Fix application.properties
sed -i -E \
            "s/(http:\/\/localhost:8080)/http:\/\/$lb_dns:80/g; \
            s/(postgresql:\/\/localhost:5432)/postgresql:\/\/$db_host/g;
            s/(35.204.28.238:5432)/$db_host/g; " src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Repair index.html favicon
sed -i "s/\/src\/assets/\.\/static/g" src/main/webapp/index.html

#----------------------------------------------------------------------------------------------------
# Repair js bundles
find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost:8080/$lb_dns:80/g" {} +
find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost/$lb_dns/g" {} +

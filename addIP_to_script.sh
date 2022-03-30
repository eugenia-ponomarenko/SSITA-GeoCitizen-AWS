#!/bin/sh

. ./Terraform/details/credentials

sed -i "s/postgres_db_host=/postgres_db_host=\'$db_host\'/g" ./UPD_IP_in_war.sh
sed -i "s/vm_host=/vm_host=\'$ubuntu_host\'/g" ./UPD_IP_in_war.sh

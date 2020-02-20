#!/bin/bash

#Add stoplight user (pg_upgrade can't be run as root)
useradd --uid 1000 stoplight

#Make stoplight own postgres directories 
chown -R stoplight:stoplight /var/lib/postgresql && chown -R stoplight:stoplight /etc/postgresql && chown -R stoplight:stoplight /var/run/postgresql

#Switch to stoplight user
gosu stoplight bash
cd /usr/lib/postgresql

#Initialize postgres 12 with stoplight user, and edit pg_hba.conf
/usr/lib/postgresql/12/bin/initdb --pgdata=/var/lib/postgresql/data/pgdata-new --username=stoplight --encoding=unicode --auth=trust
echo "host all all 0.0.0.0/0 md5" >> pg_hba.conf

#Perform upgrade
/usr/lib/postgresql/12/bin/pg_upgrade \
-b /usr/lib/postgresql/10/bin \
-B /usr/lib/postgresql/12/bin \
-d /var/lib/postgresql/data/pgdata \
-D /var/lib/postgresql/data/pgdata-new \
--old-options '-c config_file=/var/lib/postgresql/data/pgdata/postgresql.conf' \
--new-options '-c config_file=/var/lib/postgresql/data/pgdata-new/postgresql.conf'

#Replace pgdata with pgdata-new
rm -rf /var/lib/postgresql/data/pgdata
mv /var/lib/postgresql/data/pgdata-new /var/lib/postgresql/data/pgdata
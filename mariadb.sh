apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen

# Config
export MARIADB_PASS=$(pwgen -s 12 1);
export MARIADB_VAGRANT_PASS=vagrant

debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password $MARIADB_PASS"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password $MARIADB_PASS"

# Install MariaDB
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --allow-unauthenticated mariadb-server mariadb-client

if [ -f /home/vagrant/.mysql-passes ]
then
  rm -f /home/vagrant/.mysql-passes
fi

echo "root:${MARIADB_PASS}" >> /home/vagrant/.mysql-passes
echo "vagrant:${MARIADB_VAGRANT_PASS}" >> /home/vagrant/.mysql-passes

mysql -uroot -p$MARIADB_PASS -e \
  "CREATE USER 'vagrant'@'localhost' IDENTIFIED BY '$MARIADB_VAGRANT_PASS'"

echo "MariaDB root password is in /home/vagrant/.mysql-passes"
mysql -uroot -p$MARIADB_PASS -e \
  "CREATE DATABASE vagrant DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mysql -uroot -p$MARIADB_PASS -e \
  "GRANT ALL ON vagrant TO 'vagrant'@'localhost';" mysql

 # Configure MariaDB to listen on any address.
sed -i -e 's/^bind-address/#bind-address/' /etc/mysql/my.cnf

# Change the innodb-buffer-pool-size to 128M (default is 256M).
# This should make it friendlier to run on low memory servers.
sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf

echo "Created vagrant database"

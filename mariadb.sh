set -e

apt-get update

# Config
export MARIADB_PASS=vagrantroot
export MARIADB_VAGRANT_PASS=vagrant

debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password $MARIADB_PASS"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password $MARIADB_PASS"

# Install MariaDB
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
  mariadb-server mariadb-client

if [ -f /home/vagrant/.mysql-passes ]
then
  rm -f /home/vagrant/.mysql-passes
fi

echo "root:${MARIADB_PASS}" >> /home/vagrant/.mysql-passes
echo "vagrant:${MARIADB_VAGRANT_PASS}" >> /home/vagrant/.mysql-passes

mysql -uroot -p$MARIADB_PASS <<-EOF
  # In MYSQL/MariaDB grant will create user if it does not exists
  # this approach should avoid issues if provider is rerun
  GRANT ALL ON *.* TO 'vagrant'@'localhost' IDENTIFIED BY '$MARIADB_VAGRANT_PASS';
  GRANT ALL ON *.* TO 'vagrant'@'%';
EOF

echo "MariaDB root password is in /home/vagrant/.mysql-passes"

 # Configure MariaDB to listen on any address.
sed -i -e 's/^bind-address/#bind-address/' /etc/mysql/my.cnf

# Change the innodb-buffer-pool-size to 128M (default is 256M).
# This should make it friendlier to run on low memory servers.
sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf

echo "MariaDB configured"

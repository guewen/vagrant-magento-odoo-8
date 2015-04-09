set -e

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  php5-mysql php5-gd php5-mcrypt php5-xmlrpc \
  php5-curl php-soap php5-cli php5-fpm

sudo php5enmod mcrypt

DEBIAN_FRONTEND=noninteractive apt-get install -y bzr git tar nginx

cd /tmp
wget http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz
tar -zxvf magento-1.9.1.0.tar.gz
mv /tmp/magento /var/www
cd /var/www
chmod -R o+w media var
chmod o+w app/etc

cd /tmp
wget http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-sample-data-1.9.1.0.tar.gz
tar -zxvf magento-sample-data-1.9.1.0.tar.gz

bzr checkout --lightweight http://bazaar.launchpad.net/~magentoerpconnect-core-editors/magentoerpconnect/module-magento-trunk/

rm -f /tmp/magento-*tar.gz

rm /etc/nginx/sites-enabled/default

cd

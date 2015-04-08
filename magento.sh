DEBIAN_FRONTEND=noninteractive apt-get install -y \
  php5 php5-mysqlnd php5-curl php5-xdebug php5-gd \
  php5-intl php-pear php5-imap php5-mcrypt php5-ming \
  php5-ps php5-pspell php5-recode php5-snmp php5-sqlite \
  php5-tidy php5-xmlrpc php5-xsl php-soap

php5enmod mcrypt

DEBIAN_FRONTEND=noninteractive apt-get install -y bzr git tar mysql

cd /tmp
wget http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz
tar -zxvf magento-1.9.1.0.tar.gz
mv /tmp/magento /var/www
cd /var/www
chmod -R o+w media var
chmod o+w app/etc

cd /tmp
wget http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-sample-data-1.9.1.0.tar.gz
tar -zxvf magento-sample-data-1.6.1.0.tar.gz

bzr checkout --lightweight http://bazaar.launchpad.net/~magentoerpconnect-core-editors/magentoerpconnect/module-magento-trunk/

echo "daemon off;" >> /etc/nginx/nginx.conf
rm -f /tmp/magento-*tar.gz

#! /bin/bash

set -e

sed -i "s@^memory_limit =.*@memory_limit = 256M@" /etc/php5/fpm/php.ini

echo "setting the default installer info for magento"
sed -i "s/<host>localhost/<host>db/g" /var/www/app/etc/config.xml
sed -i "s/<username\/>/<username>user<\/username>/" /var/www/app/etc/config.xml
sed -i "s/<password\/>/<password>password<\/password>/g" /var/www/app/etc/config.xml

echo "Creating the magento database..."

echo "create database magento" | mysql -u "vagrant" --password="vagrant" -h localhost -P "3306"

while [ $? -ne 0 ]; do
	sleep 5
        echo "create database magento" | mysql -u "vagrant" --password="vagrant" -h localhost -P "3306"
        echo "show tables" | mysql -u "vagrant" --password="vagrant" -h localhost -P "3306" magento
done

echo "Loading sample data"
mysql -u "vagrant" --password="vagrant" -h localhost -P "3306" magento < /tmp/magento-sample-data-*/magento_sample_data*.sql

echo "Moving sample media"
cp -r /tmp/magento-sample-data-*/media/* /var/www/media
cp -r /tmp/magento-sample-data-*/skin/* /var/www/skin

echo "Moving Magento Connector module"
mv /tmp/module-magento-trunk/Openlabs_OpenERPConnector-1.1.0/app/etc/modules/Openlabs_OpenERPConnector.xml /var/www/app/etc/modules/
mv /tmp/module-magento-trunk/Openlabs_OpenERPConnector-1.1.0/Openlabs /var/www/app/code/community/
rm -rf /tmp/module-magento-trunk

echo "Adding Magento Caching"

sed -i -e  '/<\/config>/{ r /var/www/app/etc/mage-cache.xml' -e 'd}' /var/www/app/etc/local.xml.template

echo "Installing"
php -f /var/www/install.php -- \
--license_agreement_accepted yes \
--locale "fr_FR" \
--timezone "Europe/Berlin" \
--default_currency "EUR" \
--db_host "localhost" \
--db_name "magento" \
--db_user "vagrant" \
--db_pass "vagrant" \
--url "http://127.0.0.1:8080" \
--skip_url_validation \
--use_rewrites no \
--use_secure no \
--secure_base_url "" \
--use_secure_admin no \
--admin_firstname "Admin" \
--admin_lastname "Admin" \
--admin_email "admin@admin.com" \
--admin_username "admin" \
--admin_password "admin25"

service php5-fpm restart
nginx -s reload

chmod -R o+w media/catalog

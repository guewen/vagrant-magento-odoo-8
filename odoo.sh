#! /bin/bash

set -e

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    nodejs \
    npm \
    python-support \
    python-pyinotify \
    postgresql

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  python-geoip python-gevent \
  python-ldap python-lxml python-markupsafe python-pil python-pip \
  python-psutil python-psycopg2 python-pychart python-pydot \
  python-reportlab python-simplejson python-yaml

sudo -u postgres createuser vagrant -s -w
sudo -u postgres psql --command \
  "ALTER USER vagrant WITH PASSWORD 'vagrant';"

npm install -g less less-plugin-clean-css
ln -s /usr/bin/nodejs /usr/bin/node
cd /tmp
curl -o wkhtmltox.deb -SL \
  http://downloads.sourceforge.net/project/wkhtmltopdf/archive/0.12.1/wkhtmltox-0.12.1_linux-trusty-i386.deb
echo '6fae64218fef080514eb030c0521d50035966908 wkhtmltox.deb' | sha1sum -c -
dpkg --force-depends -i wkhtmltox.deb
apt-get -y install -f --no-install-recommends
rm -f wkhtmltox.deb

pip install virtualenv

# buildout might need it
git config --global user.email "odoo@example.com"
git config --global user.name "Odoo Vagrant Demo"

cd /home/vagrant
git clone git://github.com/guewen/odoo-connector-magento-buildout.git -b 8.0-new-job-runner odoo
cd odoo
./bootstrap.sh
bin/buildout
createdb odoo_magento8
bin/start_openerp -d odoo_magento8 -i magentoerpconnect --stop-after-init
bin/supervisord

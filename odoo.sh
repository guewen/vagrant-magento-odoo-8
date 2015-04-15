#! /bin/bash

set -e

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    nodejs \
    npm \
    python-support \
    python-pyinotify \
    postgresql \
    postgresql-server-dev-9.3 \
    libjpeg8-dev \
    libfreetype6-dev \
    libsasl2-dev \
    libxslt-dev \
    libxml2-dev \
    libldap2-dev \

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  python-geoip python-gevent \
  python-ldap python-lxml python-markupsafe python-pil python-pip \
  python-psutil python-psycopg2 python-pychart python-pydot \
  python-reportlab python-simplejson python-yaml python-dev

user_exists=`sudo -u postgres psql postgres -Upostgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='vagrant'"`
echo "$user_exists"
if [ -z "$user_exists" ]; 
  then 
    sudo -u postgres createuser vagrant -s -w
fi 
sudo -u postgres psql --command \
  "ALTER USER vagrant WITH PASSWORD 'vagrant';"

npm install -g less less-plugin-clean-css
if [ ! -h /usr/bin/node ];
  then
      ln -s /usr/bin/nodejs /usr/bin/node
fi
cd /tmp
curl -o wkhtmltox.deb -SL \
  http://downloads.sourceforge.net/project/wkhtmltopdf/archive/0.12.1/wkhtmltox-0.12.1_linux-trusty-i386.deb
echo '6fae64218fef080514eb030c0521d50035966908 wkhtmltox.deb' | sha1sum -c -
dpkg --force-depends -i wkhtmltox.deb
apt-get -y install -f --no-install-recommends
rm -f wkhtmltox.deb

pip install virtualenv

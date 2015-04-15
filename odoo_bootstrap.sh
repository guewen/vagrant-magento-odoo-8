# buildout might need it
git config --global user.email "odoo@example.com"
git config --global user.name "Odoo Vagrant Demo"

cd /home/vagrant
if [ -d odoo ];
  then
    cd odoo
    git pull
  else 
    git clone https://github.com/guewen/vagrant-magento-odoo-8.git -b 8.0-new-job-runner odoo
    cd odoo
fi
./bootstrap.sh
bin/buildout
createdb -O vagrant odoo_magento8
bin/start_openerp -d odoo_magento8 -i magentoerpconnect --stop-after-init
bin/supervisord

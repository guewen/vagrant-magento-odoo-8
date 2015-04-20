cp /vagrant/templates/init.d/odoo-supervisord /etc/init.d/odoo-supervisord
sudo update-rc.d odoo-supervisord defaults
sudo update-rc.d odoo-supervisord enable

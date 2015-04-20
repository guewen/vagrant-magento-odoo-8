# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty32"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.boot_timeout = 600

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "mariadb", type: "shell", path: "mariadb.sh"
  config.vm.provision "memcached", type: "shell", path: "memcached.sh"
  config.vm.provision "magento", type: "shell", path: "magento.sh"
  # latest version of Vagrant require user to have write permission on desitnation folder
  # the sudo context is know set to false. Making the inline shell command is proposed by Michael
  config.vm.provision "nginx_config", type: "file", source: "templates/nginx.conf", destination: "/tmp/default.conf"
  config.vm.provision "nginx_config_mv", type: "shell", inline: "cp /tmp/default.conf /etc/nginx/conf.d/default.conf"
  config.vm.provision "mage_cache_config", type: "file", source: "templates/magento/mage-cache.xml", destination: "/tmp/mage-cache.xml"
  config.vm.provision "mage_cache_config_mv", type: "shell", inline: "cp /tmp/mage-cache.xml /var/www/app/etc/mage-cache.xml"
  config.vm.provision "seturl_config", type: "file", source: "templates/magento/seturl.php", destination: "/tmp/seturl.php"
  config.vm.provision "seturl_config_mv", type: "shell", inline: "cp /tmp/seturl.php /var/www/seturl.php"
  config.vm.provision "magento_service", type: "shell", path: "magento_start.sh"
  config.vm.provision "odoo", type: "shell", path: "odoo.sh"
  config.vm.provision "odoo_bootstrap", type: "shell", path: "odoo_bootstrap.sh", privileged: false
  config.vm.provision "clean", type: "shell", path: "last.sh"
end

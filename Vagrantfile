Vagrant::Config.run do |config|
  config.vm.box       = 'precise64'
  config.vm.box_url   = 'http://files.vagrantup.com/precise64.box'
  config.vm.host_name = 'vagrant-box'

  config.vm.forward_port 3000, 3000
  config.vm.forward_port 35729, 35729

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :manifest_file => 'default.pp',
    :module_path    => 'puppet/modules'

  config.vm.provision "shell",
      inline: " sudo apt-get -y update
                sudo apt-get -y install python-software-properties python g++ curl libssl-dev apache2-utils make;
                sudo add-apt-repository ppa:chris-lea/node.js;
                sudo apt-get -y update;
                sudo apt-get -y install nodejs
                npm install -g yo;
                npm install -g generator-webapp;
                gem update --no-rdoc --no-ri --system;
                gem install --no-rdoc --no-ri compass"
end

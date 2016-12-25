Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.gui = false
  end
  config.vm.box = "gui.c5f12841869664bd899ee8dd2416268822600850"
  config.vm.hostname = "myprecise.box"
  config.vm.network "forwarded_port", guest: 22, host: 20022
  config.vm.provision "shell", path: "provisioner.sh"
end

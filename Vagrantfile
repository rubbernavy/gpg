Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.gui = false
  end
  config.vm.box = "gui.ENV['GUI_COMMIT_ID']"
  config.vm.hostname = "myprecise.box"
  config.vm.network "forwarded_port", guest: 22, host: 20022
  config.vm.provision "shell", path: "provisioner.sh"
end

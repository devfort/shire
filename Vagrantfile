Vagrant::Config.run do |config|
  config.vm.box = "devfort_20130306"
  config.vm.box_url = "http://vagrant.fort/boxes/devfort.box"
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  config.vm.host_name = "devfort"
  config.vm.share_folder "hobbit", "/home/vagrant/hobbit", ".", :nfs => true

  # You may want to up the memory / CPUs to get better performance in the VM.
  # Example given below to put in Vagrantfile.local if you want to do so.
  #
  # config.vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
  #
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end
end

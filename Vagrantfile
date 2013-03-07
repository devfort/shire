def random_ip
  "10.#{rand(254) + 1}.#{rand(254) + 1}.#{rand(254) + 1}"
end

if not File.exist? "Vagrantfile.local"
  $stderr.puts "Detected new install -- creating Vagrantfile.local"

  File.open("Vagrantfile.local", "w") do |fp|
    fp.write("config.vm.network :hostonly, '#{random_ip}'\n")
  end
end

Vagrant::Config.run do |config|
  config.vm.box = "devfort_20130306"
  config.vm.box_url = "http://vagrant.fort/boxes/devfort.box"
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  config.vm.host_name = "devfort"
  config.vm.share_folder "v-root", "/home/vagrant/shire", ".", :nfs => true
  if File.exist? "../hobbit"
    config.vm.share_folder "hobbit", "/home/vagrant/hobbit", "../hobbit", :nfs => true
  end
  config.vm.forward_port 8000, 8000, :auto => true
  config.vm.forward_port 143,  8143, :auto => true

  # You may want to up the memory / CPUs to get better performance in the VM.
  # Example given below to put in Vagrantfile.local if you want to do so.
  #
  # config.vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
  #
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks", "chef/opscode-cookbooks"]
    # TODO: Check to see if we're on a fort!
    chef.add_recipe "fort"
    chef.add_recipe "hobbit"

    chef.json = { :runas => 'vagrant' }
  end
end

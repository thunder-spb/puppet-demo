# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$PUPPET_INSTALL = <<SHELL
  sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
  sudo yum clean all && yum makecache fast
  sudo yum install -y puppet
SHELL

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ##config.vm.box = "bento/centos-6.7"
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/vagrant", disabled: false, :mount_options => ["dmode=777","fmode=666"], type: 'nfs'

  # Check for vbguest plugin
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.no_remote = false
  end
  
  ## Settings
  JENKINS_SERVER_IP="10.0.0.30"
  BUILDHOST_IP="10.0.0.31"

  ## Jenkins server definition
  config.vm.define "jenkins_server", autostart: false do |jenkins_server|
    jenkins_server.vm.hostname = "jenkins-server.local"
    jenkins_server.vm.network "private_network", ip: "#{JENKINS_SERVER_IP}"
    ## server will be available as localhost:8080 and 10.0.0.31:8080
    jenkins_server.vm.network "forwarded_port", guest: 8080, host: 8080
    # Prevent files to be executable
    
    jenkins_server.vm.provision :shell, inline: $PUPPET_INSTALL
    jenkins_server.vm.provision :puppet do |puppet|
      ### Uncomment if you want debugging turned on
      # puppet.options = "--verbose --debug"
      ###
      puppet.hiera_config_path = 'puppet/hiera.yaml'
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "jenkins_server.pp"
      puppet.module_path = "puppet/modules"
      puppet.facter = {
        "environment"        => "vagrant",
        "category"           => "jenkins",
      }
    end
    jenkins_server.vm.provider :virtualbox do |vbjenkins|
      vbjenkins.customize ["modifyvm", :id, "--memory", "2048"]
      vbjenkins.customize ["modifyvm", :id, "--cpus", "2"]
      # The following line is needed for 2 CPUs to be recognized internally
      vbjenkins.customize ["modifyvm", :id, "--ioapic", "on"]
      vbjenkins.name = "aio-jenkins-server"
    end
  end

  ## Build host definition
  config.vm.define "builder", autostart: false do |builder|
    builder.vm.hostname = "builder.local"
    builder.vm.network "private_network", ip: "#{BUILDHOST_IP}"
    builder.vm.provision :shell, inline: $PUPPET_INSTALL
    builder.vm.provision "puppet" do |puppet|
      ### Uncomment if you want debugging turned on
      # puppet.options = "--verbose --debug"
      ###
      puppet.hiera_config_path = 'puppet/hiera.yaml'
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "builder.pp"
      puppet.module_path = "puppet/modules"
      puppet.facter = {
        "environment"        => "vagrant",
        "category"           => "builder",
      }
    end
    builder.vm.provider "virtualbox" do |vbbuilder|
      vbbuilder.customize ["modifyvm", :id, "--memory", "1024"]
      vbbuilder.customize ["modifyvm", :id, "--cpus", "1"]
      vbbuilder.name = "aio-builder"
    end
  end

end

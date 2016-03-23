# -*- mode: ruby -*-
# vi: set ft=ruby :

## You can modify the below code to fit your preferences. The vital
## lines are the first three; everything else is meant to provide some
## convenient settings for using geco-vm.
Vagrant.configure(2) do |config|

  ## These two blocks 1. name the machine and 2. tell Vagrant to use the
  ## geco-vm virtual machine image (a.k.a. "vagrant box") as a starting point.
  config.vm.define "geco-vm" do |t|
  end
  config.vm.box = "stefco/geco-vm"

  ## If you want to run x11 applications in geco-vm and access them without the
  ## virtualbox gui, you can UNCOMMENT these two lines to enable x11 forwarding.
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  ## UNCOMMENT the below line for MEDM/EPICS over port 16253
  config.vm.network "forwarded_port", guest: 16253, host: 16253

  ## UNCOMMENT the below line to forward port 8888 from geco-vm to your host
  ## computer. This lets you run Jupyter (aka iPython notebooks) on geco-vm and
  ## access them on the same port (8888) as you usually would in your host OS.
  ## You will be able to access them as usual 
  # config.vm.network "forwarded_port", guest: 8888, host: 8888

  ## You can increase the number of machine cores or ram available by modifying
  ## the next section. There are many ways to do this, so I leave it to you
  ## to Google your way through the specific changes you want to make.
  config.vm.provider "virtualbox" do |vb|
    vb.name = "geco-vm"
    vb.memory = "1024"
    ## COMMENT out the next two lines if you want to run with no gui and just
    ## use ssh.
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.gui = true
  end

  ## If you want to run a custom script when initializing this vagrant box, you
  ## can do so by UNCOMMENTING the below line and CHANGING THE PATH to match
  ## that of the provisioning script that you would like to run:
  # config.vm.provision :shell, path: "path-to-provisioning-script.sh"
end

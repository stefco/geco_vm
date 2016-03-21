# GECo Virtual Machine

## Introduction

This is a virtual machine with all important LIGO-related software
pre-installed.

I am building this because dealing with LIGO's dependencies is a hassle and
a waste of time. Doing any work at remotely is a difficult proposition (unless
you are `ssh`ed into a LIGO server, which is frequently impossible or
undesirable), and setup is not uniform across OSes.
I imagine I am not the only one who has this problem, so I hope that others
might find this useful.

## Using the Virtual Machine

If you just want to _use_ the virtual machine, you can follow these instructions
to get started. These instructions should work on any system.

 1. Download and install the latest version of [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
 2. Download and install the latest version of [Vagrant](https://www.vagrantup.com/downloads.html)
 3. Download this repository's [Vagrantfile](https://github.com/stefco/geco_vm/raw/master/Vagrantfile)
    to the folder you want to work in, or
    [create a default Vagrantfile](#using-the-default-vagrant-file)
    if you'd like a fresh start.
 4. Run `vagrant up` to download and boot the virtual machine.
 5. Run `vagrant ssh` to start using the virtual machine.

That's it. Once you are `ssh`ed into the guest machine, it is just like using
`ssh` with any other machine. You can run `exit` to return to the host machine.
While not using the guest machine, you can simply run `vagrant` to get a short
list of available commands.

### Using a Default Vagrant File

If you want to start with Vagrant's default "blank" Vagrantfile, you can
generate one by running `vagrant init stefco/geco-vm`. This creates a 
simple Vagrantfile for this box, with some helpful comments on how you can
modify the file to your liking. There are a couple of features of the
`geco_vm` box that are specified in the repository Vagrantfile above, so you
should probably just go ahead and use that one.

### Vagrant Best Practices

You should think of your virtual machine as disposable; ideally, you should
not store any information on it long term. Because Vagrant 
[automatically shares](https://www.vagrantup.com/docs/getting-started/synced_folders.html)
your host computer's vagrant folder (i.e. the folder in which your Vagrantfile
is located) with the guest virtual machine under the `/vagrant` directory, it
is trivially easy to keep your work saved on your host machine by keeping it
in the `/vagrant` directory of the guest machine. This way, if you have to
delete your virtual machine (for example, if you are upgrading to the latest
version), you can do so without having to worry about lost work.

### Updating to the Latest Version of the VM

#### TL;DR:

```bash
vagrant destroy -f
vagrant box remove -f stefco/geco-vm
vagrant up
```

#### Full Instructions, With Explanation

It is easy to make mistakes while upgrading to the latest version of
vagrant if you don't know what you're doing. This can cause you to waste
hours troubleshooting a broken feature that has been fixed on the latest
version of the box simply because you think you've already upgraded (when
in fact you haven't). Knowing how vagrant works
can help immensely in avoiding this peculiar debugging hell.

When you initialize your virtual machine with `vagrant up`, vagrant does the
following:

 1. Checks whether you already have a copy of `stefco/geco-vm` saved in vagrant's
    cache of vagrant boxes
 2. Downloads the latest copy of `stefco/geco-vm` if you do not have a local
    copy; if you **do** have a local copy, **even if it is outdated**, vagrant
    will use that one
 3. Decompresses and copies your local copy of the `stefco/geco-vm` box and
    stores that fresh copy of the virtual machine in the `~/Virtualbox\ VMs`
    directory; this copy will be the virtual machine you use
 4. Starts up the new machine
 5. Runs any provisioning scripts that you specify
    (which allow you to further customize the box before you use it)
 6. Mounts shared folders

Note the following:

  - Simply updating your cached vagrant box to the latest version with
    `vagrant box update` will only update your cached box; **this alone will
    not have any effect on the virtual machine you are already using.**
  - Destroying and recreating your machine using `vagrant destroy -f`
    followed by `vagrant up` will just create a fresh version of the old
    box; you need to make sure you also update the cached
    copy of the vagrant box using `vagrant box update` before you
    reinitialize the virtual machine.

So, to make sure you are using the latest and greatest version of `stefco/geco-vm`,
you should make sure you are in your vagrant working directory on your host
machine and run:

```bash
vagrant destroy -f
vagrant box remove -f stefco/geco-vm
vagrant up
```

You can check on your cached version of this (and all) vagrant boxes by running
`vagrant box list`, and you can see whether you successfully deleted your
running copy of the virtual machine by running `vagrant status`.

### More information on Vagrant
You can read Vagrant's documentation on their
[website](https://www.vagrantup.com) for more information. One of the greatest
benefits of Vagrant (besides its easy, declarative command-line interface) is
that it automatically shares certain files on your host machine with the guest
virtual machine. More specifically, it shares files that are in the same folder
as your Vagrantfile, and it puts these files in the `/vagrant` directory on the
virtual machine.

This makes it trivially easy to work on both machines at once, either through
the command line or through the gui (as long as you've placed your Vagrantfile
in the directory where you are planning on working). This is especially nice in
a headless environment; your `vagrant ssh` session will behave as if the host
and guest OSes are sharing their filesystem. This is nice if, like most people,
you are not interested in spending time transfering files and syncing
environments.

There are many other interesting and useful features of Vagrant that make it
a wonderful tool for streamlining your workflow; again, check out their website
for more information.

## Developing the Base Image

If you are just interested in using this tool, then the following section is not
for you. If, however, you are interested in adding features to the base image
(especially features that would be useful to other people), then read on.

This machine is built and deployed using a tool called Packer, made by the same
people who make Vagrant. Configuration information for creating a virtual
machine using [Packer](https://www.packer.io/) can be found on their 
website. The important idea, though, is that Packer
uses a template file (in our case, `geco-vm.json`) to specify:

  - **Builders**, which take an installation disk image (Ubuntu 12.04 LTS
    64-bit, in our case) and make a fresh installation in a new virtual
    machine using the providers of your choice (for us, only VirtualBox, though
    you can get crazy with VMWare, DigitalOcean, Amazon AWS, Docker, etc.)
  - **Provisioners**, which handle file-copying and script running (usually
    runnning a dependency install script, like `provision.sh`, in our case);
    this is the part where you get to customize the box with whatever you need.
  - **Post-Processors**, which package the resulting virtual machine image so
    that it can be used by Vagrant, and which automatically upload the images
    to Atlas (see below).
    
The image created will be available on [HashiCorp
Atlas](https://www.hashicorp.com/atlas.html), whence it will be trivially
easily downloadable using [Vagrant](https://www.vagrantup.com) and will run on
[VirtualBox](https://www.virtualbox.org), all of which are free to use. There
will be a default `Vagrantfile` provided with this repository to make it easy
for people to get started right away.

[This tutorial](http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html)
was invaluable in getting going quickly with Packer. I also found
[this](http://blog.endpoint.com/2014/03/provisioning-development-environment.html)
helpful. And, of course, Packer's own documentation is invaluable.

Without [this ssh configuration example](https://github.com/ChiperSoft/Packer-Vagrant-Example/blob/master/packer/scripts/vagrant.sh)
from @ChiperSoft I would remain locked out of my own box (Thanks!).

As far as provisioning LIGO tools, I drew inspiration from
[DASWG](https://www.vagrantup.com/downloads.html)'s page, from scripts written
by Szabi for provisioning his own Debian box, from conversations with people at
the observatories, and from the gwpy .travis.yml configuration scripts, which
are capable of provisioning an Ubuntu 12.04 installation on Travis CI's servers
sufficiently well for gwpy to install properly (though they use source
installations, which I avoid for the sake of build speed).

## Notes on LIGO Data Grid

  - **Different data is available at different sites.** See [here](https://www.lsc-group.phys.uwm.edu/lscdatagrid/resources/data/index.html) for a breakdown of what is where.

## To Do

- [x] Get `packer build` working with the Ubuntu 12.04 virtualbox machine
- [x] Get ligo tools installed
- [x] Get this machine up on atlas
- [x] Write a demo Vagrantfile with how-to explanations
- [x] Install Globus/Condor/DataGrid
- [x] Install `gwpy`
- [ ] Install `geco_stat`
- [ ] ???
- [ ] Profit

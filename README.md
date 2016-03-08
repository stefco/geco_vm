# GECo Virtual Machine

## Introduction

Configuration information for creating a virtual machine using
[Packer](https://www.packer.io/intro/getting-started/provision.html), an
open-source tool for making portable machine images.

I am building this because dealing with LIGO's dependencies is a hassle and
a waste of time. Doing any work at remotely is a difficult proposition (unless
you are `ssh`ed into a LIGO server, which is frequently impossible or
undesirable), and setup is not uniform across OSes.
I imagine I am not the only one who has this problem, so I hope that others
might find this useful.

## Usage

The image created will be available on [HashiCorp Atlas](https://www.hashicorp.com/atlas.html),
whence it will be trivially easily downloadable using [Vagrant](https://www.vagrantup.com)
and will run on [VirtualBox](https://www.virtualbox.org), all of which are free
to use. There will be a default `Vagrantfile` provided with this repository to
make it easy for people to get started right away.

[This tutorial](http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html)
was invaluable in getting going quickly with Packer. I also found
[this](http://blog.endpoint.com/2014/03/provisioning-development-environment.html)
helpful. And, of course, Packer's own documentation is invaluable.

As far as provisioning LIGO tools, I am using the gwpy .travis.yml configuration
scripts, which are capable of provisioning an Ubuntu 12.04
installation on Travis CI's servers sufficiently well for gwpy to install
properly.

## To Do

- [x] Get `packer build` working with the Ubuntu 12.04 virtualbox machine
- [x] Get ligo tools installed
- [ ] Get this machine up on atlas
- [ ] Write a demo Vagrantfile with how-to explanations
- [ ] ???
- [ ] Profit

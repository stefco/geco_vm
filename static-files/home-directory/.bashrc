# export PATH=$PATH'/home/vagrant/bin'

# This section was created during Vagrant provisioning. ASCII art courtesy
# of http://patorjk.com/software/taag/

cat <<__WELCOME_MESSAGE__


  ____ ____ ____ ____ 
 ||G |||E |||C |||o ||
 ||__|||__|||__|||__||
 |/__\|/__\|/__\|/__\|

Welcome to the GECo VM!

The directory in which you ran 'vagrant up' is shared with this virtual
machine. To access it, simply type 'cd /vagrant'.

For help with LIGO DataGrid, LigoDV, using a GUI, etc., run

    geco-help

To authenticate using kinit and ligo-proxy-init in one command, run

    ligo-auth

Email stefan.countryman@ligo.org with questions or suggestions.

__WELCOME_MESSAGE__

# To make sure your system is up-to-date, run:
# 
#     sudo apt-get -y update && sudo apt-get -y upgrade

alias notebook="jupyter notebook --no-browser --ip=0.0.0.0"
export EDITOR=vim

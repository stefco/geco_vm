mkdir -p "${HOME}"/.ssh

hosts=(
    pcdev1.cgca.uwm.edu
    pcdev2.cgca.uwm.edu
    pcdev3.cgca.uwm.edu
    ldas-grid.ligo.caltech.edu
    ldas-pcdev1.ligo.caltech.edu
    ldas-pcdev2.ligo.caltech.edu
    ldas-pcdev3.ligo.caltech.edu
    ldas-pcdev4.ligo.caltech.edu
    ldas-pcdev5.ligo.caltech.edu
    ldas-pcdev6.ligo.caltech.edu
    ldas-pcdev7.ligo.caltech.edu
    ldas-pcdev8.ligo.caltech.edu
    ldas-pcdev9.ligo.caltech.edu
    ldas-pcdev10.ligo.caltech.edu
    ldas-grid.ligo-wa.caltech.edu
    ldas-pcdev1.ligo-wa.caltech.edu
    ldas-pcdev2.ligo-wa.caltech.edu
    ldas-grid.ligo-la.caltech.edu
    ldas-pcdev1.ligo-la.caltech.edu
    ldas-pcdev2.ligo-la.caltech.edu)

# make the .ssh/config file for these hosts to force shared connections
# (this is what allows nautilus browsing)
for host in ${hosts[*]}; do
    echo "Host ${host}" >> "${HOME}"/.ssh/config
    echo "    HostName ${host}" >> "${HOME}"/.ssh/config
    echo "    ControlMaster auto" >> "${HOME}"/.ssh/config
    echo "    ControlPath ~/.ssh/control:%h:%p:%r" >> "${HOME}"/.ssh/config
done

chown -R vagrant "${HOME}"/.ssh
chmod 600 "${HOME}"/.ssh/config

# Add these as right-click options to the desktop launcher
app="${HOME}"/.medm_launcher/browse-data-grid.desktop

# The name of each action is just the host URL:
echo "Actions="$(sed 's/ /;/g' <<<"${hosts[@]}") >> "${app}"

# create an action for each of these host URLs
for host in ${hosts[*]}; do
    echo >> "${app}"
    echo "[Desktop Action ${host}]"  >> "${app}"
    echo "Name=Browse Home Folder on ${host}" >> "${app}"
    echo "Exec=nautilus-gsissh ${host}" >> "${app}"
done

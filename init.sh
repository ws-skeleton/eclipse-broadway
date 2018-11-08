#! /bin/bash

# Set d-bus machine-id
if [ ! -e /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi

# Properly start DBus
echo "eclipse:x:$(id -u):0:root:/root:/bin/bash" >> /etc/passwd
mkdir -p /var/run/dbus
dbus-daemon --system

# Set global DISPLAY
cat << EOF > /etc/profile.d/display.sh

export BROADWAY_DISPLAY=:5
export GDK_BACKEND=broadway
EOF

rm -f /tmp/.X*-lock
broadwayd :5 -p 5000 &
cd ~
echo "Sett env vars"
export BROADWAY_DISPLAY=:5
export GDK_BACKEND=broadway
echo "Starting eclipse..."
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`' using your web browser ***'
java -jar /root/eclipse/plugins/org.eclipse.equinox.launcher_1.5.100.v20180827-1352.jar -data /projects
tail -f /dev/null

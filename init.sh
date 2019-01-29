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
echo "Starting Eclipse IDE..."
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`':5000 using your web browser ***'
/root/eclipse/eclipse -data /projects
tail -f /dev/null

#! /bin/bash

# Set d-bus machine-id
if [ ! -e /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi

# Properly start DBus
mkdir -p /var/run/dbus
dbus-daemon --system

# Set global DISPLAY
cat << EOF > /etc/profile.d/display.sh

export BROADWAY_DISPLAY=:5
export GDK_BACKEND=broadway
EOF

rm -f /tmp/.X*-lock
broadwayd :5 -p 80 &
cd ~
echo "Sett env vars"
export BROADWAY_DISPLAY=:5
export GDK_BACKEND=broadway
echo "Starting eclipse..."
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`' using your web browser ***'
java -jar eclipse/plugins/org.eclipse.equinox.launcher_1.3.200.N20160208-2000.jar -data ~/ws
/bin/bash

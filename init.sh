#! /bin/bash

# Set d-bus machine-id
if [ ! -s /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi
# Properly start DBus
export DISPLAY=:0 # workaround dbus asks for DISPLAY to be set 
echo "eclipse:x:$(id -u):0:root:/root:/bin/bash" >> /etc/passwd
mkdir -p /var/run/dbus
dbus-daemon --system --fork &
export G_MESSAGES_DEBUG=all
export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --fork --print-address)

broadwayd $BROADWAY_DISPLAY -p $BROADWAY_PORT &
cd ~
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`':'`echo $BROADWAY_PORT`' using your web browser ***'

echo "Starting Eclipse IDE..."
/root/eclipse/eclipse -data /root/eclipse-workspace &
# Next 2 lines are workaround for Broadway often missing main window when Import wizard opens
# When broadway get smarter here, we can just add the --launcher.openFile to previous line
sleep 15
/root/eclipse/eclipse --launcher.openFile /projects

# This allows Eclipse IDE to restart without stopping the container
tail -f /dev/null

# Tools to debug the container
#/bin/bash
#gtk3-demo
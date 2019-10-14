#! /bin/bash

# Set d-bus machine-id
if [ ! -s /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi
# Properly start DBus
export DISPLAY=:0 # workaround dbus asks for DISPLAY to be set
#export GTK_DEBUG=all
#export GDK_DEBUG=all  
echo "eclipse:x:$(id -u):0:root:/root:/bin/bash" >> /etc/passwd
mkdir -p /var/run/dbus
dbus-daemon --system --fork &
#export G_MESSAGES_DEBUG=all
export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --fork --print-address)

broadwayd $BROADWAY_DISPLAY -p $BROADWAY_PORT &
cd ~
echo '*** Please connect to http://'`grep $HOSTNAME /etc/hosts | awk '{print $1}'`':'`echo $BROADWAY_PORT`' using your web browser ***'

echo "Starting Eclipse IDE..."
# Use java ... command instead of launcher as it is more stable with broadway
#  -> https://bugs.eclipse.org/bugs/show_bug.cgi?id=551685
# The system properties are necessary to enable restart of the workbench
export eclipseVm=java
export eclipseVmargs="-XX:+UseG1GC
-XX:+UseStringDeduplication
--add-modules=ALL-SYSTEM
-Xms256m
-Xmx1024m
-Dosgi.requiredJavaVersion=1.8
-Dosgi.dataAreaRequiresExplicitInit=true
"
export eclipseCommands="-jar
/root/eclipse/plugins/org.eclipse.equinox.launcher_*.jar
-showSplash
/root/eclipse/plugins/org.eclipse.epp.package.common_*/splash.bmp
-data
/root/eclipse-workspace "
while true; do # workaround "restart" not operational when using `java` instead of launcher
	${eclipseVm} ${eclipseVmargs} -Declipse.vm="${eclipseVm}" -Declipse.vmargs="${eclipseVmargs}" -Declipse.commands="${eclipseCommands}" ${eclipseCommands} 1>/dev/null 2>/dev/null
done &
sleep 20 #instead of sleep, we should wait for some event implying Eclipse IDE is ready to listen
gdbus call --session --dest org.eclipse.swt --object-path /org/eclipse/swt --method org.eclipse.swt.FileOpen "['/projects']"

# This allows Eclipse IDE to restart without stopping the container
tail -f /dev/null

# Tools to debug the container
#/bin/bash
#gtk3-demo

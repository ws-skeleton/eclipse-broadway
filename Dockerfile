FROM fedora:23
RUN useradd me
RUN dnf install -y mutter gnome-settings-daemon wget tar java
RUN echo "Downloading Eclipse"
RUN wget -O ~/eclipse.tar.gz "http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/N20160208-2000/eclipse-SDK-N20160208-2000-linux-gtk-x86_64.tar.gz"
RUN echo "Unzipping Eclipse"
RUN tar xzf ~/eclipse.tar.gz -C ~
COPY ./init.sh /
RUN chmod a+x init.sh
CMD [ "/init.sh" ]

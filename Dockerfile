FROM fedora:23
RUN dnf install -y mutter gnome-settings-daemon wget tar java
RUN echo "Downloading Eclipse" \
    && cd /root && wget -O- "http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/2018-09/R/eclipse-java-2018-09-linux-gtk-x86_64.tar.gz" | tar xz \
    && mkdir /projects && \
    for f in "/etc" "/var/run" "/projects" "/root"; do \
           chgrp -R 0 ${f} && \
           chmod -R g+rwX ${f}; \
       done
COPY ./init.sh /
ENTRYPOINT [ "/init.sh" ]

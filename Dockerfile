FROM debian:jessie
MAINTAINER John Goerzen <jgoerzen@complete.org>
# VNC doesn't start without xfonts-base
RUN apt-get update
RUN apt-get -y -u dist-upgrade
RUN apt-get -y --no-install-recommends install wget
RUN mkdir /tmp/setup
COPY setup/sums /tmp/setup
COPY download.sh /tmp/download.sh
RUN /tmp/download.sh
RUN apt-get -y --no-install-recommends install tightvncserver xfonts-base \
            lwm xterm vim-tiny less ca-certificates balance \
            supervisor zip unzip pwgen xdotool telnet mtools nano \
            qemu-system-x86 qemu-utils samba fatresize dosfstools \
            xvnc4viewer tcpser ser2net && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY startvnc /usr/local/bin
COPY qemuconsole /usr/local/bin
COPY supervisor/ /etc/supervisor/conf.d/
COPY setup/ /tmp/setup/
RUN /tmp/setup/setup.sh

# Dosemu was just used to grab FreeDOS stuff.
RUN apt-get -y --purge remove build-essential gcc bison flex && apt-get -y --purge autoremove && rm -r /tmp/download.sh /tmp/setup

EXPOSE 5901
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]


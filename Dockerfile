FROM debian:stable
WORKDIR /usr/src
RUN apt-get update
RUN apt-get install -uy wget tcputils
RUN wget https://github.com/alexmyczko/ruptime/releases/download/1.8/ruptimed_1.8-1_all.deb
RUN wget https://github.com/alexmyczko/ruptime/releases/download/1.8/ruptime_1.8-1_amd64.deb
RUN apt-get install -uy ./ruptimed*.deb ./ruptime_*.deb
CMD /usr/bin/daemon --user=ruptime:ruptime /usr/bin/mini-inetd 51300 /usr/sbin/ruptimed
EXPOSE 51300

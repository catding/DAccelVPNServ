FROM ubuntu:bionic

MAINTAINER Andrii Zhovtiak <andy@urlog.net>

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y --no-install-recommends build-essential cmake gcc linux-headers-generic git libpcre3-dev libssl-dev liblua5.1-0-dev ca-certificates

RUN cd /tmp \ 
	&& git clone https://github.com/xebd/accel-ppp.git accel-ppp-code \
	&& mkdir /tmp/accel-ppp-code/build \
	&& cd /tmp/accel-ppp-code/build \
	&& cmake  -DLOG_PGSQL=FALSE -DRADIUS=FALSE -DSHAPER=FALSE -DNETSNMP=FALSE  -DBUILD_IPOE_DRIVER=FALSE -DBUILD_VLAN_MON_DRIVER=FALSE -DLUA=FALSE -DKDIR=/usr/src/linux-headers-`uname -r` -DCPACK_TYPE=Ubuntu18  .. \
	&& make \
	&& make install \
	&& rm -rf /tmp/accel-ppp-code

RUN /bin/sed -i "s|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g" /etc/sysctl.conf

RUN apt-get remove -y build-essential cmake gcc linux-headers-generic git libpcre3-dev libssl-dev liblua5.1-0-dev -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0
RUN apt-get clean -y \
	&& apt-get autoclean -y \
	&& apt-get autoremove -y 

VOLUME "/var/log/accel-ppp" "/etc/accel-ppp"

CMD ["/usr/local/sbin/accel-pppd", "-c", "/etc/accel-ppp/accel-ppp.conf", "-p", "/var/run/accel-ppp.pid"]

# DAccelVPNServ
Simple accel-ppp VPN server for Docker

###### How to build:
 
``
 docker build -t zxandy/vpnserv:1.0 .
``

###### How to run:

- mkdir /opt/accel-vpn/etc
- mkdir /opt/accel-vpn/log
- copy accel-ppp.conf and chap-secrets to /opt/accel-vpn/etc
- change X.X.X.X in accel-ppp.conf to server IP address (for pptp, ip-pool, chap-secrets sections).
- **WARNING!** Change username and password if chap-secrets for users
 
``
 docker run --privileged --name vpnserv --net=host --restart=always -td -v /opt/accel-vpn/etc/:/etc/accel-ppp -v /opt/accel-vpn/log:/var/log/accel-ppp:rw zxandy/vpnserv:1.0
``

More information about accel-ppp: https://accel-ppp.org/wiki/doku.php
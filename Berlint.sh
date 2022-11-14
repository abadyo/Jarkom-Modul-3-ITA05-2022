echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update -y
apt-get install squid -y
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo "
acl block_port port 8080
acl allow_port port 443
acl JAM_KERJA time MTWHF 08:00-17:00
acl SELESAI_KERJA time MTWHF 17:00-23:59
acl SEBELUM_KERJA time MTWHF 00:00-08:00
acl ssl_port proto HTTPS
acl CONNECT method CONNECT

http_port 8080
visible_hostname Berlint
dns_nameservers 10.42.2.2

http_access deny ssl_port
http_access deny all
" > /etc/squid/squid.conf

echo "
acl loid-work.com src 10.42.2.2/31
acl franky-work.com src 10.42.2.2/31
acl weekend time S A 00:00-23:59
acl jam_kerja time M T W H F 08:00-17:00
" >/etc/squid/acl.conf

service squid start
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.42.0.0/16
apt-get update -y
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay restart
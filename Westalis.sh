echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update -y
apt-get install isc-dhcp-server -y
echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server
cp /root/dhcpd.conf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
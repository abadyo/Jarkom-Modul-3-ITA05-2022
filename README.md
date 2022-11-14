# Jarkom-Modul-3-ITA05-2022

---

| Nama                            |    NRP     |
| ------------------------------- | :--------: |
| Muhammad Hanif Fatihurrizqi     | 5027201068 |
| Abadila Barasmara Bias Dewandra | 5027201052 |
| Fadly Rachman Drajad Juliantono | 5027201038 |

### Topologi
![topologi](https://user-images.githubusercontent.com/87009835/201457287-3fc9a67c-8dc0-45d4-9508-2e9eb97b291c.jpg)

# Soal 1
Loid bersama Franky berencana membuat peta tersebut dengan kriteria **WISE** sebagai DNS Server, **Westalis** sebagai DHCP Server, **Berlint** sebagai Proxy Server.

## Solusi
Persoalan nomor 1 akan diselesaikan dengan konfigurasi pada tiap node beriringan dengan penyelesaian soal-soal berikutnya.

# Soal 2
Loid bersama Franky berencana membuat Ostania sebagai DHCP Relay

## Solusi
Kita melakukan konfigurasi terlebih dahulu pada Ostania sebagai berikut ini

### Konfigurasi Ostania
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.42.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.42.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.42.3.1
	netmask 255.255.255.0
```

Kemudian melakukan instalasi dhcp relay pada console Ostania
```
apt-get update -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.42.0.0/16
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay restart
```

![Screenshot_1](https://user-images.githubusercontent.com/87009835/201457463-a5b800ec-6461-4cac-8914-9a30ea611918.jpg)

Setelah terinstall, maka akan muncul tampilan seperti berikut ini

![Screenshot_2](https://user-images.githubusercontent.com/87009835/201457517-3362cfbc-e64f-4f8e-9967-f17d0d5f4e2e.jpg)

# Soal 3
Loid dan Franky menyusun peta tersebut dengan hati-hati dan teliti. Ada beberapa kriteria yang ingin dibuat oleh Loid dan Franky, yaitu:

- Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
Westalis sebagai DHCP Server

- Client yang melalui Switch1 mendapatkan range IP dari 10.42.1.50 - 10.42.1.88 dan 10.42.1.120 - 10.42.1.155

## Solusi
Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
Disini kita lakukan instalasi dhcp server terlebih dahulu pada Westalis.
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install isc-dhcp-server -y
```
Kemudian kita cek pada file di /etc/default/isc-dhcp-server dan kita tentukan interfacenya `eth0`
![Screenshot_3](https://user-images.githubusercontent.com/87009835/201457629-8cad1596-cc2f-4331-833c-360d237ef377.jpg)

Lalu, kita akan mengatur range ip pada switch 1. Untuk range IPnya adalah 10.42.1.50 - 10.42.1.88 dan 10.42.1.120 - 10.42.1.155 . Kita atur pada isi file `/etc/dhcp/dhcpd.conf` seperti berikut ini
```
subnet 10.42.1.0 netmask 255.255.255.0 {
   range 10.42.1.50 10.42.1.88;
   range 10.42.1.120 10.42.1.155; 
   option routers 10.42.1.1;
   option broadcast-address 10.42.1.255;
   option domain-name-servers 10.42.2.2, 192.168.122.1;
   default-lease-time 300;
   max-lease-time 6900;
}
```

# Soal 4
Client yang melalui Switch3 mendapatkan range IP dari 10.42.3.10 - 10.42.3.30 dan 10.42.3.60 - 10.42.3.85

## Solusi
Persoalan ini hampir sama seperti tadi. Namun ini ditujukan untuk switch 3 dengan range ip yang diminta adalah 10.42.3.10 - 10.42.3.30 dan 10.42.3.60 - 10.42.3.85.
Kita tambahkan lagi pada isi file `/etc/dhcp/dhcpd.conf` seperti berikut ini
```
subnet 10.42.3.0 netmask 255.255.255.0 {
   range 10.42.3.10 10.42.3.30;
   range 10.42.3.60 10.42.3.85; 
   option routers 10.42.3.1;
   option broadcast-address 10.42.3.255;
   option domain-name-servers 10.42.2.2, 192.168.122.1;
   default-lease-time 600;
   max-lease-time 6900;
}
```
Kita lakukan restart DHCP server pada Westalis
```
Restart westalis service isc-dhcp-server restart
```

# Soal 5
Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.

## Solusi
Pertama kita konfigurasi client seperti berikut ini
```
auto eth0
iface eth0 inet dhcp
```

Command pada setiap console client supaya dapat terhubung ke internet
```
echo "nameserver 192.168.122.1" >/etc/resolv.conf
apt-get update -y
apt-get install bind9 -y
apt-get install lynx -y
```

Kemudian kita konfigurasi dahulu pada WISE supaya terhubung ke internet dan dapat melakukan instalasi
```
echo "nameserver 192.168.122.1" >/etc/resolv.conf
apt-get update -y
apt-get install bind9 -y
apt-get install lynx -y
```
Setelah itu, kita akan membuat DNS Fowarder pada WISE supaya setiap client bisa mengakses  internet. Atur pada file `/etc/bind/named.conf.options`

 ```
 options {
        directory "/var/cache/bind";
        forwarders {
                192.168.122.1;
        };
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
};
 ```

# Soal 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit.

## Solusi 
Untuk melakukan setting durasi waktu bisa diatur didalam file `/etc/dhcp/dhcpd.conf`
- Switch 1
Diminta lama waktunya selama 5 menit atau 300 detik. Maka kita ubah 
```
default-lease-time = 300;
```

- Switch 3
Diminta lama waktunya selama 10 menit atau 600 detik. Maka kita ubah 
```
default-lease-time = 600;
```

Kemudian untuk  waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit atau 6900 detik. Maka kita ubah 
```
max-lease-time 6900;
```

# Soal 7
Loid dan Franky berencana menjadikan Eden sebagai server untuk pertukaran informasi dengan alamat IP yang tetap dengan IP 10.42.3.13

## Solusi
Pertama kita dapatkan terlebih dahulu hwaddress pada eden dengan melihatnya pada file `/etc/network/interfaces`
![Screenshot_4](https://user-images.githubusercontent.com/87009835/201458911-7664bd0b-ac6e-458b-9ce2-26cac226872a.jpg)

Kemudian kita tambahkan pada Westalis di file `/etc/dhcp/dhcpd.conf`
```
host Eden {
   hardware ethernet 5a:56:55:e3:83:2c;
   fixed-address 10.42.3.13;
}
```

# Soal 8
Melakukan block http ketika internet tersambung

## Solusi
Pada Berlint, install `Squid`:
```
apt-get install squid -y
```

lalu backup file `squid.conf`:
```
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
```

lalu masukkan ke file `squid.conf`:
```
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
```

setelah itu, lakukan jalankan squid:
```
service squid start
```

Pada Proxy user(SSS, Garden, dan Eden), gunakan perintah:
```
export http_proxy="http://10.42.2.3:8080"
```

lalu coba ```lynx http://goole.com```
hasilnya akan di block

# Kenadala
1. Tidak ada penjelasan DHCP relay.
2. Proxy tidak bisa dilakukan bersamaan antara waktu dan acl lainnya.


#!/bin/sh
file='/etc/privoxy/config'

cp /etc/privoxy/config.new $file
chown privoxy:privoxy $file

cat <<'EOF' >> "$file"
accept-intercepted-requests 1
listen-address  0.0.0.0:8118
#listen-address [::1]:8118
#logfile logfile
log-messages 1
log-highlight-messages 1
forward-socks5t / 127.0.0.1:9050 .
forward 172.16.*.*/ .
forward 172.17.*.*/ .
forward 172.18.*.*/ .
forward 172.19.*.*/ .
forward 172.20.*.*/ .
forward 172.21.*.*/ .
forward 172.22.*.*/ .
forward 172.23.*.*/ .
forward 172.24.*.*/ .
forward 172.25.*.*/ .
forward 172.26.*.*/ .
forward 172.27.*.*/ .
forward 172.28.*.*/ .
forward 172.29.*.*/ .
forward 172.30.*.*/ .
forward 172.31.*.*/ .
forward 10.*.*.*/ .
forward 192.168.*.*/ .
forward 127.*.*.*/ .
forward localhost/ .
EOF

torrc_file='/etc/tor/torrc'
for key in \
	AutomapHostsOnResolve \
	ControlPort \
	ControlSocket \
	ControlSocketsGroupWritable \
	CookieAuthentication \
	CookieAuthFile \
	CookieAuthFileGroupReadable \
	DNSPort \
	DataDirectory \
	ExitPolicy \
	Log \
	RunAsDaemon \
	SocksPort \
	TransPort \
	User \
	VirtualAddrNetworkIPv4
do
	sed -i "/^[[:space:]]*#*[[:space:]]*${key}[[:space:]]/d" "$torrc_file"
done

cat <<'EOF' >> "$torrc_file"
AutomapHostsOnResolve 1
ControlPort 9051
ControlSocket /etc/tor/run/control
ControlSocketsGroupWritable 1
CookieAuthentication 1
CookieAuthFile /etc/tor/run/control.authcookie
CookieAuthFileGroupReadable 1
DNSPort 5353
DataDirectory /var/lib/tor
ExitPolicy reject *:*
Log notice stderr
RunAsDaemon 0
SocksPort 0.0.0.0:9050 IsolateDestAddr
TransPort 0.0.0.0:9040
User tor
VirtualAddrNetworkIPv4 10.192.0.0/10
EOF

mkdir -p /etc/tor/run
chown -Rh tor /var/lib/tor /etc/tor/run
chmod 0750 /etc/tor/run
rm -rf /tmp/*
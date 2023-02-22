#!/system/bin/sh

if [ "$(id -u)" = "0" ] && [ -z "$(/system/bin/busybox pidof dnsmasq)" ]; then
	/system/bin/sh -T /dev/ptmx -c "/system/bin/dnsmasq -u root -g root --pid-file /dnsmasq.pid" >/dev/null 2>&1
	sleep 1
	if [ -z "$(/system/bin/busybox pidof dnsmasq)" ]; then
		echo "[!] Failed to start dnsmasq, host name resolution may fail." >&2
	fi
else
	echo "[!] Container is running as non-root, unable to start dnsmasq. DNS will be unavailable." >&2
fi

if [ $# -ge 1 ]; then
	exec "$@"
else
	if [ "$(id -u)" = "0" ]; then
		exec /system/bin/su - system -c "/data/data/com.termux/files/usr/bin/login"
	else
		exec /data/data/com.termux/files/usr/bin/login
	fi
fi
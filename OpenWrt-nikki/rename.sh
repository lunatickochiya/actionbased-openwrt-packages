#!/bin/sh

# uninstall mihomo
if [ -x "/bin/opkg" ]; then
	opkg remove luci-i18n-mihomo-zh-cn
	opkg remove luci-app-mihomo
	opkg remove mihomo
elif [ -x "/usr/bin/apk" ]; then
	apk del luci-i18n-mihomo-zh-cn
	apk del luci-app-mihomo
	apk del mihomo
fi
# copy config from mihomo to nikki
cp -f /etc/config/mihomo /etc/config/nikki
# copy files from mihomo to nikki
cp -rf /etc/nikki /etc/mihomo
# remove mihomo config
rm -f /etc/config/mihomo
# remove mihomo files
rm -rf /etc/mihomo
# reload nikki service
service nikki reload

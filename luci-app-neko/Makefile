# See /LICENSE for more information.
# This is free software, licensed under the GNU General Public License v3.
# Copyright (C) 2024 nosignal

include $(TOPDIR)/rules.mk

PKG_MAINTAINER:=nosignal <https://github.com/nosignals/neko>
PKG_NAME:=luci-app-neko
PKG_VERSION:=1.2.4-beta
PKG_RELEASE:=9

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

define Package/$(PKG_NAME)
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for mihomo
	PKGARCH:=all
	DEPENDS:=+kmod-tun +bash +curl +jq +sing-box +php8 +php8-mod-curl
endef

define Package/$(PKG_NAME)/description
    A LuCI support for mihomo
endef

include $(INCLUDE_DIR)/package.mk

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) $(CURDIR)/root $(PKG_BUILD_DIR)
	$(CP) $(CURDIR)/htdocs $(PKG_BUILD_DIR)
	chmod 0755 $(PKG_BUILD_DIR)/root/etc/init.d/neko
	chmod 0755 $(PKG_BUILD_DIR)/root/etc/neko/core/*
	chmod 0755 $(PKG_BUILD_DIR)/root/etc/uci-defaults/99_neko
	sed -i "s/0.0.0-beta/$(PKG_VERSION)/g" $(PKG_BUILD_DIR)/root/etc/neko/core/neko
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/preinst
#!/bin/sh
	if [ -f "/etc/config/neko" ]; then
		/etc/neko/core/neko -c

		cp -f "/etc/config/neko" "/tmp/neko/neko.bak"
		cp -rf "/etc/neko/" "/tmp/neko/"

		rm -rf /etc/neko/core/* >/dev/null 2>&1
		rm -rf /www/nekoclash/ >/dev/null 2>&1
	fi
	exit 0
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
	if [ -f "/tmp/neko/neko.bak" ]; then
		cp -rf "/tmp/neko/geoip.metadb" "/etc/neko/geoip.metadb"
		cp -rf "/tmp/neko/geosite.db" "/etc/neko/geosite.db"
		cp -rf "/tmp/neko/geoip.dat" "/etc/neko/geoip.dat"
		cp -rf "/tmp/neko/geosite.dat" "/etc/neko/geosite.dat"

		cp -rf /tmp/neko/config/* "/etc/neko/config/"
		cp -rf /tmp/neko/proxy_provider/* "/etc/neko/proxy_provider/"
		cp -rf /tmp/neko/rule_provider/* "/etc/neko/rule_provider/"
	fi
	exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
	/etc/neko/core/neko -k

	cp -rf "/etc/neko/" "/tmp/neko/"
	cp -rf "/www/nekoclash/" "/tmp/neko/nekoclash/"
	cp -f "/etc/config/neko" "/tmp/neko/neko.bak"
	exit 0
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh
	rm -rf /etc/neko/ >/dev/null 2>&1
	rm -rf /www/nekoclash/ >/dev/null 2>&1
	exit 0
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/neko
	$(INSTALL_DIR) $(1)/www
	$(CP) $(PKG_BUILD_DIR)/root/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/htdocs/* $(1)/www/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=pdnsd
PKG_VERSION:=1.2.9b-par
PKG_RELEASE:=115

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocks/pdnsd.git
PKG_SOURCE_DATE:=2012-04-26
PKG_SOURCE_VERSION:=a8e46ccba7b0fa2230d6c42ab6dcd92926f6c21d
PKG_MIRROR_HASH:=skip

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/pdnsd-alt
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Proxy DNS Server
  DEPENDS:=+libpthread
endef

define Package/pdnsd-alt/description
  pdnsd, is an IPv6 capable proxy DNS server with permanent caching (the cache
  contents are written to hard disk on exit) that is designed to cope with
  unreachable or down DNS servers (for example in dial-in networking).

  pdnsd can be used with applications that do dns lookups, eg on startup, and
  can't be configured to change that behaviour, to prevent the often
  minute-long hangs (or even crashes) that result from stalled dns queries.
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include

CONFIGURE_ARGS += \
	--with-cachedir=/var/pdnsd \
	--with-target=Linux

define Package/pdnsd-alt/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/pdnsd $(1)/usr/sbin/pdnsd
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/pdnsd-ctl $(1)/usr/sbin/pdnsd-ctl

	#$(INSTALL_DIR) $(1)/etc
	#$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/pdnsd.conf.sample $(1)/etc/pdnsd.conf
	#$(INSTALL_DIR) $(1)/etc/init.d
	#$(INSTALL_BIN) ./files/pdnsd.init $(1)/etc/init.d/pdnsd
endef

$(eval $(call BuildPackage,pdnsd-alt))

# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=dns2socks
PKG_VERSION:=2.1
PKG_RELEASE:=6

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).zip
PKG_SOURCE_URL:=@SF/dns2socks/SourceCode.zip?
PKG_SOURCE_DATE:=2020-02-18
PKG_HASH:=skip

PKG_MAINTAINER:=ghostmaker
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILE:=LICENSE

include $(INCLUDE_DIR)/package.mk

UNZIP_CMD:=unzip -q -d $(PKG_BUILD_DIR) $(DL_DIR)/$(PKG_SOURCE)

define Package/dns2socks
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNS to SOCKS or HTTP proxy
  URL:=http://dns2socks.sourceforge.net/
  DEPENDS:=+libpthread
endef

define Package/dns2socks/description
  This is a command line utility to resolve DNS requests via
  a SOCKS tunnel like Tor or a HTTP proxy.
endef

define Build/Compile
	$(TARGET_CC) \
	$(TARGET_CFLAGS) \
	$(TARGET_CPPFLAGS) \
	$(FPIC) \
	-o $(PKG_BUILD_DIR)/DNS2SOCKS/dns2socks \
	$(PKG_BUILD_DIR)/DNS2SOCKS/DNS2SOCKS.c \
	$(TARGET_LDFLAGS) -pthread
endef

define Package/dns2socks/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/DNS2SOCKS/dns2socks $(1)/usr/bin/dns2socks
endef

$(eval $(call BuildPackage,dns2socks))

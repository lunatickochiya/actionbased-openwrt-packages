#
# Copyright (C) 2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ympd
PKG_VERSION:=1.3.0
PKG_RELEASE:=4
PKG_MAINTAINER:=Douglas Orend <doug.orend2@gmail.com>

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/notandy/ympd
PKG_SOURCE_VERSION:=ec008a4995666d673bd4cb3926fae7f4b6aa3239
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/ympd
    TITLE:=ympd
    SECTION:=utils
    CATEGORY:=Utilities
    URL:=http://ympd.org
    DEPENDS:=+libmpdclient +libpthread +libopenssl
endef

define Package/ympd/description
    MPD Web GUI - written in C, utilizing Websockets and Bootstrap/JS
endef

TARGET_CFLAGS += "-std=gnu99"
TARGET_LDFLAGS += -lpthread -lmpdclient

define Package/ympd/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ympd $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DATA) ./etc/config/ympd $(1)/etc/config/

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./etc/init.d/ympd $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/etc/uci-defaults/
	$(INSTALL_BIN) ./etc/uci-defaults/ympd $(1)/etc/uci-defaults/
endef

$(eval $(call BuildPackage,ympd))

#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cups-bjnp
PKG_VERSION:=2.0.3
PKG_RELEASE:=5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/cups-bjnp
PKG_HASH:=skip

PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/cups-bjnp
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Printing
  TITLE:=BJNP protocol backend for CUPS
  URL:=http://sourceforge.net/projects/cups-bjnp/
  DEPENDS:=cups
endef

define Package/cups-bjnp/description
  CUPS backend for the canon printers using the proprietary USB over
  IP BJNP protocol. This backend allows Cups to print over the network
  to a Canon printer. It currently supports Cups 1.2 and Cups 1.3 and
  is designed by reverse engineering.
endef

CONFIGURE_ARGS+= --with-cupsbackenddir=$(STAGING_DIR)/usr/include/cups

TARGET_CFLAGS+= -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

define Package/cups-bjnp/install
	$(INSTALL_DIR) $(1)/usr/lib/cups/backend
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bjnp $(1)/usr/lib/cups/backend
endef

$(eval $(call BuildPackage,cups-bjnp))

#
# Copyright 2019-2020 Michael BD7MQB <bd7mqb@qq.com>
# This is free software, licensed under the GNU GENERAL PUBLIC LICENSE, Version 2.0
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-cal
PKG_REV:=149a235
PKG_VERSION:=1.3.0
PKG_RELEASE:=10

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/lazywalker/MMDVMCal
PKG_MIRROR_HASH:=skip
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=149a23561af2665abd00b4e9c0aeba646bb1198e
PKG_SOURCE_PROTO:=git
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Michael BD7MQB <bd7mqb@qq.com>

include $(INCLUDE_DIR)/package.mk

define Package/${PKG_NAME}
	SECTION:=net
	CATEGORY:=MMDVM
	TITLE:=MMDVM Cal
	URL:=https://github.com/g4klx/MMDVMCal
	DEPENDS:=+libstdcpp
endef

define Package/${PKG_NAME}/description
The calibration program for the MMDVM
endef

TARGET_CXXFLAGS = -O3 -std=c++0x

TARGET_LDFLAGS = -L$(STAGING_DIR)/usr/lib

MAKE_FLAGS +=\
		LD=$(TARGET_CXX) \
        CXXFLAGS="$(TARGET_CXXFLAGS)" \
        LDFLAGS="$(TARGET_LDFLAGS)" \

define Package/${PKG_NAME}/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMCal $(1)/usr/sbin/
endef

define Package/${PKG_NAME}/conffiles
endef

$(eval $(call BuildPackage,${PKG_NAME}))
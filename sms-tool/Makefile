# 2017 - 2021 Cezary Jackiewicz <cezary@eko.one.pl>
# 2014 lovewilliam <ztong@vt.edu>
# sms tool for various of 3g/4g modem
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sms-tool
PKG_RELEASE:=14

PKG_SOURCE_URL:=https://github.com/obsy/sms_tool
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2023-09-21
PKG_SOURCE_VERSION:=ee229370eed5f2907cdfba95f17bc913a238b17e
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=Andrey Butirsky <butirsky@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE-2.0.txt

include $(INCLUDE_DIR)/package.mk

define Package/sms-tool
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=SMS tool for 3G/4G modems
  URL:=https://github.com/obsy/sms_tool
endef

define Package/sms-tool/description
  SMS Tool for 3G/4G modem
endef

define Package/sms-tool/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sms_tool $(1)/usr/bin/
endef

$(eval $(call BuildPackage,sms-tool))

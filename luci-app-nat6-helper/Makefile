
include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-nat6-helper

PKG_LICENSE:=MIT License

LUCI_TITLE:=LuCI support for nat6
LUCI_DEPENDS:=
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
config PACKAGE_$(PKG_NAME)_INCLUDE_mod-nat
	bool "mod-nat"
	select PACKAGE_ip6tables-mod-nat
	depends on PACKAGE_$(PKG_NAME)
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_main
	bool "main"
	select PACKAGE_ip6tables
	depends on PACKAGE_$(PKG_NAME)
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_extra
	bool "extra"
	select PACKAGE_ip6tables-extra
	depends on PACKAGE_$(PKG_NAME)
	default y
endef

PKG_MAINTAINER:=<https://github.com/Ausaci/luci-app-nat6-helper>

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature


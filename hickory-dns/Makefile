include $(TOPDIR)/rules.mk

PKG_NAME:=hickory-dns
PKG_VERSION:=0.26.0-alpha.1
PKG_RELEASE:=80

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hickory-dns/hickory-dns.git
PKG_SOURCE_VERSION:=7d6a6072030de31a813c1ac8b8aade152cd2fe3f
PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1

RUST_PKG_FEATURES:=resolver,tls-ring,https-ring,quic-ring,h3-ring,rustls-platform-verifier,sqlite,prometheus-metrics

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

define Package/hickory-dns
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=A plug-in DNS forwarder/splitter
  URL:=https://github.com/hickory-dns/hickory-dns
  DEPENDS:=$(RUST_ARCH_DEPENDS)
endef

define Build/Compile
  $(call Build/Compile/Cargo,bin,--no-default-features)
endef

define Package/hickory-dns/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/hickory-dns/
	$(INSTALL_BIN) ./files/etc/init.d/hickory-dns $(1)/etc/init.d/hickory-dns
	$(INSTALL_BIN) ./files/etc/hickory-dns/forwarder.toml $(1)/etc/hickory-dns/forwarder.toml
endef

$(eval $(call RustBinPackage,hickory-dns))
$(eval $(call BuildPackage,hickory-dns))

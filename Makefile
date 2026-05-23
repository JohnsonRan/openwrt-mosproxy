include $(TOPDIR)/rules.mk

PKG_NAME:=mosproxy
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/JohnsonRan/mosproxy.git
PKG_SOURCE_DATE:=2026-05-23
PKG_SOURCE_VERSION:=515e1f1fb710dff03401b3d90e75e640927f4596
PKG_MIRROR_HASH:=skip
PKG_VERSION:=$(subst -,.,$(PKG_SOURCE_DATE))

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/IrineSistiana/mosproxy
GO_PKG_BUILD_PKG:=$(GO_PKG)
GO_PKG_LDFLAGS_X:=main.version=$(PKG_VERSION)-$(PKG_RELEASE)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/mosproxy
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DNS forwarding and proxy service
  URL:=https://github.com/JohnsonRan/mosproxy
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle +firewall4
endef

define Package/mosproxy/description
 mosproxy is a DNS forwarding/proxy service. This package installs the
 mosproxy binary, a procd init script, and the default config under
 /etc/mosproxy.
endef

define Package/mosproxy/conffiles
/etc/config/mosproxy
/etc/mosproxy/config.yml
endef

define Package/mosproxy/install
	$(call GoPackage/Package/Install/Bin,$(1))
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/mosproxy.uci $(1)/etc/config/mosproxy
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mosproxy.init $(1)/etc/init.d/mosproxy
	$(INSTALL_DIR) $(1)/etc/mosproxy
	$(INSTALL_DATA) ./files/config.yml $(1)/etc/mosproxy/config.yml
	$(INSTALL_DIR) $(1)/usr/share/mosproxy
	$(INSTALL_DATA) ./files/99-dns-redirect.nft $(1)/usr/share/mosproxy/99-dns-redirect.nft
endef

$(eval $(call GoBinPackage,mosproxy))
$(eval $(call BuildPackage,mosproxy))

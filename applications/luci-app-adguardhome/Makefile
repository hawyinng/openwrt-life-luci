# Copyright (C) 2018-2019 Lienol
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-adguardhome
PKG_VERSION:=1.8
PKG_RELEASE:=11

PKG_LICENSE:=MIT
PKG_MAINTAINER:=<https://github.com/rufengsuixing/luci-app-adguardhome>

LUCI_TITLE:=LuCI support for adguardhome
LUCI_DEPENDS:=+wget
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/usr/bin/AdGuardHome/
/usr/share/AdGuardHome/
/etc/config/AdGuardHome
endef

include $(TOPDIR)/feeds/luci/luci.mk


# call BuildPackage - OpenWrt buildroot signature

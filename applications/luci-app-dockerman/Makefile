#
# Copyright (C) 2020 lisaac <lisaac.cn@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Docker Manager interface for LuCI
LUCI_DEPENDS:=+luci-compat +luci-lib-docker +docker-ce +e2fsprogs +fdisk
LUCI_PKGARCH:=all
PKG_VERSION:=0.4.0
PKG_RELEASE:=1

PKG_MAINTAINER:=lisaac <https://github.com/lisaac/luci-app-dockerman>
PKG_LICENSE:=AGPL-3.0

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

#
# Copyright (C) 2019 lisaac <lisaac.cn@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Disk Manager interface for LuCI
LUCI_DEPENDS:=+e2fsprogs +parted +smartmontools +blkid +lsblk
LUCI_PKGARCH:=all
PKG_VERSION:=0.2.7
PKG_RELEASE:=2

PKG_MAINTAINER:=lisaac <https://github.com/lisaac/luci-app-diskman>
PKG_LICENSE:=AGPL-3.0

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

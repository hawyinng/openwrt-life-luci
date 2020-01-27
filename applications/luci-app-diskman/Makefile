#
# Copyright (C) 2017-2019 Xingwang Liao <kuoruan@gmail.com>
#
# This is free software, licensed under the MIT License.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Disk Manager interface for LuCI
LUCI_DEPENDS:=+luci-compat +e2fsprogs +parted +smartmontools +blkid
LUCI_PKGARCH:=all
PKG_VERSION:=0.1.5
PKG_RELEASE:=1

PKG_MAINTAINER:=lisaac <https://github.com/lisaac/luci-app-diskman>
PKG_LICENSE:=Apache-2.0

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

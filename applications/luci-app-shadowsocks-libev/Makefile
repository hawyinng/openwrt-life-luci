#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for Shadowsocks-libev
LUCI_DEPENDS:=+shadowsocks-libev-ss-local +shadowsocks-libev-ss-redir \
+shadowsocks-libev-ss-tunnel +iptables-mod-tproxy +ip-full +ipset

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

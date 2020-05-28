# Copyright (C) 2018-2020 Lienol <lawlienol@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-passwall
PKG_VERSION:=3.6
PKG_RELEASE:=40
PKG_DATE:=20200411

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/config
menu "Configuration"

config PACKAGE_$(PKG_NAME)_INCLUDE_ipt2socks
	bool "Include ipt2socks"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks
	bool "Include Shadowsocks Redir (ss-redir)"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR
	bool "Include ShadowsocksR Redir (ssr-redir)"
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks_socks
	bool "Include Shadowsocks Socks (ss-local)"
	default n
	
config PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR_socks
	bool "Include ShadowsocksR Socks (ssr-local)"
	default n
	
config PACKAGE_$(PKG_NAME)_INCLUDE_V2ray
	bool "Include V2ray"
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_Trojan
	bool "Include Trojan"
	default n
	
config PACKAGE_$(PKG_NAME)_INCLUDE_Brook
	bool "Include Brook"
	default n
	
config PACKAGE_$(PKG_NAME)_INCLUDE_kcptun
	bool "Include kcptun"
	default n

config PACKAGE_$(PKG_NAME)_INCLUDE_haproxy
	bool "Include haproxy"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_ChinaDNS_NG
	bool "Include ChinaDNS-NG"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_pdnsd
	bool "Include pdnsd"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_dns2socks
	bool "Include dns2socks"
	default y
	
config PACKAGE_$(PKG_NAME)_INCLUDE_v2ray-plugin
	bool "Include v2ray-plugin (Shadowsocks plugin)"
	default n

config PACKAGE_$(PKG_NAME)_INCLUDE_simple-obfs
	bool "Include simple-obfs (Shadowsocks plugin)"
	default n

endmenu
endef

LUCI_TITLE:=LuCI support for PassWall
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-compat +luci-lib-ipkg +libmbedtls +iptables-mod-tproxy +ip +ipset +coreutils-base64 +coreutils-nohup +luci-lib-jsonc \
  +wget +resolveip +unzip +dnsmasq-full +tcping +libuci-lua \
  +PACKAGE_$(PKG_NAME)_INCLUDE_ipt2socks:ipt2socks \
  +PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks:shadowsocks-libev-ss-redir \
  +PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR:shadowsocksr-libev-alt \
  +PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks_socks:shadowsocks-libev-ss-local \
  +PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR_socks:shadowsocksr-libev-ssr-local \
  +PACKAGE_$(PKG_NAME)_INCLUDE_V2ray:v2ray-core \
  +PACKAGE_$(PKG_NAME)_INCLUDE_Trojan:trojan \
  +PACKAGE_$(PKG_NAME)_INCLUDE_Trojan:ipt2socks \
  +PACKAGE_$(PKG_NAME)_INCLUDE_Brook:brook \
  +PACKAGE_$(PKG_NAME)_INCLUDE_kcptun:kcptun-client \
  +PACKAGE_$(PKG_NAME)_INCLUDE_haproxy:haproxy \
  +PACKAGE_$(PKG_NAME)_INCLUDE_ChinaDNS_NG:chinadns-ng \
  +PACKAGE_$(PKG_NAME)_INCLUDE_pdnsd:pdnsd-alt \
  +PACKAGE_$(PKG_NAME)_INCLUDE_dns2socks:dns2socks \
  +PACKAGE_$(PKG_NAME)_INCLUDE_v2ray-plugin:v2ray-plugin \
  +PACKAGE_$(PKG_NAME)_INCLUDE_simple-obfs:simple-obfs

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

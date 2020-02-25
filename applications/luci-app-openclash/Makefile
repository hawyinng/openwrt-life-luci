#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-openclash
PKG_VERSION:=0.36.6
PKG_RELEASE:=beta
PKG_MAINTAINER:=vernesong <https://github.com/vernesong/OpenClash>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for clash
	PKGARCH:=all
	DEPENDS:=+iptables +dnsmasq-full +coreutils-nohup +bash +curl +jsonfilter +ca-bundle
	MAINTAINER:=vernesong
endef

define Package/$(PKG_NAME)/description
    A LuCI support for clash
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/preinst
#!/bin/sh
if [ -f "/etc/config/openclash" ]; then
	cp "/etc/config/openclash" "/tmp/openclash.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_rules.list" "/tmp/openclash_custom_rules.list.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_hosts.list" "/tmp/openclash_custom_hosts.list.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_fake_black.conf" "/tmp/openclash_custom_fake_black.conf.bak" >/dev/null 2>&1
	cp "/etc/openclash/history" "/tmp/openclash_history.bak" >/dev/null 2>&1
fi
if [ -f "/etc/openclash/custom/openclash_custom_rules.list" ]; then
	cp "/etc/openclash/custom/openclash_custom_rules.list" "/tmp/openclash_custom_rules.list.bak" >/dev/null 2>&1
	cp "/etc/openclash/custom/openclash_custom_hosts.list" "/tmp/openclash_custom_hosts.list.bak" >/dev/null 2>&1
	cp "/etc/openclash/custom/openclash_custom_fake_black.conf" "/tmp/openclash_custom_fake_black.conf.bak" >/dev/null 2>&1
fi
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
mkdir -p /etc/openclash/config >/dev/null 2>&1
mkdir -p /etc/openclash/proxy_provider >/dev/null 2>&1
mkdir -p /etc/openclash/backup >/dev/null 2>&1
if [ -f "/tmp/openclash.bak" ]; then
	mv "/tmp/openclash.bak" "/etc/config/openclash" >/dev/null 2>&1
	mv "/tmp/openclash_custom_rules.list.bak" "/etc/openclash/custom/openclash_custom_rules.list" >/dev/null 2>&1
	mv "/tmp/openclash_custom_hosts.list.bak" "/etc/openclash/custom/openclash_custom_hosts.list" >/dev/null 2>&1
	mv "/tmp/openclash_custom_fake_black.conf.bak" "/etc/openclash/custom/openclash_custom_fake_black.conf" >/dev/null 2>&1
	mv "/tmp/openclash_history.bak" "/etc/openclash/history" >/dev/null 2>&1
fi
if [ -f "/tmp/config.yaml" ]; then
	mv "/tmp/config.yaml" "/etc/openclash/config/config.yaml" >/dev/null 2>&1
elif [ -f "/tmp/config.yml" ]; then
	mv "/tmp/config.yml" "/etc/openclash/config/config.yaml" >/dev/null 2>&1
elif [ -d "/tmp/openclash_config/" ]; then
  rm -rf "/etc/openclash/config" >/dev/null 2>&1
  mv "/tmp/openclash_config" "/etc/openclash/config" >/dev/null 2>&1
fi
if [ -d "/tmp/openclash_proxy_provider/" ]; then
  rm -rf "/etc/openclash/proxy_provider" >/dev/null 2>&1
  mv "/tmp/openclash_proxy_provider" "/etc/openclash/proxy_provider" >/dev/null 2>&1
fi
if [ -d "/tmp/openclash_game_rules/" ]; then
  rm -rf "/etc/openclash/game_rules" >/dev/null 2>&1
  mv "/tmp/openclash_game_rules" "/etc/openclash/game_rules" >/dev/null 2>&1
fi
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ ! -f "/tmp/openclash_update.sh" ]; then
	rm -rf /etc/openclash/clash >/dev/null 2>&1
fi
	mv "/etc/openclash/config.yaml" "/tmp/config.yaml" >/dev/null 2>&1
	mv "/etc/openclash/config" "/tmp/openclash_config" >/dev/null 2>&1
	mv "/etc/openclash/proxy_provider" "/tmp/openclash_proxy_provider" >/dev/null 2>&1
	mv "/etc/openclash/game_rules" "/tmp/openclash_game_rules" >/dev/null 2>&1
	mv "/etc/openclash/history" "/tmp/openclash_history.bak" >/dev/null 2>&1
	cp "/etc/config/openclash" "/tmp/openclash.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_rules.list" "/tmp/openclash_custom_rules.list.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_hosts.list" "/tmp/openclash_custom_hosts.list.bak" >/dev/null 2>&1
	cp "/etc/config/openclash_custom_fake_black.conf" "/tmp/openclash_custom_fake_black.conf.bak" >/dev/null 2>&1
	cp "/etc/openclash/custom/openclash_custom_rules.list" "/tmp/openclash_custom_rules.list.bak" >/dev/null 2>&1
	cp "/etc/openclash/custom/openclash_custom_hosts.list" "/tmp/openclash_custom_hosts.list.bak" >/dev/null 2>&1
	cp "/etc/openclash/custom/openclash_custom_fake_black.conf" "/tmp/openclash_custom_fake_black.conf.bak" >/dev/null 2>&1
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh
if [ -f "/etc/openclash/clash" ]; then
	rm -rf /etc/openclash/config >/dev/null 2>&1
	rm -rf /etc/openclash/backup >/dev/null 2>&1
	rm -rf /etc/openclash/proxy_provider >/dev/null 2>&1
	rm -rf /etc/openclash/game_rules >/dev/null 2>&1
	rm -rf /etc/openclash/history >/dev/null 2>&1
else
	rm -rf /etc/openclash >/dev/null 2>&1
fi
	rm -rf /lib/upgrade/keep.d/luci-app-openclash >/dev/null 2>&1
	rm -rf /tmp/openclash.log >/dev/null 2>&1
	rm -rf /tmp/openclash_start.log >/dev/null 2>&1
	rm -rf /tmp/Proxy_Group >/dev/null 2>&1
	rm -rf /tmp/rules_name >/dev/null 2>&1
	rm -rf /tmp/openclash_last_version >/dev/null 2>&1
	rm -rf /tmp/clash_last_version >/dev/null 2>&1
	rm -rf /etc/openclash/dnsmasq_fake_block.conf >/dev/null 2>&1
	uci delete firewall.openclash >/dev/null 2>&1
	uci commit firewall >/dev/null 2>&1
	uci delete ucitrack.@openclash[-1] >/dev/null 2>&1
	uci commit ucitrack >/dev/null 2>&1
	rm -rf /tmp/luci*
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/openclash/*
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh_Hans/openclash.po $(1)/usr/lib/lua/luci/i18n/openclash.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

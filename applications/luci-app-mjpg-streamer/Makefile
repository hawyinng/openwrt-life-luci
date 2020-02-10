#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=MJPG-Streamer service configuration module
LUCI_DEPENDS:=+luci-compat +mjpg-streamer +mjpg-streamer-input-uvc +mjpg-streamer-output-file +mjpg-streamer-output-http +mjpg-streamer-www +kmod-video-pwc +kmod-video-uvc +kmod-i2c-core +motion

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

-- Copyright (C) 2014-2018 OpenWrt-dist
-- Copyright (C) 2014-2018 Jian Chang <aa65535@live.com>
-- Licensed to the public under the GNU General Public License v3.

local logfile = "/var/log/up_chnroute.log"
if luci.sys.call("pidof chinadns >/dev/null") == 0 then
	m = Map("chinadns", translate("ChinaDNS"), "%s - %s" %{translate("ChinaDNS"), translate("Running")})
else
	m = Map("chinadns", translate("ChinaDNS"), "%s - %s" %{translate("ChinaDNS"), translate("Not running")})
end

s = m:section(TypedSection, "chinadns", translate("General Settings"))
s.anonymous   = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty     = false

o = s:option(Flag, "bidirectional",
	translate("Enable Bidirectional Filter"),
	translate("Also filter results inside China from foreign DNS servers"))
o.rmempty     = false

o = s:option(Value, "port", translate("Listen Port"))
o.placeholder = 5355
o.default     = 5355
o.datatype    = "port"
o.rmempty     = false

o = s:option(Value, "addr", translate("Listen Address"))
o.placeholder = "0.0.0.0"
o.default     = "0.0.0.0"
o.datatype    = "ipaddr"
o.rmempty     = false

o = s:option(Value, "chnroute", translate("CHNRoute File"))
o.placeholder = "/etc/chnroute.txt"
o.default     = "/etc/chnroute.txt"
o.datatype    = "file"
o.rmempty     = false

o = s:option(Value, "server",
	translate("Upstream Servers"),
	translate("Use commas to separate multiple ip address"))
o.placeholder = "114.114.114.114,127.0.0.1#5354"
o.default     = "114.114.114.114,127.0.0.1#5354"
o.rmempty     = false

return m

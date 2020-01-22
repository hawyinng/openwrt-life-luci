
local sys = require "luci.sys"
local wan_ifname = luci.util.exec("uci get network.wan.ifname")
local lan_ifname = luci.util.exec("uci get network.lan.ifname")
m = Map("macvlan", translate("MACVLAN"),translate("macvlan used to generate a virtual interface."))

s = m:section(TypedSection, "macvlan", translate("Settings"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

enable = s:option(Flag, "enable", translate("Enable"))
enable.optional = false
enable.rmempty = false
enable.default = 1

v_if_name= s:option(Value, "vlanifname", translate("vlanifname"))
v_if_name.default = "vth"
v_if_name.optional = false
v_if_name.rmempty = false

s_if_name = s:option(Value, "ifname", translate("ifname"))
s_if_name.optional = false
s_if_name.rmempty = false
s_if_name.default = wan_ifname 
s_if_name:value(wan_ifname,wan_ifname .. "[wan]")
s_if_name:value(lan_ifname,lan_ifname .. "[lan]")

mac = s:option(Value, "mac", translate("VLAN-MAC-Address"))
mac.optional = false
mac.rmempty = true
mac.default = "" 

for _, e in ipairs(sys.net.devices()) do
	if e ~= "lo" and e ~= "sit0" then s_if_name:value(e) end
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
	luci.util.exec("/etc/init.d/macvlan restart")
end

return m

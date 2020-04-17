--[[by KGHX 2019.01]]--

local sys = require "luci.sys"
local fs = require "nixio.fs"

if sys.call("pidof dnsforwarder > /dev/null") == 0 then
	Status = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	Status = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("dnsforwarder", translate("DNSforwarder") .. Status)

s = m:section(TypedSection, "base", translate("Forwarding queries to customized domains (and their subdomains) to specified servers over a specified protocol (UDP or TCP). non-standard ports are supported."))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))

o = s:taboption("general", Flag, "enable", translate("Enable"))
o.rmempty = false

s:tab("conf1", translate("Basic configuration"))

local file1 = "/etc/dnsforwarder/dnsforwarder.conf"
cf1 = s:taboption("conf1", Value, "_tmp1")
cf1.description = translate("This is the content of the file '/etc/dnsforwarder/dnsforwarder.conf'. Make changes as needed, Take effect immediately after saving & Apply.")
cf1.template = "cbi/tvalue"
cf1.rows = 20
cf1.wrap = "off"
cf1.cfgvalue = function(self, section)
	return fs.readfile(file1) or ""
end
cf1.write = function(self, section, value)
	fs.writefile(file1, value:gsub("\r\n", "\n"))
	sys.call("/etc/init.d/dnsforwarder restart >/dev/null")
end

return m

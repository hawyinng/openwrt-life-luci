--[[by KGHX 2019.11]]--
local fs = require "nixio.fs"
local state = (luci.sys.call("pidof rsync > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("rsyncd", translate("Rsync server") .. state_msg)

s = m:section(TypedSection, "base", translate("rsync is an open source utility that provides fast incremental file transfer."))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("conf1", translate("Server configuration"))

en = s:taboption("general", Flag, "enabled", translate("Enabled"))
en.rmempty = false

local file1 = "/etc/rsyncd.conf"
cf1 = s:taboption("conf1", Value, "_tmp1")
cf1.description = translate("This is the content of the file '/etc/rsyncd.conf'. Make changes as needed, Take effect immediately after saving & Apply.")
cf1.template = "cbi/tvalue"
cf1.rows = 20
cf1.wrap = "off"
cf1.cfgvalue = function(self, section)
	return fs.readfile(file1) or ""
end
cf1.write = function(self, section, value)
	fs.writefile(file1, value:gsub("\r\n", "\n"))
    luci.util.exec("/etc/init.d/rsyncd restart >/dev/null 2>&1")
end

return m

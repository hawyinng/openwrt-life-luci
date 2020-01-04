--[[by KGHX 2019.01]]--
local m, s, o
local sys = require "luci.sys"

local running=(luci.sys.call("pidof nginx > /dev/null") == 0)

if running then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("nginx", translate("Nginx") .. state_msg)

s = m:section(TypedSection, "base", translate("nginx is an HTTP and reverse proxy server."))
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

return m

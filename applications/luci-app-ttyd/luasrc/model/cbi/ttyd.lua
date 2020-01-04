--[[by KGHX 2019.10]]--
-- Licensed to the public under the Apache License 2.0.
local sys = require "luci.sys"
local net = require "luci.model.network".init()
local ifaces = sys.net:devices()
local state=(sys.call("pidof ttyd > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("ttyd", translate("Terminal") .. state_msg)

s = m:section(TypedSection, "ttyd", translate("ttyd Instance"))
s.anonymous = true
s.addremove = true

en = s:option(Flag, "enable", translate("Enable"))
en.rmempty = false
function en.write(self, section, value)
	if value == "1" then
		sys.exec("/etc/init.d/ttyd restart")
	else
		sys.exec("/etc/init.d/ttyd restart")
	end

	Flag.write(self, section, value)
end

o = s:option(Value, "port", translate("Port"), translate("Port to listen (default: 7681, (port=0) is not supported"))
o.datatype = 'port'
o.placeholder = '7681'

o = s:option(ListValue, "interface", translate("Interface name"))
for _, iface in ipairs(ifaces) do
	if not (iface == "lo" or iface:match("^ifb.*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		o:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
o.rmempty = false

o = s:option(Value, "credential", translate("Credential"), translate("Credential for Basic Authentication"))
o.placeholder = 'username:password'

o = s:option(Value, "uid", translate("User ID"))
o.datatype = 'uinteger'

o = s:option(Value, "gid", translate("Group ID"))
o.datatype = 'uinteger'

o = s:option(Value, "signal", translate("Signal"), translate("Signal to send to the command when exit it (default: 1, SIGHUP)"))
o.datatype = 'uinteger'

o = s:option(Flag, "url_arg", translate("Allow URL args"), translate("Allow client to send command line arguments in URL (eg: http://localhost:7681?arg=foo&arg=bar)"))

o = s:option(Flag, "readonly", translate("Read-only"), translate("Do not allow clients to write to the TTY"))

o = s:option(DynamicList, "client_option", translate("Client option"), translate("Send option to client"))
o.placeholder = 'key=value'

o = s:option(Value, "terminal_type", translate("Terminal type"), translate("Terminal type to report (default: xterm-256color)"))
o.placeholder = 'xterm-256color'

o = s:option(Flag, "check_origin", translate("Check origin"), translate("Do not allow websocket connection from different origin"))

o = s:option(Value, "max_clients", translate("Max clients"), translate("Maximum clients to support (default: 0, no limit)"))
o.datatype = 'uinteger'
o.placeholder = '0'

o = s:option(Flag, "once", translate("Once"), translate("Accept only one client and exit on disconnection"))

o = s:option(Value, "index", translate("Index"), translate("Custom index.html path"))
o.placeholder = '/etc/index.html'

o = s:option(Flag, "ipv6", translate("IPv6"), translate("Enable IPv6 support"))

o = s:option(Flag, "ssl", translate("SSL"), translate("Enable SSL"))
o = s:option(Value, "ssl_cert", translate("SSL cert"), translate("SSL certificate file path"))
o:depends("ssl", "1")
o.placeholder = '/etc/cert.pem'

o = s:option(Value, "ssl_key", translate("SSL key"), translate("SSL key file path"))
o:depends("ssl", "1")
o.placeholder = '/etc/privkey.key'

o = s:option(Value, "ssl_ca", translate("SSL ca"), translate("SSL CA file path for client certificate verification"))
o:depends("ssl", "1")
o.placeholder = '/etc/ssl/cert.pem'

o = s:option(Value, "debug", translate("Debug"), translate("Set log level (default: 7)"))
o.placeholder = '7'

o = s:option(Value, "command", translate("Command"))
o.placeholder = '/usr/libexec/login.sh'

return m

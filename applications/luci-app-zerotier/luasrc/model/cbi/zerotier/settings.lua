local sys = require "luci.sys"

a=Map("zerotier",translate("ZeroTier"),translate("Zerotier is an open source, cross-platform and easy to use virtual LAN"))
a:section(SimpleSection).template  = "zerotier/zerotier_status"

t=a:section(NamedSection,"sample_config","zerotier")
t.anonymous=true
t.addremove=false

en=t:option(Flag,"enabled",translate("Enable"))
en.default=0
en.rmempty=false

function en.write(self, section, value)
	if value == "1" then
		sys.exec("/etc/init.d/zerotier enable")
		sys.exec("/etc/init.d/zerotier start")
	else
		sys.exec("/etc/init.d/zerotier stop")
		sys.exec("/etc/init.d/zerotier disable")
	end

	Flag.write(self, section, value)
end

e=t:option(DynamicList,"join",translate('ZeroTier Network ID'))
e.password=true
e.rmempty=false

e=t:option(Flag,"nat",translate("Auto NAT Clients"))
e.default=0
e.rmempty=false
e.description = translate("Allow zerotier clients access your LAN network")

e=t:option(DummyValue,"opennewwindow" , 
	translate("<input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Zerotier.com\" onclick=\"window.open('https://my.zerotier.com/network')\" />"))
e.description = translate("Create or manage your zerotier network, and auth clients who could access")

return a

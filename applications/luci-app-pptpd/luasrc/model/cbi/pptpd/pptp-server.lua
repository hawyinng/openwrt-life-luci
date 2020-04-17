local sys  = require "luci.sys"
local state=(luci.sys.call("pidof pptpd > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

mp = Map("pptpd", translate("PPTP Server") .. state_msg)

s = mp:section(NamedSection, "pptpd", "service", "")
s.anonymouse = true

enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.default = 0
enabled.rmempty = false

localip = s:option(Value, "localip", translate("Server IP"))
localip.datatype = "ip4addr"

remoteip = s:option(Value, "remoteip", translate("Client IP"), translate("The client IP address range is set automatically when it is empty."))
remoteip.datatype = "string"

logging = s:option(Flag, "logwtmp", translate("Debug Logging"))
logging.default = 0
logging.rmempty = false

nat = s:option(Flag, "nat", translate("Proxy forwarding"))
nat.rmempty = false
function nat.write(self, section, value)
	if value == "1" then
		sys.exec("sed -i -e '/## luci-app-pptpd/d' /etc/firewall.user")
		sys.exec("echo 'iptables -A forwarding_rule -i ppp+ -j ACCEPT ## luci-app-pptpd' >> /etc/firewall.user")
		sys.exec("echo 'iptables -A forwarding_rule -o ppp+ -j ACCEPT ## luci-app-pptpd' >> /etc/firewall.user")
		sys.exec("/etc/init.d/firewall restart")
	else
		sys.exec("sed -i -e '/## luci-app-pptpd/d' /etc/firewall.user")
		sys.exec("/etc/init.d/firewall restart")
	end
	Flag.write(self, section, value)
end

logins = mp:section(TypedSection, "login", translate("PPTP Logins"))
logins.addremove = true
logins.anonymouse = true

username = logins:option(Value, "username", translate("Username"))
username.datatype = "string"

password = logins:option(Value, "password", translate("Password"))
password.password = true
password.datatype = "string"

function mp.on_save(self)

	local have_pptp_rule = false
	local have_gre_rule = false

    luci.model.uci.cursor():foreach('firewall', 'rule',
        function (section)
			if section.name == 'pptp' then
				have_pptp_rule = true
			end
			if section.name == 'gre' then
				have_gre_rule = true
			end
        end
    )

	if not have_pptp_rule then
		local cursor = luci.model.uci.cursor()
		local pptp_rulename = cursor:add('firewall','rule')
		cursor:tset('firewall', pptp_rulename, {
			['name'] = 'pptp',
			['target'] = 'ACCEPT',
			['src'] = 'wan',
			['proto'] = 'tcp',
			['dest_port'] = 1723
		})
		cursor:save('firewall')
		cursor:commit('firewall')
	end
	if not have_gre_rule then
		local cursor = luci.model.uci.cursor()
		local gre_rulename = cursor:add('firewall','rule')
		cursor:tset('firewall', gre_rulename, {
			['name'] = 'gre',
			['target'] = 'ACCEPT',
			['src'] = 'wan',
			['proto'] = 47
		})
		cursor:save('firewall')
		cursor:commit('firewall')
	end
end

function mp.on_before_commit (self)
  sys.exec("rm /var/etc/chap-secrets")
end

function mp.on_after_commit(self)
  sys.exec("/etc/init.d/pptpd restart")
end


return mp

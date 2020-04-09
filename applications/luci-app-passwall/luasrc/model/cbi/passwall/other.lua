local api = require "luci.model.cbi.passwall.api.api"

m = Map("passwall")

-- [[ Delay Settings ]]--
s = m:section(TypedSection, "global_delay", translate("Delay Settings"))
s.anonymous = true
s.addremove = false

---- Delay Start
o = s:option(Value, "start_delay", translate("Delay Start"),
             translate("Units:seconds"))
o.default = "1"
o.rmempty = true

---- Open and close Daemon
o = s:option(Flag, "start_daemon", translate("Open and close Daemon"))
o.default = 1
o.rmempty = false

-- [[ Forwarding Settings ]]--
s = m:section(TypedSection, "global_forwarding",
              translate("Forwarding Settings"))
s.anonymous = true
s.addremove = false

---- TCP No Redir Ports
o = s:option(Value, "tcp_no_redir_ports", translate("TCP No Redir Ports"))
o.default = "disable"
o:value("disable", translate("No patterns are used"))
o:value("1:65535", translate("All"))

---- UDP No Redir Ports
o = s:option(Value, "udp_no_redir_ports", translate("UDP No Redir Ports"),
             "<font color='red'>" .. translate(
                 "Fill in the ports you don't want to be forwarded by the agent, with the highest priority.") ..
                 "</font>")
o.default = "disable"
o:value("disable", translate("No patterns are used"))
o:value("1:65535", translate("All"))

---- TCP Redir Ports
o = s:option(Value, "tcp_redir_ports", translate("TCP Redir Ports"))
o.default = "22,25,53,143,465,587,993,995,80,443"
o:value("1:65535", translate("All"))
o:value("22,25,53,143,465,587,993,995,80,443", translate("Common Use"))
o:value("80,443", translate("Only Web"))
o:value("80:", "80 " .. translate("or more"))
o:value(":443", "443 " .. translate("or less"))

---- UDP Redir Ports
o = s:option(Value, "udp_redir_ports", translate("UDP Redir Ports"))
o.default = "1:65535"
o:value("1:65535", translate("All"))
o:value("53", "DNS")

---- Multi SS/SSR Process Option
o = s:option(Value, "process", translate("Multi Process Option"))
o.default = "0"
o.rmempty = false
o:value("0", translate("Auto"))
o:value("1", translate("1 Process"))
o:value("2", "2 " .. translate("Process"))
o:value("3", "3 " .. translate("Process"))
o:value("4", "4 " .. translate("Process"))

---- Socks Proxy Port
local socks_node_num = tonumber(api.uci_get_type("global_other",
                                                  "socks_node_num", 1))
for i = 1, socks_node_num, 1 do
    o = s:option(Value, "socks_proxy_port" .. i, translate("Socks Proxy Port"))
    o.datatype = "port"
    o.default = "108" .. i
end

---- Proxy IPv6
o = s:option(Flag, "proxy_ipv6", translate("Proxy IPv6"),
             translate("The IPv6 traffic can be proxyed when selected"))
o.default = 0

-- [[ Other Settings ]]--
s = m:section(TypedSection, "global_other", translate("Other Settings"),
              "<font color='red'>" .. translatef(
                  "You can only set up a maximum of %s nodes for the time being, Used for access control.",
                  "3") .. "</font>")
s.anonymous = true
s.addremove = false

---- TCP Node Number Option
o = s:option(ListValue, "tcp_node_num", "TCP" .. translate("Node Number"))
o.default = "1"
o.rmempty = false
o:value("1")
o:value("2")
o:value("3")

---- UDP Node Number Option
o = s:option(ListValue, "udp_node_num", "UDP" .. translate("Node Number"))
o.default = "1"
o.rmempty = false
o:value("1")
o:value("2")
o:value("3")

---- Socks Node Number Option
o = s:option(ListValue, "socks_node_num", "Socks" .. translate("Node Number"))
o.default = "1"
o.rmempty = false
o:value("1")
o:value("2")
o:value("3")

---- 状态使用大图标
o = s:option(Flag, "status_use_big_icon", translate("Status Use Big Icon"))
o.default = "1"
o.rmempty = false

---- 显示节点检测
o = s:option(Flag, "status_show_check_port", translate("Status Show Check Port"))
o.default = "0"
o.rmempty = false

---- 显示IP111
o = s:option(Flag, "status_show_ip111", translate("Status Show IP111"))
o.default = "0"
o.rmempty = false

return m

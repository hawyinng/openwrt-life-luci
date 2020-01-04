--[[by KGHX 2019.01]]--
module("luci.controller.dnsforwarder", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/dnsforwarder") then
		return
	end

	entry({"admin", "services", "dnsforwarder"}, cbi("dnsforwarder"), _("DNSforwarder")).dependent = true
end

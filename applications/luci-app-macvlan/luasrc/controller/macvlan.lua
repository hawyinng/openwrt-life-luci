
module("luci.controller.macvlan", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/macvlan") then
		return
	end

	entry({"admin", "network", "macvlan"}, cbi("macvlan"), _("MACVLAN")).dependent = true
end

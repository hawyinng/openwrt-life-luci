-- Licensed to the public under the Apache License 2.0.

module("luci.controller.ttyd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ttyd") then
		return
	end

	entry({"admin", "services", "ttyd"}, cbi("ttyd"), _("TTYD")).dependent = true
end

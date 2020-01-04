-- Licensed to the public under the Apache License 2.0.

module("luci.controller.smbd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/smbd") then
		return
	end

	entry({"admin", "services", "smbd"}, cbi("smbd"), _("Network Shares-smbd")).dependent = true
end

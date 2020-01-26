-- Licensed to the public under the Apache License 2.0.

module("luci.controller.ksmbd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ksmbd") then
		return
	end

	entry({"admin", "services", "ksmbd"}, cbi("ksmbd"), _("Network Shares-ksmbd")).dependent = true
end

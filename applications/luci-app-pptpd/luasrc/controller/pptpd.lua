
module("luci.controller.pptpd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pptpd") then
		return
	end

	entry({"admin", "services", "pptpd"},
		alias("admin", "services", "pptpd", "pptp-server"),
		_("PPTP Server"))

	entry({"admin", "services", "pptpd", "pptp-server"},
		cbi("pptpd/pptp-server"),
		_("General Settings"), 10).leaf = true

	entry({"admin", "services", "pptpd", "online"},
		cbi("pptpd/online"),
		_("Online Users"), 20).leaf = true

end

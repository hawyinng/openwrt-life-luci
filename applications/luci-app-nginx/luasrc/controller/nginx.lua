--[[by KGHX 2019.01]]--
module("luci.controller.nginx", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nginx") then
		return
	end

	entry({"admin", "services", "nginx"}, cbi("nginx"), _("Nginx")).dependent = true
end

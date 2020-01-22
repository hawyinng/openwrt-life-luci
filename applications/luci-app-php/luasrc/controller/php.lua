--[[by KGHX 2019.01]]--
module("luci.controller.php", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/php7-fpm") then
		return
	end

	entry({"admin", "services", "php"}, cbi("php"), _("PHP7")).dependent = true
end

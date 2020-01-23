-- Copyright 2008 Yanira <forum-2008@email.de>
-- Licensed to the public under the Apache License 2.0.

local sys = require "luci.sys"

m = Map("syncthing", translate("Syncthing is an open source distributed data synchronization tool"))

m:section(SimpleSection).template  = "syncthing/syncthing_status"

s = m:section(TypedSection, "setting", translate("Settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

function o.write(self, section, value)
	if value == "1" then
		sys.exec("/etc/init.d/syncthing enable")
		sys.exec("/etc/init.d/syncthing start")
	else
		sys.exec("/etc/init.d/syncthing stop")
		sys.exec("/etc/init.d/syncthing disable")
	end

	Flag.write(self, section, value)
end

o = s:option(Value, "port", translate("Port"))
o.datatype = "port"
o.placeholder = "8384"
o.default = "8384"
o.rmempty = false

return m

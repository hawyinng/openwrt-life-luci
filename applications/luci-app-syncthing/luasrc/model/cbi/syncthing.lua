-- Copyright 2020 ikghx
-- Licensed to the public under the Apache License 2.0.

m = Map("syncthing", translate("Syncthing is an open source distributed data synchronization tool"))

m:section(SimpleSection).template  = "syncthing/syncthing_status"

s = m:section(TypedSection, "syncthing", translate("Settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

o = s:option(ListValue, "user", translate("Run daemon as user"))
o:value("")
local user
for user in luci.util.execi("cat /etc/passwd | cut -d':' -f1") do
	o:value(user)
end

o = s:option(Value, "gui_address", translate("Listening address"))
o.datatype = "ipaddrport"
o.placeholder = "0.0.0.0:8384"
o.default = "0.0.0.0:8384"
o.rmempty = false

o = s:option(Value, "home", translate("Configuration directory"))
o.placeholder = "/etc/syncthing/"
o.default = "/etc/syncthing/"
o.rmempty = false

o = s:option(Value, "nice", translate("Scheduling priority"), translate("Set the scheduling priority of the spawned process."))
o.datatype = "range(-20,19)"
o.default = "19"
o.rmempty = false

o = s:option(Value, "macprocs", translate("Concurrent threads"), translate("0 to match the number of CPUs (default)"))
o.default = "0"
o.rmempty = false

return m

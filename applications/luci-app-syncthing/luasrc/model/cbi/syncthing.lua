-- Copyright 2020 ikghx
-- Licensed to the public under the Apache License 2.0.

m = Map("syncthing", translate("Syncthing is an open source distributed data synchronization tool"))

m:section(SimpleSection).template  = "syncthing/syncthing_status"

s = m:section(TypedSection, "syncthing", translate("Settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

o = s:option(Value, "gui_address", translate("Listening address"))
o.datatype = "ipaddrport"
o.placeholder = "0.0.0.0:8384"
o.default = "0.0.0.0:8384"
o.rmempty = false

o = s:option(Value, "home", translate("Home directory"))
o.placeholder = "/etc/syncthing/"
o.default = "/etc/syncthing/"
o.rmempty = false

o = s:option(Value, "logfile", translate("Log file"))
o.placeholder = "/var/log/syncthing.log"
o.default = "/var/log/syncthing.log"
o.rmempty = false

return m

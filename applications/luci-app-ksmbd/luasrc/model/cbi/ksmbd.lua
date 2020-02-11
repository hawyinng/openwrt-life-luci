--[[by KGHX 2019.10]]--
-- Licensed to the public under the Apache License 2.0.
local sys = require "luci.sys"
local net = require "luci.model.network".init()
local ifaces = sys.net:devices()
local state=(sys.call("pidof ksmbd.mountd > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("ksmbd", translate("Network Shares-ksmbd") .. state_msg)

s = m:section(TypedSection, "globals")
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("template", translate("Edit Template"))

en = s:taboption("general", Flag, "enable", translate("Enable"))
en.rmempty = false

function en.write(self, section, value)
	if value == "1" then
		sys.exec("/etc/init.d/ksmbd enable")
		sys.exec("/etc/init.d/ksmbd start")
	else
		sys.exec("/etc/init.d/ksmbd stop")
		sys.exec("/etc/init.d/ksmbd disable")
	end

	Flag.write(self, section, value)
end

o = s:taboption("general", ListValue, "interface", translate("Interface"), translate("Listen only on the given interface or, if unspecified, on lan"))
for _, iface in ipairs(ifaces) do
	if not (iface == "lo" or iface:match("^ifb.*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		o:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
o.rmempty = false

o = s:taboption("general", Value, "workgroup", translate("Workgroup"))
o.placeholder = "WORKGROUP"

o = s:taboption("general", Value, "description", translate("Description"))
o.placeholder = "Ksmbd on OpenWrt"

o = s:taboption("general", Flag, "allow_legacy_protocols", translate("Allow legacy protocols"))

tmpl = s:taboption("template", Value, "_tmpl","", 
	translate("This is the content of the file '/etc/ksmbd/smb.conf.template' from which your ksmbd configuration will be generated. " ..
		"Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."))

tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/ksmbd/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n", "\n")
	nixio.fs.writefile("/etc/ksmbd/smb.conf.template", value)
end


s = m:section(TypedSection, "share", translate("Shared Directories"), translate("Please add directories to share. Each directory refers to a folder on a mounted device."))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "name", translate("Name"))
pth = s:option(Value, "path", translate("Path"))
pth.placeholder = "/mnt/sda"
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

o = s:option(Flag, "browseable", translate("Browse-able"))
o.enabled = "yes"
o.disabled = "no"
o.default = "yes"

o = s:option(Flag, "read_only", translate("Read-only"))
o.enabled = "yes"
o.disabled = "no"
o.default = "no"
o.rmempty = false

s:option(Flag, "force_root", translate("Force Root"))

o = s:option(Flag, "users", translate("Allowed users"))
o.rmempty = true

o = s:option(Flag, "guest_ok", translate("Allow guests"))
o.enabled = "yes"
o.disabled = "no"
o.default = "yes"
o.rmempty = false

o = s:option(Flag, "inherit_owner", translate("Inherit owner"))
o.enabled = "yes"
o.disabled = "no"
o.default = "no"

o = s:option(Flag, "hide_dot_files", translate("Hide dot files"))
o.enabled = "yes"
o.disabled = "no"
o.default = "yes"

o = s:option(Value, "create_mask", translate("Create mask"))
o.maxlength = 4
o.default = "0666"
o.placeholder = "0666"
o.rmempty = false

o = s:option(Value, "dir_mask", translate("Directory mask"))
o.maxlength = 4
o.default = "0777"
o.placeholder = "0777"
o.rmempty = false


return m

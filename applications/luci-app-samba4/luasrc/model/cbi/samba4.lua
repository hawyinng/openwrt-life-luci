-- Licensed to the public under the Apache License 2.0.
local sys = require "luci.sys"
local net = require "luci.model.network".init()
local ifaces = sys.net:devices()
local state=(sys.call("pidof smbd > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("samba4", translate("Network Shares-samba4") .. state_msg)

s = m:section(TypedSection, "samba")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("template", translate("Edit Template"))

o = s:taboption("general", Flag, "enable", translate("Enable"))
o.rmempty = false

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
o.placeholder = "Samba4 on OpenWrt"

o = s:taboption("general", Flag, "disable_async_io", translate("Force synchronous  I/O"),
	translate("On lower-end devices may increase speeds, by forceing synchronous I/O instead of the default asynchronous."))
o.rmempty = false

o = s:taboption("general", Flag, "macos", translate("Enable macOS compatible shares"),
	translate("Enables Apple's AAPL extension globally and adds macOS compatibility options to all shares."))
o.rmempty = false

if nixio.fs.access("/usr/sbin/nmbd") then
	s:taboption("general", Flag, "disable_netbios", translate("Disable Netbios"))
end
if nixio.fs.access("/usr/sbin/samba") then
	s:taboption("general", Flag, "disable_ad_dc", translate("Disable Active Directory Domain Controller"))
end
if nixio.fs.access("/usr/sbin/winbindd") then
	s:taboption("general", Flag, "disable_winbind", translate("Disable Winbind"))
end

tmpl = s:taboption("template", Value, "_tmpl","", 
	translate("This is the content of the file '/etc/samba/smb.conf.template' from which your samba configuration will be generated. " ..
		"Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."))

tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/samba/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n", "\n")
	nixio.fs.writefile("/etc/samba/smb.conf.template", value)
end


s = m:section(TypedSection, "sambashare", translate("Shared Directories"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "name", translate("Name"))
pth = s:option(Value, "path", translate("Path"))
pth.placeholder = "/mnt/sda"
if nixio.fs.access("/etc/config/fstab") then
	pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

br = s:option(Flag, "browseable", translate("Browse-able"))
br.enabled = "yes"
br.disabled = "no"
br.default = "yes"

o = s:option(Flag, "read_only", translate("Read-only"))
o.enabled = "yes"
o.disabled = "no"
o.default = "no"
o.rmempty = false

s:option(Flag, "force_root", translate("Force Root"))

o = s:option(Value, "users", translate("Allowed users"))
o.rmempty = true

o = s:option(Flag, "guest_ok", translate("Allow guests"))
o.enabled = "yes"
o.disabled = "no"
o.default = "yes"
o.rmempty = false

o = s:option(Flag, "guest_only", translate("Guests only"))
o.enabled = "yes"
o.disabled = "no"
o.default = "no"

o = s:option(Flag, "inherit_owner", translate("Inherit owner"))
o.enabled = "yes"
o.disabled = "no"
o.default = "no"

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

o = s:option(Value, "vfs_objects", translate("Vfs objects"))
o.rmempty = true

s:option(Flag, "timemachine", translate("Apple Time-machine share"))

o = s:option(Value, "timemachine_maxsize", translate("Time-machine size in GB"))
o.rmempty = true
o.maxlength = 5

return m

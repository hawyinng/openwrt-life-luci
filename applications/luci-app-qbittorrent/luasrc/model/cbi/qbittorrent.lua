--[[
	Copyright 2019 KGHX
	Licensed to the public under the Apache License 2.0.
]]--
local ver = luci.util.trim(luci.sys.exec("export HOME=/var/run/qbittorrent && mkdir -p /var/run/qbittorrent && qbittorrent-nox -v | awk '{print $2}'"))
luci.sys.call("rm -rf /var/run/qbittorrent")
local state=(luci.sys.call("pidof qbittorrent-nox > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

function titlesplit(Value)
    return "<p style=\"font-size:20px;font-weight:bold;color: DodgerBlue\">" .. translate(Value) .. "</p>"
end

m = Map("qbittorrent", translate("qBittorrent") .. state_msg, "%s <br\> %s" % {translate("qBittorrent is a cross-platform free and open-source BitTorrent client"),
	"<b style=\"color:red\">" .. translatef("Current Version: %s", ver) .. "</b>"})

m:append(Template("qbittorrent/qbt_status"))

s = m:section(NamedSection, "main", "qbittorrent")

s:tab("basic", translate("General Settings"))

o = s:taboption("basic", Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:taboption("basic", ListValue, "user", translate("Run daemon as user"))
local u
for u in luci.util.execi("cat /etc/passwd | cut -d ':' -f1") do
	o:value(u)
end

o = s:taboption("basic", Value, "profile", translate("Parent Path for Profile Folder"))
o.default = '/mnt/sda/etc'

o = s:taboption("basic", Value, "configuration", translate("Profile Folder Suffix"), translate("Optional: Multiple configuration files coexist"))

s:tab("connection", translate("Connection Settings"))

o = s:taboption("connection", Flag, "UPnP", translate("Use UPnP for Connections"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("connection", Flag, "UseRandomPort", translate("Use Random Port"), translate("An incoming connection port will be randomly generated when the program starts."))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("connection", Value, "PortRangeMin", translate("Port used for incoming connections"), translate("Generate Randomly"))
o:depends("UseRandomPort", false)
o.datatype = "range(1024,65535)"
o.template = "qbittorrent/qbt_value"
o.btnclick = "randomToken();"

o = s:taboption("connection", Value, "GlobalDLLimit", translate("Global Download Speed(KiB/s)"))
o.datatype = "float"
o.placeholder = "0"

o = s:taboption("connection", Value, "GlobalUPLimit", translate("Global Upload Speed(KiB/s)"))
o.datatype = "float"
o.placeholder = "0"

o = s:taboption("connection", Value, "GlobalDLLimitAlt", translate("Alternative Download Speed(KiB/s)"))
o.datatype = "float"
o.placeholder = "10"

o = s:taboption("connection", Value, "GlobalUPLimitAlt", translate("Alternative Upload Speed(KiB/s)"))
o.datatype = "float"
o.placeholder = "10"

o = s:taboption("connection", ListValue, "BTProtocol", translate("Enabled protocol"))
o:value("Both", translate("TCP and UTP"))
o:value("TCP", translate("TCP"))
o:value("UTP", translate("UTP"))
o.default = "Both"

o = s:taboption("connection", Value, "InetAddress", translate("Address used for incoming connections"))

s:tab("downloads", translate("Downloads Settings"))

o = s:taboption("downloads", Flag, "CreateTorrentSubfolder", translate("Create Subfolder"), translate("Create subfolder for torrents with multiple files."))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("downloads", Flag, "StartInPause", translate("Start In Pause"), translate("Do not start the download automatically."))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("downloads", Flag, "AutoDeleteAddedTorrentFile", translate("Auto Delete Torrent File"))
o.enabled = "IfAdded"
o.disabled = "Never"
o.default = "Never"

o = s:taboption("downloads", Flag, "PreAllocation", translate("Pre Allocation disk space"))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("downloads", Flag, "UseIncompleteExtension", translate("Use Incomplete Extension"))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("downloads", Value, "SavePath", translate("Download save path"))
o.placeholder = "/mnt/sda/qBittorrent"

o = s:taboption("downloads", Flag, "TempPathEnabled", translate("Temp Path Enabled"))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("downloads", Value, "TempPath", translate("Temp Path"))
o:depends("TempPathEnabled", "true")
o.placeholder = "/mnt/sda/qBittorrent/temp"

o = s:taboption("downloads", Value, "DiskWriteCacheSize", translate("Disk Cache Size (MiB)"), translate("The value -1 is auto and 0 is disable. In default, it is set to 64MiB."))
o.datatype = "integer"
o.placeholder = "64"

o = s:taboption("downloads", Value, "DiskWriteCacheTTL", translate("Disk Cache TTL (s)"), translate("In default, it is set to 60s."))
o.datatype = "integer"
o.placeholder = "60"

o = s:taboption("downloads", DummyValue, "Saving Management", titlesplit("Saving Management"))

o = s:taboption("downloads", ListValue, "DisableAutoTMMByDefault", translate("Default Torrent Management Mode"))
o:value("true", translate("Manual"))
o:value("false", translate("auto"))
o.default = "true"

o = s:taboption("downloads", ListValue, "CategoryChanged", translate("Torrent Category Changed"))
o:value("true", translate("Switch torrent to Manual Mode"))
o:value("false", translate("Relocate torrent"))
o.default = "false"

o = s:taboption("downloads", ListValue, "DefaultSavePathChanged", translate("Default Save Path Changed"))
o:value("true", translate("Switch affected torrent to Manual Mode"))
o:value("false", translate("Relocate affected torrent"))
o.default = "true"

o = s:taboption("downloads", ListValue, "CategorySavePathChanged", translate("Category Save Path Changed"))
o:value("true", translate("Switch affected torrent to Manual Mode"))
o:value("false", translate("Relocate affected torrent"))
o.default = "true"

o = s:taboption("downloads", Value, "TorrentExportDir", translate("Torrent Export Dir"))

o = s:taboption("downloads", Value, "FinishedTorrentExportDir", translate("Finished Torrent Export Dir"))

s:tab("bittorrent", translate("Bittorrent Settings"))

o = s:taboption("bittorrent", Flag, "DHT", translate("Enable DHT"), translate("Enable DHT (decentralized network) to find more peers"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("bittorrent", Flag, "PeX", translate("Enable PeX"), translate("Enable Peer Exchange (PeX) to find more peers"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("bittorrent", Flag, "LSD", translate("Enable LSD"), translate("Enable Local Peer Discovery to find more peers"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("bittorrent", Flag, "uTP_rate_limited", translate("uTP Rate Limit"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("bittorrent", ListValue, "Encryption", translate("Encryption Mode"))
o:value("0", translate("Prefer Encryption"))
o:value("1", translate("Require Encryption"))
o:value("2", translate("Disable Encryption"))
o.default = "0"

o = s:taboption("bittorrent", Value, "MaxConnecs", translate("Global Max Connections"))
o.datatype = "integer"
o.placeholder = "500"

o = s:taboption("bittorrent", Value, "MaxConnecsPerTorrent", translate("Max Connections Per Torrent"))
o.datatype = "integer"
o.placeholder = "100"

o = s:taboption("bittorrent", Value, "MaxUploads", translate("Global Max Uploads"))
o.datatype = "integer"
o.placeholder = "8"

o = s:taboption("bittorrent", Value, "MaxUploadsPerTorrent", translate("Max Uploads Per Torrent"))
o.datatype = "integer"
o.placeholder = "4"

o = s:taboption("bittorrent", Value, "MaxRatio", translate("Max Ratio"))
o.datatype = "float"
o.placeholder = "1"

o = s:taboption("bittorrent", ListValue, "MaxRatioAction", translate("Max Ratio Action"), translate("The action when reach the max seeding ratio."))
o:value("0", translate("Pause them"))
o:value("1", translate("Remove them"))
o.defaule = "0"

o = s:taboption("bittorrent", Value, "GlobalMaxSeedingMinutes", translate("Max Seeding Minutes"), translate("Units: minutes"))
o.datatype = "integer"

o = s:taboption("bittorrent", DummyValue, "Queueing Setting", titlesplit("Queueing Setting"))

o = s:taboption("bittorrent", Flag, "QueueingEnabled", translate("Enable Torrent Queueing"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("bittorrent", Value, "MaxActiveDownloads", translate("Maximum Active Downloads"))
o:depends("QueueingEnabled", "true")
o.datatype = "integer"
o.placeholder = "3"

o = s:taboption("bittorrent", Value, "MaxActiveUploads", translate("Max Active Uploads"))
o:depends("QueueingEnabled", "true")
o.datatype = "integer"
o.placeholder = "3"

o = s:taboption("bittorrent", Value, "MaxActiveTorrents", translate("Max Active Torrents"))
o:depends("QueueingEnabled", "true")
o.datatype = "integer"
o.placeholder = "5"

o = s:taboption("bittorrent", Flag, "IgnoreSlowTorrents", translate("Ignore Slow Torrents"), translate("Do not count slow torrents in these limits."))
o:depends("QueueingEnabled", "true")
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("bittorrent", Value, "SlowTorrentsDownloadRate", translate("Download rate threshold"), translate("Units: KiB/s"))
o:depends("IgnoreSlowTorrents", "true")
o.datatype = "integer"
o.placeholder = "2"

o = s:taboption("bittorrent", Value, "SlowTorrentsUploadRate", translate("Upload rate threshold"), translate("Units: KiB/s"))
o:depends("IgnoreSlowTorrents", "true")
o.datatype = "integer"
o.placeholder = "2"

o = s:taboption("bittorrent", Value, "SlowTorrentsInactivityTimer", translate("Torrent inactivity timer"), translate("Units: seconds"))
o:depends("IgnoreSlowTorrents", "true")
o.datatype = "integer"
o.placeholder = "60"

s:tab("webgui", translate("WebUI Settings"))

o = s:taboption("webgui", Value, "Locale", translate("Locale Language"))
o:value("en", translate("English"))
o:value("zh", translate("Chinese"))
o.default = "zh"

o = s:taboption("webgui", Value, "Username", translate("Username"), translate("The login name for WebUI."))
o.placeholder = "admin"

o = s:taboption("webgui", Value, "Password", translate("Password"), translate("The login password for WebUI."))
o.password  =  true

o = s:taboption("webgui", Value, "Port", translate("Listen Port"), translate("The listening port for WebUI."))
o.datatype = "port"
o.placeholder = "8080"

o = s:taboption("webgui", Flag, "UseUPnP", translate("Use UPnP for WebUI"), translate("Using the UPnP/NAT-PMP port of the router for connecting to WebUI."))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("webgui", Flag, "CSRFProtection", translate("CSRF Protection"), translate("Enable Cross-Site Request Forgery (CSRF) protection."))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("webgui", Flag, "ClickjackingProtection", translate("Clickjacking Protection"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("webgui", Flag, "HostHeaderValidation", translate("Host Header Validation"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("webgui", Flag, "LocalHostAuth", translate("Local Host Authentication"), translate("Force authentication for clients on localhost."))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("webgui", Flag, "AuthSubnetWhitelistEnabled", translate("Enable Subnet Whitelist"), translate("No authentication is required for clients in the whitelist"))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("webgui", DynamicList, "AuthSubnetWhitelist", translate("Subnet Whitelist"))
o:depends("AuthSubnetWhitelistEnabled", "true")

s:tab("advanced", translate("Advance Settings"))

o = s:taboption("advanced", Flag, "AnonymousMode", translate("Anonymous Mode"), translate("Generally used to prevent p2p blocking."))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("advanced", Flag, "SuperSeeding", translate("Super Seeding"), translate("Generally used by Torrent publishers."))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("advanced", Flag, "IncludeOverhead", translate("Limit Overhead Usage"), translate("Apply rate limit to transport overhead"))
o.enabled = "true"
o.disabled = "false"
o.default = "false"

o = s:taboption("advanced", Flag, "IgnoreLimitsLAN", translate("Ignore speed limit to LAN"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Flag, "osCache", translate("Use OS Cache"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Value, "OutgoingPortsMin", translate("Min Outgoing Port"))
o.datatype = "port"

o = s:taboption("advanced", Value, "OutgoingPortsMax", translate("Max Outgoing Port"))
o.datatype = "port"

o = s:taboption("advanced", ListValue, "SeedChokingAlgorithm", translate("Choking Algorithm"))
o:value("RoundRobin", translate("Round Robin"))
o:value("FastestUpload", translate("Fastest Upload"))
o:value("AntiLeech", translate("Anti-Leech"))
o.default = "AntiLeech"

o = s:taboption("advanced", Flag, "AnnounceToAllTrackers", translate("Announce To All Trackers"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Flag, "AnnounceToAllTiers", translate("Announce To All Tiers"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Flag, "Enabled", translate("Enable Log"))
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Value, "Path", translate("Log file Path"), translate("By default, log files are stored in the configuration file directory."))
o:depends("Enabled", "true")

o = s:taboption("advanced", Flag, "Backup", translate("Enable log Backup"), translate("Backup log file when oversize the given size."))
o:depends("Enabled", "true")
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Value, "MaxSizeBytes", translate("Log Max Size(Bytes)"))
o:depends("Backup", "true")
o.placeholder = "65536"

o = s:taboption("advanced", Flag, "DeleteOld", translate("Delete old Backup"), translate("Automatically delete old log backups after a specified period."))
o:depends("Enabled", "true")
o.enabled = "true"
o.disabled = "false"
o.default = "true"

o = s:taboption("advanced", Value, "SaveTime", translate("Log Saving Period"), translate("The log file will be deteted after given time. Parameter:1d=1 day, 1m=1 month, 1y=1 year"))
o:depends("DeleteOld", "true")
o.datatype = "string"

return m

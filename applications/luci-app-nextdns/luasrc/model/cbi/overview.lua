local uci = require("luci.model.uci").cursor()

m = Map("nextdns", translate("NextDNS"),
	translate("NextDNS Configuration.")
	.. "<br>"
	.. translatef("For further information, go to "
	..            "<a href=\"https://nextdns.io\" target=\"_blank\">nextdns.io</a>"))


s = m:section(TypedSection, "nextdns", translate("General"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enabled"),
	translate("Enable NextDNS."))
o.rmempty = false

s:option(Value, "config", translate("Configuration ID"),
	translate("The ID of your NextDNS configuration.")
	.. "<br>"
	.. translate("Go to nextdns.io to create a configuration."))

o = s:option(Flag, "report_client_info", translate("Report Client Info"),
	translate("Expose LAN clients information in NextDNS analytics."))
o.rmempty = false

o = s:option(Flag, "hardened_privacy", translate("Hardened Privacy"),
	translate("When enabled, use DNS servers located in jurisdictions with strong privacy laws.")
	.. "<br>"
	.. translate("Available locations are: Switzerland, Iceland, Finland, Panama and Hong Kong."))
o.rmempty = false

o = s:option(Flag, "log_query", translate("Log Queries"),
	translate("Log individual queries to system log."))
o.rmempty = false

return m

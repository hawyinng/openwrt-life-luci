local a, t, e
a = Map("weburl", translate("网址过滤"), translate(
            "通过防火墙识别网址关键词，按设定规则阻止局域网设备访问相关网站。"))
a.template = "weburl/index"
t = a:section(TypedSection, "basic", translate("运行状态"))
t.anonymous = true
e = t:option(DummyValue, "weburl_status", translate("当前状态"))
e.template = "weburl/weburl"
e.value = translate("Collecting data...")
t = a:section(TypedSection, "basic", translate("基本设置"), translate(
                  "一般使用普通过滤即可，强效过滤会使用更复杂的算法导致更高的CPU占用。"))
t.anonymous = true
e = t:option(Flag, "enable", translate("普通过滤"))
e.rmempty = false
e = t:option(Flag, "algos", translate("强效过滤"))
e.rmempty = false
t = a:section(TypedSection, "macbind", translate("关键词设置"), translate(
                  "不设置黑名单MAC则表示全局过滤，如设置则只过滤指定的客户端，过滤时间可不设置。"))
t.template = "cbi/tblsection"
t.anonymous = true
t.addremove = true
e = t:option(Flag, "enable", translate("启用"))
e.rmempty = false
e = t:option(Value, "macaddr", translate("黑名单MAC"))
e.rmempty = true
luci.sys.net.mac_hints(function(t, a) e:value(t, "%s (%s)" % {t, a}) end)
e = t:option(Value, "timeon", translate("开始过滤时间"))
e.placeholder = "00:00"
e.rmempty = true
e = t:option(Value, "timeoff", translate("取消过滤时间"))
e.placeholder = "23:59"
e.rmempty = true
e = t:option(Value, "keyword", translate("网址关键词"))
e.rmempty = false

local apply = luci.http.formvalue("cbi.apply")
if apply then
	luci.util.exec("/etc/init.d/weburl restart >/dev/null 2>&1")
end

return a


module("luci.controller.unblockmusic", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/unblockmusic") then
		return
	end

	entry({"admin", "services", "unblockmusic"},firstchild(), _("解锁网易云灰色歌曲")).dependent = true
	entry({"admin", "services", "unblockmusic", "general"},cbi("unblockmusic"), _("基本设置"), 1)
	entry({"admin", "services", "unblockmusic", "log"},form("unblockmusiclog"), _("日志"), 2)
	entry({"admin", "services", "unblockmusic", "status"},call("act_status")).leaf=true
end

function act_status()
  local e={}
  e.running=luci.sys.call("busybox ps -w | grep UnblockNeteaseMusic/app.js | grep -v grep >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end

local fs = require 'nixio.fs'
local conffile = '/etc/adblock/white.list'

f = SimpleForm('custom')
t = f:field(TextValue, 'conf')
t.rmempty = true
t.rows = 13
t.description = translate('Will Never filter these Domain')
function t.cfgvalue()
    return fs.readfile(conffile) or ''
end

function f.handle(self, state, data)
    if state == FORM_VALID then
        if data.conf then
            fs.writefile(conffile, data.conf:gsub('\r\n', '\n'))
        else
            luci.sys.call('> /etc/adblock/white.list')
        end
        luci.sys.exec('/usr/share/adblock/adwhile >>/tmp/adupdate.log &')
    end
    return true
end

return f

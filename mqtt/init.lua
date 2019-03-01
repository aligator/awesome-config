local wibox = require("wibox")
local awful = require("awful")

local mqtt_widget = {}

--- Create a new mqtt widget.
function mqtt_widget.new(screen, host, port, topic, clientId, user, password, cafile, font, formatFn)
    local ret = wibox.widget.textbox()
    
    if font then
        ret.font = font
    end    
    
    local cmd = "mosquitto_sub -c -R -C 1 "
    
    if cafile then
        cmd = cmd.."--cafile "..cafile
    end
    
    cmd = cmd.." -h "..host.." -p "
    
    if port then
        cmd = cmd..tostring(port)
    else
        cmd = cmd.."1883"
    end
    
    cmd = cmd.." -t "..topic.." -i "
    
    if clientId then
        cmd = cmd..clientId
    else
        cmd = cmd.."aweasomewm"
    end
    
    cmd = cmd..tostring(screen.index)
    
    if user then
        cmd = cmd.." -u "..user
    end
    
    if password then
        cmd = cmd.." -P "..password
    end
    
    awful.widget.watch(cmd, 1,
        function(widget, stdout, stderr, exitreason, exitcode)
            
            if formatFn then
                widget.text = formatFn(stdout)
            else
                widget.text = obj.sender .. ": " .. obj.message
            end
            
        end,
        ret	
    )	

    return ret
end

return mqtt_widget

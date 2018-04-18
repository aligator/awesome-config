local wibox = require("wibox")
local awful = require("awful")

local ltc = wibox.widget.textbox()
local eth = wibox.widget.textbox()
local btc = wibox.widget.textbox()
local spacer = wibox.widget.textbox("<span font='12'>   |   </span>")

local coins_widget = wibox.widget {
	btc, spacer,
	ltc, spacer,
	eth,
	layout = wibox.layout.fixed.horizontal
}
 
function watchBitstamp(currency, name, widget)
	awful.widget.watch("curl -m5 -s 'https://www.bitstamp.net/api/v2/ticker/" .. currency .. "/'", 60,
   		function(widget, stdout, stderr, exitreason, exitcode)

			local data, pos, err = require("dkjson").decode(stdout, 1, nil)
			local price = (not err and data and data["last"]) or "N/A"
		
			widget:set_markup_silently("<span font='12'>" .. name .. ": " .. price .. "</span>")
		end,
		widget	
	)	
end

watchBitstamp("etheur", "ETH", eth)
watchBitstamp("ltceur", "LTC", ltc)
watchBitstamp("btceur", "BTC", btc)


return coins_widget

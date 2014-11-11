-- Standard awesome library
awful=require("awful")
require("awful.autofocus")
awful.rules=require("awful.rules")
-- Theme handling library
vicious=require("vicious")
beautiful=require("beautiful")
-- Notification library
require("naughty")
require("revelation")
cal=require("cal")
wibox=require("wibox")
-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/christian/.config/awesome/themes/nice-and-clean-theme/theme.lua")

local icon_path = awful.util.getdir("config").."/themes/nice-and-clean-theme/icons/"

-- load the 'run or raise' function
require("aweror")

-- generate and add the 'run or raise' key bindings to the globalkeys table
globalkeys = awful.util.table.join(globalkeys, aweror.genkeys(modkey))

root.keys(globalkeys)

-- Set all the icons needed
cpuicon = wibox.widget.textbox()
cpuicon.bg_align = "middle"
cpuicon.width = 8
tempicon = wibox.widget.textbox()
tempicon.bg_align = "middle"
tempicon.width = 8
memicon = wibox.widget.textbox()
memicon.bg_align = "middle"
memicon.width = 8
spkricon = wibox.widget.textbox()
spkricon.bg_align = "middle"
spkricon.width = 8
headicon = wibox.widget.textbox()
headicon.bg_align = "middle"
headicon.width = 8
netdownicon = wibox.widget.textbox()
netdownicon.bg_align = "middle"
netdownicon.width = 8
netupicon = wibox.widget.textbox()
netupicon.bg_align = "middle"
netupicon.width = 8
mailicon = wibox.widget.textbox()
mailicon.bg_align = "middle"
mailicon.width = 8
pacicon = wibox.widget.textbox()
pacicon.bg_align = "middle"
pacicon.width = 8
batticon = wibox.widget.textbox()
batticon.bg_align = "middle"
batticon.width = 8
clockicon = wibox.widget.textbox()
clockicon.bg_align = "middle"
clockicon.width = 8

seperator = wibox.widget.textbox()
seperator.text = " | "
spacer = wibox.widget.textbox()
spacer.width = 6


-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
tagname = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
for s = 1, screen.count() do
    
    tags[s] = awful.tag(tagname, s, layouts[1])
    -- Each screen has its own tag table.
    -- tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

bottombar = {}
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
cal.register(mytextclock)

-- User scriptes
-- Create some widgets...
cpuinfo =  wibox.widget.textbox()
cputemp =   wibox.widget.textbox()
meminfo =  wibox.widget.textbox()
spkrinfo =  wibox.widget.textbox()
headinfo =  wibox.widget.textbox()
netdowninfo =  wibox.widget.textbox()
netupinfo =  wibox.widget.textbox()
netdowninfo2 =  wibox.widget.textbox()
netupinfo2 =  wibox.widget.textbox()
battinfo =  wibox.widget.textbox()
-- ... And register them
--vicious.register(cpuinfo, vicious.widgets.cpu, "$1% / $2% / $3% / $4% / $5% / $6% / $7% / $8% ")
vicious.register(cpuinfo, vicious.widgets.cpu, function (widget, args)
      return string.format("%2.2d %2.2d %2.2d %2.2d %2.2d %2.2d %2.2d %2.2d ", args[1],  args[2] , args[3], args[4], args[5], args[6], args[7], args[8])
          end)
vicious.register(cputemp, vicious.widgets.thermal, "$1 C", 19, "thermal_zone0")
vicious.cache(vicious.widgets.mem)
vicious.register(meminfo, vicious.widgets.mem, "$1% ($2Mb)", 5)
vicious.cache(vicious.widgets.volume)
vicious.register(spkrinfo, vicious.widgets.volume, "$1", 11, "Master")
vicious.register(headinfo, vicious.widgets.volume, "$1", 11, "Mic")
vicious.cache(vicious.widgets.net)
vicious.register(netdowninfo, vicious.widgets.net, "${wlan0 down_kb}", 3)
vicious.register(netupinfo, vicious.widgets.net, "${wlan0 up_kb}", 3)
vicious.register(netdowninfo2, vicious.widgets.net, "${eth0 down_kb}", 3)
vicious.register(netupinfo2, vicious.widgets.net, "${eth0 up_kb}", 3)
vicious.register(battinfo, vicious.widgets.bat,
  function (widget, args)
    if args[2] < 25 then
      batticon.bg_image = image(beautiful.widget_batt_empty)
      return args[2]
    elseif args[2] < 50 then
      batticon.bg_image = image(beautiful.widget_batt_low)
      return args[2]
    else
      batticon.bg_image = image(beautiful.widget_batt_full)
      return args[2]
    end
  end, 59, "BAT0")

-- LED widget
myledbox =  wibox.widget.textbox()
function run_script()
    local filedescripter = io.popen('/home/christian/.config/awesome/leds.sh')
    local value = filedescripter:read()
    myledbox.bg = "#FFFFFF"
    filedescripter:close()
    if value == nil then
        return value
    else 
        return "<span color='#111111'><b> " .. value .. " </b></span>"
    end
end
vicious.register(myledbox, run_script, "$1", 1)




--}}}


-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
     mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    -- Create a tasklist widget
     mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- Create a Temp

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
       -- Widgets that are aligned to the left
       local left_layout = wibox.layout.fixed.horizontal()
       left_layout:add(mylauncher)
       left_layout:add(mytaglist[s])
       left_layout:add(mypromptbox[s])
       -- Widgets that are aligned to the right
       local right_layout = wibox.layout.fixed.horizontal()
       if s == 1 then right_layout:add(wibox.widget.systray()) end
       right_layout:add(mytextclock)
       right_layout:add(mylayoutbox[s])
       -- Now bring it all together (with the tasklist in the middle)
       local layout = wibox.layout.align.horizontal()
       layout:set_left(left_layout)
       layout:set_middle(mytasklist[s])
       layout:set_right(right_layout)
       mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey, "Control" }, "Prior", awful.tag.viewprev     ),
    awful.key({ modkey, "Control" }, "Next", awful.tag.viewnext   ),
    awful.key({ modkey, }, "e",  revelation.revelation),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
          awful.client.focus.byidx( 1)
          if client.focus then client.focus:raise() end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Control" }, "space", function () awful.layout.inc(layouts, 1) end),

    -- Special Keys 
    awful.key({ modkey,           }, "l", function () awful.util.spawn("/home/christian/local/bin/slimlock") end),
    awful.key({                   }, "XF86AudioRaiseVolume", function () pulse_volume(5)  end),
    awful.key({                   }, "XF86AudioLowerVolume", function () pulse_volume(-5) end),
    awful.key({                   }, "XF86AudioMute", function () pulse_toggle() end),
    --awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
    --awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("mpc stop") end),
    --awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    --awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.PlayPause") end),
    awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.Quit") end),
    awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.Previous") end),
    awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.Next") end),
    
    awful.key({ modkey,           }, "p",     function () awful.util.spawn("lxrandr")    end), 
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

   -- {rule = { class = "Pidgin" },
   --   properties = { tag = tags[1][1] } },
    --{rule = { class = "Spotify"},
   --  properties = { tag = tags[1][9] } },

awful.rules.rules = {
        -- All clients will match this rule.
         { rule = { },
             properties = { border_width = beautiful.border_width,
             border_color = beautiful.border_normal,
             focus = awful.client.focus.filter,
             raise = true,
             keys = clientkeys,
             buttons = clientbuttons } },
}
   

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}



awful.util.spawn_with_shell("/home/christian/.config/awesome/startup")





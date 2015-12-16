

    local _, class = UnitClass'Player'
    local colour = RAID_CLASS_COLORS[class]
    local addon = {}
    local money, lastmoney, xp, startxp, lastxp, gotxp, sessionxp = 0

    local function getLatency()
        local _, _, home = GetNetStats()
        return  '|c00ffffff'..home..'|r ms'
    end

    local function getFPS()
        return '|c00ffffff'..floor(GetFramerate())..'|r fps'
    end

    local getFormattedMoney = function()
        local g = floor(money/(100*100))
        local s = floor((money - (g*100*100))/100)
        local c = mod(money, 100)
        return format('%d\|cfff3ac00g|r %d\|cffc6c6c6s|r %d\|cff954e2fc|r', g, s, c)
    end

    local getSession = function()
        local sessiontime = GetTime() - startxp
        local perhour     = sessionxp/sessiontime*3600
        local hourlyxp    = '|c00ffffff'..math.floor(perhour)..'|r xp'
        local time        = sessiontime > 0 and sessiontime or 0
        return hourlyxp, time
    end

    local stats = function()
        local hourlyxp, time = getSession()

        GameTooltip:SetOwner(this, 'ANCHOR_NONE')

            -- HEADER
        GameTooltip:AddDoubleLine('modui stats', '—', colour.r, colour.g, colour.b)
        GameTooltip:AddLine' '

            -- LATENCY
        GameTooltip:AddDoubleLine('Ping', getLatency(), colour.r, colour.g, colour.b)
        if SHOW_NEWBIE_TIPS then
             GameTooltip:AddLine' '
             GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, 1, .8, 0, 1)
        end

            -- FPS
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Framerate', getFPS(), colour.r, colour.g, colour.b)

            -- SESSION GOLD
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Money earned this session', getFormattedMoney(), colour.r, colour.g, colour.b, 1, .8, 0)

            -- SESSION PLAYED
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Time played this session', SecondsToTimeAbbrev(math.floor(time)), colour.r, colour.g, colour.b)

            -- HOURLY XP
        GameTooltip:AddDoubleLine('EXP earned this session', '|cffffffff'..sessionxp..'|r xp', colour.r, colour.g, colour.b, 1, .8, 0)
        GameTooltip:AddDoubleLine('EXP rate per hour', hourlyxp, colour.r, colour.g, colour.b, 1, .8, 0)

            -- ADDONS
        GameTooltip:AddLine' '
        GameTooltip:AddLine('AddOns Loaded', colour.r, colour.g, colour.b)
        for k, v in pairs(addon) do
            if k < 20 then GameTooltip:AddDoubleLine(' ', v, 1, 1, 1) end
        end

        GameTooltip:Show()
    end

    MainMenuBarPerformanceBarFrameButton:SetScript('OnEnter', function()
        GameTooltip:ClearLines()
        stats()
    end)

    local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
    f:RegisterEvent'ADDON_LOADED'
	f:RegisterEvent'PLAYER_MONEY'
    f:RegisterEvent'PLAYER_XP_UPDATE' f:RegisterEvent'PLAYER_LEVEL_UP'
    f:SetScript('OnEvent', function()
        if event == 'PLAYER_ENTERING_WORLD' then
            lastmoney = GetMoney()
            lastxp    = UnitXP'player'
            startxp   = GetTime()
            money     = 0
            sessionxp = 0
            gotxp     = 0
        elseif event == 'ADDON_LOADED' then
            if not string.find(arg1, 'Blizzard_(.+)') then table.insert(addon, arg1) end
        elseif event == 'PLAYER_MONEY' then
    		local m = GetMoney()
    		if m > lastmoney then
    			local increase = (m - lastmoney)
    			money = money + increase
                lastmoney = m
            end
        elseif event == 'PLAYER_XP_UPDATE' then
            sessionxp = UnitXP'player' - lastxp + gotxp
        elseif event == 'PLAYER_LEVEL_UP' then
            gotxp = gotxp + UnitXPMax'player' - lastxp
            lastxp = 0
        end
    end)

    --

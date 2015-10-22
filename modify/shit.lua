

    local bu = CreateFrame('Button', 'modShit', MerchantFrame)
    bu:SetPoint('TOPLEFT', MerchantFrame, 180, -42)
    bu:SetWidth(24) bu:SetHeight(24)
    bu:SetPushedTexture[[Interface\Buttons\UI-Quickslot-Depress]]

    local t = bu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    t:SetPoint('RIGHT', bu, 'LEFT', -4, 0)
    t:SetText'Sell All Greys'

    local ic = bu:CreateTexture(nil, 'ARTWORK')
    ic:SetTexture[[Interface\ICONS\Inv_feather_12]]
    ic:SetAllPoints()

    bu:SetScript('OnClick', function()
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                local _, _, info = link and GetItemInfo(link)
                if link and info == 0 then
                    ShowMerchantSellCursor(1)
                    UseContainerItem(bag, slot)
                end
            end
        end
    end)

    bu:SetScript('OnEnter', function()
        GameTooltip:SetOwner(bu, 'ANCHOR_RIGHT')
        GameTooltip:SetText'Sell all grey items held in inventory.'
        GameTooltip:Show()
    end)

    bu:SetScript('OnLeave', function() GameTooltip:Hide() end)

    --

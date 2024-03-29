local eventFrame = CreateFrame("Frame", "MT_Castbar", UIParent);

local options = {
    size = 220,
};

local function SkinFrame(frame)
    frame:SetFrameStrata("TOOLTIP", nil, 6);

    local statusbar, text, border;

    if (_G[frame:GetName().."StatusBar"]) then
        statusbar = _G[frame:GetName().."StatusBar"];
        text = _G[frame:GetName().."Text"];
        border = _G[frame:GetName().."Border"];
    else
        statusbar = frame;
        text = frame.Text;
        border = frame.Border;
    end

    local barHeight = 16;
    local frameOffset = 4;
    local frameHeight = barHeight + (frameOffset * 2);

    statusbar:SetSize(options.size, barHeight);
    text:SetSize(statusbar:GetSize());
    text:SetPoint("TOP", statusbar, "TOP", 0, 0);
    border:Hide();

    local tex = "Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorderHighlight";

    local LeftBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    LeftBorder:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -frameOffset, frameOffset);
    LeftBorder:SetSize(frameHeight / 2, frameHeight);
    LeftBorder:SetTexture(tex);
    LeftBorder:SetTexCoord(0.007843, 0.043137, 0.193548, 0.774193);
    LeftBorder:SetDesaturated(1);

    local RightBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    RightBorder:SetPoint("TOPRIGHT", statusbar, "TOPRIGHT", frameOffset, frameOffset);
    RightBorder:SetSize(frameHeight / 2, frameHeight);
    RightBorder:SetTexture(tex);
    RightBorder:SetTexCoord(0.043137, 0.007843, 0.193548, 0.774193);
    RightBorder:SetDesaturated(1);

    local MidBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    MidBorder:SetPoint("TOPLEFT", LeftBorder, "TOPRIGHT");
    MidBorder:SetPoint("BOTTOMRIGHT", RightBorder, "BOTTOMLEFT");
    MidBorder:SetTexture(tex);
    MidBorder:SetTexCoord(0.113726, 0.1490196, 0.193548, 0.774193);
    MidBorder:SetDesaturated(1);
end

eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MT_UI') then
        SkinFrame(CastingBarFrame);
        CastingBarFrame.Flash:SetTexture(nil); -- hide the flashing frame at the end of the cast
        CastingBarFrame.Spark:SetTexCoord(0, 1, 0, 0.85);

        hooksecurefunc("MirrorTimer_Show", function()
            for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
                local frame = _G["MirrorTimer"..i];
                if (not frame.isSkinned) then
                    SkinFrame(frame);

                    local region = frame:GetRegions();

                    if (region:GetObjectType() == "Texture") then
                        region:SetSize(_G[frame:GetName().."StatusBar"]:GetSize());
                    end

                    frame.isSkinned = true;
                end
            end
        end);
    end;
end);

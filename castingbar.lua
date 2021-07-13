
local function SkinFrame(frame)
    frame:SetFrameStrata("TOOLTIP", nil, 6);

    local statusbar, text, border, flash;

    if (_G[frame:GetName().."StatusBar"]) then
        statusbar = _G[frame:GetName().."StatusBar"];
        text = _G[frame:GetName().."Text"];
        border = _G[frame:GetName().."Border"];
    else
        statusbar = frame;
        text = frame.Text;
        border = frame.Border;
    end

    statusbar:SetSize(250, 15);
    text:SetSize(statusbar:GetSize());
    text:SetScale(0.9);
    text:SetPoint("TOP", statusbar, "TOP", 0, -1);
    border:Hide();

    local LeftBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    LeftBorder:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -3, 3);
    LeftBorder:SetSize(9, 22);
    LeftBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder");
    LeftBorder:SetTexCoord(0.007843, 0.043137, 0.193548, 0.774193);

    local RightBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    RightBorder:SetPoint("TOPRIGHT", statusbar, "TOPRIGHT", 3, 3);
    RightBorder:SetSize(9, 22);
    RightBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder");
    RightBorder:SetTexCoord(0.043137, 0.007843, 0.193548, 0.774193);

    local MidBorder = statusbar:CreateTexture(nil, "TOOLTIP", nil, 7);
    MidBorder:SetPoint("TOPLEFT", LeftBorder, "TOPRIGHT");
    MidBorder:SetPoint("BOTTOMRIGHT", RightBorder, "BOTTOMLEFT");
    MidBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder");
    MidBorder:SetTexCoord(0.113726, 0.1490196, 0.193548, 0.774193);
end

function MTUI:InitCastingbar()
    SkinFrame(CastingBarFrame);
    CastingBarFrame.Flash:SetTexture(nil);

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
end

local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

function MTUI:InitCastingbar()
    CastingBarFrame:SetSize(220, 15)
    CastingBarFrame.Text:SetScale(0.95)
    CastingBarFrame.Text:SetPoint("TOP")
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame:SetFrameStrata("TOOLTIP")

    local LeftBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    LeftBorder:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
    LeftBorder:SetSize(9, 22)
    LeftBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    LeftBorder:SetTexCoord(0.007843, 0.043137, 0.193548, 0.774193)

    local RightBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    RightBorder:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", 3, 3)
    RightBorder:SetSize(9, 22)
    RightBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    RightBorder:SetTexCoord(0.043137, 0.007843, 0.193548, 0.774193)

    local MidBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    MidBorder:SetPoint("TOPLEFT", LeftBorder, "TOPRIGHT")
    MidBorder:SetPoint("BOTTOMRIGHT", RightBorder, "BOTTOMLEFT")
    MidBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    MidBorder:SetTexCoord(0.113726, 0.1490196, 0.193548, 0.774193)
end

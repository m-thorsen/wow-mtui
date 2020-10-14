local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

function MTUI:InitCastingbar()
    CastingBarFrame:SetSize(200, 16)
    CastingBarFrame.Text:SetScale(0.95)
    CastingBarFrame.Text:SetPoint("TOP")
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame:SetFrameStrata("TOOLTIP")

    local LeftBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    LeftBorder:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -6, 4)
    LeftBorder:SetSize(106, 24)
    LeftBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    LeftBorder:SetTexCoord(0, 0.4, 0.2, 0.8)

    local RightBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    RightBorder:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", 6, 4)
    RightBorder:SetSize(106, 24)
    RightBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    RightBorder:SetTexCoord(0.4, 0, 0.2, 0.8)
end

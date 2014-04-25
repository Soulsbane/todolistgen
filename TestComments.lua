local AddonName, Addon = ...

local Options = {}
local OptionsFrame

function Options:AddButton(name, width, height)
	local button = CreateFrame("Button", OptionsFrame:GetName() .. name, OptionsFrame, "UIPanelButtonTemplate")
	local width = string.len(name) * 8 or width --NOTE: Fairly naive assumption here
	local height = height or 25

	button:SetText(name)
	button:SetWidth(width)
	button:SetHeight(height)

	button:HookScript("OnClick", function(self)
		DispatchMethod("On" .. name .. "Clicked")
	end)

	return button
end

---------------------------------------
-- Attach Methods
---------------------------------------
--NOTE: Checkbutton's seem to only align with the checkbox not the checkbox plus text. ClearAllPoints may not even be needed. Needs further investigation.

function Options:AttachRight(frame, attachedTo, offset)
	local offset = offset or -30

	--frame:ClearAllPoints()
	frame:SetPoint("CENTER", attachedTo, "RIGHT", offset, 0)
end

function Options:AttachLeft(frame, attachedTo, offset)
	local offset = offset or 30

	--frame:ClearAllPoints()
	frame:SetPoint("CENTER", attachedTo, "LEFT", offset, 0)
end

function Options:AttachAbove(frame, attachedTo, offset)
	local offset = offset or 60

--	frame:ClearAllPoints()
	frame:SetPoint("CENTER", attachedTo, "TOP", 0, offset)
end

function Options:AttachBelow(frame, attachedTo, offset)
	local offset = offset or -60

	--frame:ClearAllPoints()
	frame:SetPoint("CENTER", attachedTo, "BOTTOM", 0, offset)
end

-- INFO: Panel is automatically created when including SimpleOptions.lua in your TOC.
do
	local name, desc = select(2, GetAddOnInfo(AddonName))
	local icon = "Interface\\Addons\\" .. AddonName .. "\\" .. AddonName

	Addon.OptionsFrame = Options:CreatePanel(AddonName, name) --, icon)
	Addon.Options = Options
end

--FIXME: This entire project

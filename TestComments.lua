' INFO: This is a quote test
; INFO: This is a semicolon test
---------------------------------------
-- Attach Methods
---------------------------------------
--NOTE: Checkbutton's seem to only align with the checkbox not the checkbox plus text. ClearAllPoints may not even be needed. Needs further investigation.
--NOTE A comment without a colon.
function Options:AttachRight(frame, attachedTo, offset)
	local offset = offset or -30

	--frame:ClearAllPoints()
	frame:SetPoint("CENTER", attachedTo, "RIGHT", offset, 0)
end
-- INFO: Panel is automatically created when including SimpleOptions.lua in your TOC.
do
	local name, desc = select(2, GetAddOnInfo(AddonName))
	local icon = "Interface\\Addons\\" .. AddonName .. "\\" .. AddonName

	Addon.OptionsFrame = Options:CreatePanel(AddonName, name) --, icon)
	Addon.Options = Options
end

--FIXME: This entire project

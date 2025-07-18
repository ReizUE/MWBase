ATTACHMENT.Base = "att_optic"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    weapon.Zoom.ViewModelFovMultiplier = weapon.Zoom.ViewModelFovMultiplier * 1.55
    weapon.Zoom.FovMultiplier = 0.1
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)

    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 0.15
    if weapon.Recoil.Punch then
        weapon.Recoil.Punch = weapon.Recoil.Punch * 0.35
    end
    if weapon.Recoil.AdsShakeMultiplier then
        weapon.Recoil.AdsShakeMultiplier = weapon.Recoil.AdsShakeMultiplier * 0.25
    end
end
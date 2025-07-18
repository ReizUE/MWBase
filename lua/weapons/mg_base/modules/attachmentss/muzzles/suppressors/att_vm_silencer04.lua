ATTACHMENT.Base = "att_suppressor"
ATTACHMENT.Name = "Tactical Suppressor"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_silencer04.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/muzzle/icon_attachment_silencer04.vmt")
ATTACHMENT.BonemergeToCategory = {"Barrels"}
ATTACHMENT.AttachmentBodygroups = {
    ["tag_tip"] = 1,
    ["muzzle"] = 1,
    ["tip"] = 1
}
ATTACHMENT.Bodygroups = {
    ["tag_tip"] = 1,
    ["muzzle"] = 1,
    ["tip"] = 1
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.98
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.98
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.97
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.97
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.05
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.05
    weapon:doSuppressorStats()
end 
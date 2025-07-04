AddCSLuaFile()

local task = {}
task.Name = "Trigger"
task.Priority = 1
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    return weapon.Trigger
    && !weapon:HasFlag("HoldingTrigger")
    && CurTime() > weapon:GetNextPrimaryFire()
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "HoldingTrigger")
    weapon:CustomNetworkVar("Float", "TriggerDelta")
end

function task:OnSet(weapon)
    weapon:AddFlag("HoldingTrigger")

    if weapon.Trigger.PressedSound then
        weapon:EmitSound(weapon.Trigger.PressedSound)
    end

    if weapon.Trigger.PressedAnimation then
        weapon:PlayViewModelAnimation(weapon.Trigger.PressedAnimation)
    elseif weapon:Clip1() <= 0 then
        weapon:PlayViewModelAnimation("Land")
    end
end

function task:Think(weapon)
    if !weapon:HasFlag("HoldingTrigger") then
        return true
    end
    
    weapon:SetTriggerDelta(math.min(weapon:GetTriggerDelta() + (FrameTime() / weapon.Trigger.Time), 1))

    if weapon:GetTriggerDelta() >= 1 && (!weapon.Trigger.ClickType || weapon.Trigger.ClickType < 2) then
        weapon:TrySetTask("PrimaryFire")
        return true
    end

    return false
end

SWEP:RegisterTask(task) 
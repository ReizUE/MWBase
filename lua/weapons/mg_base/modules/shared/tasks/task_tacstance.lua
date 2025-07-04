AddCSLuaFile()

local task = {}
task.Name = "TacStance"
task.Priority = 2
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
	return weapon:HasFlag("Aiming")
        && weapon:CanTacStance()
		&& GetConVar("mgbase_sv_tacstance"):GetBool()
        && !weapon:GetHybrid()
        && !weapon:HasFlag("UsingUnderbarrel")
end

function task:OnSet(weapon)
    weapon:SetTacStance(weapon:GetTacStance() == 1 && 0 || 1)
    weapon:SetNextSecondaryFire(CurTime())
    
    if weapon:GetTacStance() == 0 then
        weapon:EmitSound("Canted.Off")
        weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Ads_Out"))
    else
        weapon:EmitSound("Canted.On")
        weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Ads_Out"))
    end
end

function task:Think(weapon)
    local delta = (CurTime() - weapon:GetNextSecondaryFire()) / (weapon:GetNextPrimaryFire() - weapon:GetNextSecondaryFire())

    if (weapon:GetTacStance() == 1) then
        weapon:SetTacStanceDelta(delta)
    else
        weapon:SetTacStanceDelta(1 - delta)
    end

    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:OnInterrupted(weapon)
    weapon:SetTacStanceDelta(weapon:GetTacStance())
end

SWEP:RegisterTask(task)
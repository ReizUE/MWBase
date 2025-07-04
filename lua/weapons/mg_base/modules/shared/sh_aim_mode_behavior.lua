AddCSLuaFile()

function SWEP:CanChangeAimMode()
    return true
end

function SWEP:GetHybrid()
    if !self:GetSight() then
        return nil
    end

    return self:GetSight().ReticleHybrid
end

function SWEP:CanTacStance()
    return self.Cone.TacStance
end
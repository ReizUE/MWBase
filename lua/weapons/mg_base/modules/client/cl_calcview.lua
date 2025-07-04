AddCSLuaFile()

require("mw_utils")
require("mw_math")

function SWEP:CalcView(ply, pos, ang, fov)
    --do vm first
    local vm = self:GetViewModel()
    
    if (IsValid(vm) && GetConVar("mgbase_debug_vmrender"):GetInt() >= 1) then
        local vpos, vang = Vector(pos), Angle(ang)

        if (GetConVar("mgbase_debug_freeview"):GetInt() <= 0) then
            vm:CalcViewModelView(vpos, vang)
            vm:SetRenderOrigin(vpos)
            vm:SetRenderAngles(vang)
        end

        vm:CalcView(pos, ang)
        vm:SetNoDraw(false)
    end

    ang.p = math.Clamp(ang.p, -89, 89)
    
    local rpm = math.Clamp(self.Primary.RPM / 10, 55, 90)
    local rate = 60 / (rpm * 10)
    rate = 20 - (rate * 100)
    self.Camera.Shake = mw_math.SafeLerp(rate * FrameTime(), self.Camera.Shake, 0)
   
    local pitch = (math.cos(CurTime() * rpm) * (self.Camera.Shake * 0.5)) * mw_math.SafeLerp(self:GetAimDelta(), 1, 0.4)

    local recoilAndShakeAngles = Angle(pitch, 0, math.sin(CurTime() * rpm))
	recoilAndShakeAngles:Mul(self.Camera.Shake * (Lerp(self:GetAimDelta(), 1, self.Recoil.AdsShakeMultiplier || 1)))

    ang:Add(recoilAndShakeAngles)

    local vpAngles = self:GetOwner():GetViewPunchAngles()
	vpAngles:Mul(mw_math.SafeLerp(self:GetAimDelta(), (self.Recoil.Crosshair || 0.3), 0))
    ang:Sub(vpAngles)

    --breathing
    self.Camera.LerpBreathing = self.Camera.LerpBreathing || Angle()
    mw_math.SafeLerpAngle(10 * FrameTime(), self.Camera.LerpBreathing, self:GetBreathingSwayAngle())
    ang:Add(self.Camera.LerpBreathing)
        
    --end breathing

    mw_math.VectorAddAndMul(pos, ang:Forward(), -self.Camera.Shake)
    
    if (self.Cone.DecreaseEveryShot != nil && self.Cone.MinDecreaseEveryShot != nil) then
        local mul = self:GetConeDecreaseEveryShotMultiplier()
        local delta = 1 - mul
        self.Camera.SprayEffect = mw_math.SafeLerp(10 * FrameTime(), self.Camera.SprayEffect, delta * 10)
    end

    self.Camera.Fov = mw_math.SafeLerp(20 * FrameTime(), self.Camera.Fov, self:GetAimDelta())

    self.Camera.FovAimDelta = mw_math.SafeLerp(20 * FrameTime(), self.Camera.FovAimDelta || 0, self:GetAimModeDelta())

    local diff = 0

    if (self:HasFlag("Reloading")) then
        diff = self.Zoom.FovMultiplier * 0.05
    end

    if self:GetTacStance() == 1 then
        diff = (1 - self.Zoom.FovMultiplier) * 1
    end

    self.Camera.LerpReloadFov = mw_math.SafeLerp(10 * FrameTime(), self.Camera.LerpReloadFov, diff)
    
    local fovDeltaComp = 90 / fov
    local zoom = Lerp(self.Camera.FovAimDelta, self.Zoom.FovMultiplier, 0.9)
    local fovMultiplier = mw_math.SafeLerp(self.Camera.Fov * self.Camera.Fov * self.Camera.Fov, 1, (zoom + self.Camera.LerpReloadFov))

    fov = (fov * fovMultiplier) + (self.Camera.Shake * 1.5)
    fov = fov * Lerp(self.Camera.Fov, 1, fovDeltaComp)
    fov = fov - Lerp(self.Camera.Fov, self.Camera.SprayEffect, 0)

    --customization
    local bCustomizing = self:HasFlag("Customizing")

    self.Camera.LerpCustomization = mw_math.SafeLerp(5 * FrameTime(), self.Camera.LerpCustomization, mw_math.btn(bCustomizing))

    local lerp = self.Camera.LerpCustomization
    local forward = ang:Forward()
    forward:Mul(lerp * -3)

    pos:Add(forward)

    return pos, ang, fov
end

function SWEP:PostDrawViewModel(viewmodel, player, weapon) end --ignore me
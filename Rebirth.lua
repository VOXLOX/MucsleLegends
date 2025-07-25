local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local AutoRebirth = {}
AutoRebirth.__index = AutoRebirth

function AutoRebirth.new()
    local self = setmetatable({}, AutoRebirth)
    self.Running = false
    self.TargetRebirth = 1
    return self
end

function AutoRebirth:Start()
    if self.Running then
        return
    end
    self.Running = true
    task.spawn(function()
        while self.Running do
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            local rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths")
            if rebirths and rebirths.Value < self.TargetRebirth then
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.2)
            else
                break
            end
        end
        self.Running = false
    end)
end

function AutoRebirth:Stop()
    self.Running = false
end

function AutoRebirth:IsRunning()
    return self.Running
end

function AutoRebirth.AddUI(tab)
    local self = AutoRebirth.new()

    tab:AddLabel("Auto Rebirth Settings")
    
    tab:AddTextBox("Target Rebirths", "Enter target rebirths", function(value)
        local num = tonumber(value)
        if num and num > 0 then
            self.TargetRebirth = num
        else
            self.TargetRebirth = 1
        end
    end)
    
    tab:AddToggle("Enable Auto Rebirth", function(state)
        if state then
            self:Start()
        else
            self:Stop()
        end
    end)

    return self
end

return AutoRebirth

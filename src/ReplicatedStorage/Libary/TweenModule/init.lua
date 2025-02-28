local TweenService = game:GetService("TweenService")
local TweenModule = {}

TweenModule.TweenInfoTable = {
    ['TweenInfo1'] = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfo11'] = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfoSlot'] = TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    ['HiveWaspCreate'] = TweenInfo.new(0.45,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),
    ['FlowerDown'] = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['FlowerUp'] = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenCamera'] = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    ['TokenUpField'] = TweenInfo.new(1.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out),
    ['TweenRotation'] = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    ["DestroyToken"] = TweenInfo.new(0.75),
    ['TweenTouched'] = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    ['UseShop'] = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    ['AnimateButton'] = TweenInfo.new(0.35,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    ['TextureParts'] = TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    ['TweenPosWasp'] = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
    ['WaspFlyPos'] = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
}


function TweenModule.OpenButton(Frame : Frame)
    local TW1 = TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(10,0,5, 0)})
    TW1:Play()
    TW1.Completed:Wait()
end

function TweenModule.CloseButton(Frame : Frame)
    local TW1 = TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(0,0,0,0)})
    TW1:Play()
    TW1.Completed:Wait()
end

function TweenModule:KeyCode(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(8,0,4, 0)}):Play()
end

function TweenModule:ButtonTween(Frame : Frame, Debounce : boolean)
    if Debounce then
        TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo11'],{Position = UDim2.new(0.362, 0,0.03, 0)}):Play()
    else
        TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo11'],{Position = UDim2.new(0.362, 0,-1, 0)}):Play()
    end
end

function TweenModule:SlotEffectFood(Slot : BasePart)
    Slot.Down.Transparency = 0.15
    TweenService:Create(Slot.Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Color = Color3.fromRGB(61, 243, 92)}):Play()
end

function  TweenModule:SlotEffectFoodOff(Slot : BasePart, ColorSlot : Color3)
    TweenService:Create(Slot.Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Color = ColorSlot[2]}):Play()
end

function TweenModule:SpawnSlotHive(Hive : Folder, CheckSlot : number)
    local function SlotEffect()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.Neon
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
        TweenService:Create(Hive.Slots[CheckSlot].Down, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Hive.Slots[CheckSlot].Up, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.SmoothPlastic
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
    end

    TweenService:Create(Hive.Slots[CheckSlot].Up, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 0}):Play()
    SlotEffect()
    TweenService:Create(Hive.Slots[CheckSlot].Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 0.45}):Play()
    Hive.Slots[CheckSlot].Down.Level.SurfaceGui.Enabled = true
    Hive.Slots[CheckSlot].Down.SurfaceGui.Enabled = true
    --Hive.Slots[CheckSlot].Up.ParticleEmitter.Enabled = true
    --Hive.Slots[CheckSlot].Up.ParticleEmitter.Enabled = false
end

function TweenModule:DestroySlotHive(Hive : Folder, CheckSlot : number)
    local function SlotEffect()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.Neon
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
        TweenService:Create(Hive.Slots[CheckSlot].Down, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Hive.Slots[CheckSlot].Up, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.SmoothPlastic
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
    end

    TweenService:Create(Hive.Slots[CheckSlot].Up, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 1}):Play()
    SlotEffect()
    TweenService:Create(Hive.Slots[CheckSlot].Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 1}):Play()
    Hive.Slots[CheckSlot].Down.Level.SurfaceGui.Enabled = false
    Hive.Slots[CheckSlot].Down.SurfaceGui.Enabled = false
end
function TweenModule:FlowerDown(Flower,FlowerPos)
    TweenService:Create(Flower, TweenModule.TweenInfoTable['FlowerDown'], {Position = FlowerPos}):Play()
end

function TweenModule:RegenUp(Pollen : BasePart,ToMaxFlower : Vector3,InfoFieldGame : table,FlowerPos : Vector3,FlowerPosTime : Vector3)
    if ToMaxFlower < InfoFieldGame.RegenFlower then
        Pollen.ParticleEmitter.Enabled = false
        TweenService:Create(Pollen, TweenModule.TweenInfoTable['FlowerUp'], {Position = FlowerPos}):Play()
    else
        Pollen.ParticleEmitter.Enabled = false
        TweenService:Create(Pollen, TweenModule.TweenInfoTable['FlowerUp'], {Position = FlowerPosTime}):Play()
    end
end

function TweenModule:TexturePart(Part : BasePart, TransNumber : number)
    TweenService:Create(Part:FindFirstChild('TopTexture'), TweenModule.TweenInfoTable['TextureParts'], {Transparency = TransNumber}):Play()
end

function TweenModule:SizeUp(VP: Frame)
   TweenService:Create(VP.BillboardGui.TextPlayer, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()
end

function TweenModule:SizeDown(VP : Frame)
   TweenService:Create(VP.BillboardGui.TextPlayer, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
end

function TweenModule:UseGui(UI : Frame, Pos : UDim2)
    local Tw = TweenService:Create(UI,TweenModule.TweenInfoTable['TweenInfo1'],{Position = Pos})
    Tw:Play()
    Tw.Completed:Wait()
end
function TweenModule:UseCloseCamera(CameraStart : BasePart,CameraFinish : BasePart)
    local canMoveCamera = true
    if canMoveCamera then
        canMoveCamera = not canMoveCamera
        local TWCamera = TweenService:Create(CameraStart, TweenModule.TweenInfoTable['TweenCamera'], {
            CFrame = CameraFinish
        })
        TWCamera:Play()
        TWCamera.Completed:Wait()
        canMoveCamera = true
    end
end

function TweenModule:UseCamera(CameraStart : BasePart,CameraFinish : BasePart)
    local canMoveCamera = true
    if canMoveCamera then
        canMoveCamera = not canMoveCamera
        local TWCamera = TweenService:Create(CameraStart, TweenModule.TweenInfoTable['TweenCamera'], {
            CFrame = CameraFinish.CFrame
        })
        TWCamera:Play()
        TWCamera.Completed:Wait()
        canMoveCamera = true
    end
end

function TweenModule:DestroyToken(NewToken : BasePart)
    TweenService:Create(NewToken.CubeDown, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()
    TweenService:Create(NewToken.CubeUp, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()
    TweenService:Create(NewToken.CubeDown.Bottom.ImageLabel, TweenModule.TweenInfoTable["DestroyToken"], {ImageTransparency = 1}):Play()
    TweenService:Create(NewToken.CubeDown.Top.ImageLabel, TweenModule.TweenInfoTable["DestroyToken"], {ImageTransparency = 1}):Play()
end

function TweenModule:FieldUpToken(TokenNew : Model, TokenInfo : table)
    if TokenNew ~= nil and TokenNew:FindFirstChild('Inside') and TokenNew:FindFirstChild('Outside') or not TokenNew:GetAttribute('Touched') then
        local g = {Position = TokenNew.Inside.Position + Vector3.new(0, 3, 0)}
        local ff = {Position = TokenNew.Outside.Position + Vector3.new(0, 3, 0)}
        TweenService:Create(TokenNew.Inside, TweenModule.TweenInfoTable['TokenUpField'],g):Play()
        TweenService:Create(TokenNew.Outside, TweenModule.TweenInfoTable['TokenUpField'],ff):Play()
    end
end

function TweenModule:TouchedToken(NewToken : Model)

    TweenService:Create(NewToken.Inside, TweenModule.TweenInfoTable['TweenTouched'],{Orientation = Vector3.new(0,0,math.rad(1))}):Play()
    TweenService:Create(NewToken.Outside, TweenModule.TweenInfoTable['TweenTouched'],{Orientation = Vector3.new(0,0,math.rad(1))}):Play()

    TweenService:Create(NewToken.Inside, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()
    TweenService:Create(NewToken.Outside, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()
    TweenService:Create(NewToken.Inside.Decal1, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()
    TweenService:Create(NewToken.Inside.Decal2, TweenModule.TweenInfoTable["DestroyToken"], {Transparency = 1}):Play()

    TweenService:Create(NewToken.Inside, TweenModule.TweenInfoTable['TweenTouched'],{Position = NewToken.Outside.Position + Vector3.new(0,8,0)}):Play()
    TweenService:Create(NewToken.Outside, TweenModule.TweenInfoTable['TweenTouched'],{Position = NewToken.Outside.Position + Vector3.new(0,8,0)}):Play()
    

    task.delay(3,function()
        NewToken:Destroy()
    end)
end

function TweenModule:AnimationToken(TokenNew : Model)
    if TokenNew ~= nil and TokenNew:FindFirstChild('Inside') and TokenNew:FindFirstChild('Outside') then
        TweenService:Create(TokenNew.Inside, TweenModule.TweenInfoTable['TweenRotation'],{CFrame = TokenNew.Inside.CFrame * CFrame.Angles(0, 0, math.rad(3))}):Play()
        TweenService:Create(TokenNew.Outside, TweenModule.TweenInfoTable['TweenRotation'],{CFrame = TokenNew.Outside.CFrame * CFrame.Angles(0, 0, math.rad(3))}):Play()
    end
end

function TweenModule:ColorUpdate(Framer : Frame, Color : Color3)
    TweenService:Create(Framer, TweenModule.TweenInfoTable['UseShop'], {BackgroundColor3 = Color}):Play()
end

function TweenModule:SizePositionGui(Framer : Frame, Pos : UDim2, Sizee : UDim2)
    local tw = TweenService:Create(Framer,TweenModule.TweenInfoTable['UseShop'], {Size = Sizee})
    local tw2 = TweenService:Create(Framer,TweenModule.TweenInfoTable['UseShop'], {Position = Pos})
    tw:Play()
    tw2:Play()
end

function TweenModule:UseGuiFrame(GetFrame : Frame, Pos : UDim2)
    TweenService:Create(GetFrame, TweenModule.TweenInfoTable['UseShop'], {Position = Pos}):Play()
end

function TweenModule:AmiteButton(GetFrame : Frame, Pos : UDim2)
    TweenService:Create(GetFrame,TweenModule.TweenInfoTable['AnimateButton'], {Position = Pos})
end

function TweenModule:WaspPosition(Model : BasePart, newPos : Vector3?)
    TweenService:Create(Model, TweenModule.TweenInfoTable['TweenPosWasp'], {Position = newPos}):Play()
end

function TweenModule:WaspOrintation(AO : AlignOrientation, PosCFrame : CFrame)
    TweenService:Create(AO, TweenModule.TweenInfoTable['TweenPosWasp'], {CFrame = PosCFrame}):Play()
end

function TweenModule:FlyWasp(Part : BasePart, Pos : CFrame)
    TweenService:Create(Part, TweenModule.TweenInfoTable['WaspFlyPos'],{CFrame = Pos}):Play()
end

return TweenModule
local TweenService = game:GetService("TweenService")
local TweenModule = {}

TweenModule.TweenInfoTable = {
    ['TweenInfo1'] = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfo11'] = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfoSlot'] = TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    ['HiveWaspCreate'] = TweenInfo.new(0.45,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),
    ['FlowerDown'] = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
    ['FlowerUp'] = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
}


function TweenModule.OpenButton(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(10,0,5, 0)}):Play()
end

function TweenModule.CloseButton(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(0,0,0,0)}):Play()
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

return TweenModule
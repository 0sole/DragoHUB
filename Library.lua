local DragoLib = {} -- 1. Ana kütüphane tablomuz (Boş kutu)

-- UI'ın nereye kurulacağını belirleyelim (Exploitlerde CoreGui, Studio'da PlayerGui)
local CoreGui = game:GetService("CoreGui")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Güvenli Parent Seçimi (Hata almamak için)
local function getParent()
    if RunService:IsStudio() then
        return PlayerGui
    else
        return CoreGui
    end
end

--------------------------------------------------------------------------------
-- PENCERE OLUŞTURMA FONKSİYONU
--------------------------------------------------------------------------------
function DragoLib:CreateWindow(HubName)
    -- 1. ScreenGui Oluştur (Ekranda görünen katman)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DragoHUB_UI"
    ScreenGui.Parent = (game:GetService("RunService"):IsStudio() and PlayerGui) or CoreGui

    -- 2. Ana Çerçeve (Main Frame) - Siyah Arka Plan
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300) -- Genişlik 400, Yükseklik 300
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Tam ortala
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Koyu Gri
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Sürükleme Özelliği (Basit)
    local Drag = Instance.new("UIDragDetector")
    Drag.Parent = MainFrame

    -- Köşeleri Yuvarlatma (Estetik)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- 3. Başlık (Title)
    local Title = Instance.new("TextLabel")
    Title.Text = HubName
    Title.Size = UDim2.new(1, 0, 0, 40) -- Üstte şerit
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(200, 0, 0) -- DRAGO KIRMIZISI
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 24
    Title.Parent = MainFrame

    -- 4. İçerik Kutusu (Elementlerin dizileceği yer)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Parent = MainFrame
    
    -- Otomatik Sıralama (Elementler alt alta dizilsin diye)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5) -- Objeler arası 5 piksel boşluk
    UIListLayout.Parent = Container

    --[[ 
       BURASI ÇOK ÖNEMLİ:
       Fonksiyonumuz bir "Tablo" döndürecek. Bu tablo içinde
       yeni fonksiyonlar (Button, Toggle vb.) olacak.
    ]]
    local WindowFunctions = {}

    ----------------------------------------------------------------------------
    -- BUTON OLUŞTURMA (WindowFunctions İçinde)
    ----------------------------------------------------------------------------
    function WindowFunctions:CreateButton(ButtonText, CallbackFunction)
        local Button = Instance.new("TextButton")
        Button.Name = "DragoButton"
        Button.Parent = Container -- Container'ın içine koyuyoruz
        Button.Size = UDim2.new(1, 0, 0, 35) -- Tüm satırı kapla, yüksekliği 35
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.Text = ButtonText
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        
        -- Buton Köşesi
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- TIKLAMA OLAYI (CALLBACK MANTIĞI)
        Button.MouseButton1Click:Connect(function()
            -- Kullanıcı butona basınca, bize verdiği fonksiyonu çalıştırıyoruz.
            pcall(CallbackFunction) 
            
            -- Ufak bir animasyon (Basınca küçülüp büyüme)
            game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 35)}):Play()
            task.wait(0.1)
            game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 35)}):Play()
        end)
    end

    ----------------------------------------------------------------------------
    -- LABEL OLUŞTURMA (Sadece Yazı)
    ----------------------------------------------------------------------------
    function WindowFunctions:CreateLabel(LabelText)
        local Label = Instance.new("TextLabel")
        Label.Text = LabelText
        Label.Parent = Container
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
    end

    return WindowFunctions -- Pencere fonksiyonlarını geri döndür
end

return DragoLib

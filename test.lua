local url5 = "https://raw.githubusercontent.com/Q7ZxN3L8mT2PEwHkA9cFrXyS/R9v-1z-K-eNp-7WdX2-qLmT-/refs/heads/something/words.txt"

local Words5 = {}
local WordSet5 = {}
local WordDictionary5 = {}
local Loaded5 = false
local EnteredWords5 = {}

local KillerMap1_5 = {}
local KillerMap2_5 = {}
local KillerMap3_5 = {}
local KillerMap4_5 = {}
local KillerCategory5 = {}

local KillerUrls5 = {
    "https://raw.githubusercontent.com/Q7ZxN3L8mT2PEwHkA9cFrXyS/R9v-1z-K-eNp-7WdX2-qLmT-/refs/heads/something/modern_3.txt",
    "https://raw.githubusercontent.com/Q7ZxN3L8mT2PEwHkA9cFrXyS/R9v-1z-K-eNp-7WdX2-qLmT-/refs/heads/something/modern_2.txt",
    "https://raw.githubusercontent.com/Q7ZxN3L8mT2PEwHkA9cFrXyS/R9v-1z-K-eNp-7WdX2-qLmT-/refs/heads/something/modern.txt",
    "https://raw.githubusercontent.com/Q7ZxN3L8mT2PEwHkA9cFrXyS/R9v-1z-K-eNp-7WdX2-qLmT-/refs/heads/something/old.txt"
}

local KillerMaps5 = {
    KillerMap1_5,
    KillerMap2_5,
    KillerMap3_5,
    KillerMap4_5
}

local KillerLoaded5 = false

task.spawn(function()
    for i, url in ipairs(KillerUrls5) do
        pcall(function()
            local response = request({
                Url = url,
                Method = "GET"
            })

            if response and response.Success and response.Body then
                for word in response.Body:gmatch("[^\r\n]+") do
                    word = word:lower():match("^%s*(.-)%s*$")

                    if word ~= "" then
                        KillerMaps5[i][word] = true

                        if not KillerCategory5[word] then
                            KillerCategory5[word] = i
                        end
                    end
                end
            end
        end)
    end

    KillerLoaded5 = true
end)

local KillerColors5 = {
    Color3.fromRGB(170, 0, 255),
    Color3.fromRGB(0, 170, 255),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 0)
}

local function GetKillerCategory5(word)
    return KillerCategory5[word] or 5
end

local Orange5 = Color3.fromRGB(255, 115, 0)
local Purple5 = Color3.fromRGB(65, 30, 85)
local Dark5 = Color3.fromRGB(22, 17, 29)
local LightPurple5 = Color3.fromRGB(95, 55, 120)
local White5 = Color3.fromRGB(255, 240, 220)

local LoadError5 = nil

local function LoadWords5()
    if Loaded5 then return end

    local success, err = pcall(function()
        local response = request({
            Url = url5,
            Method = "GET"
        })

        if not response or not response.Success or not response.Body then
            error("Unable to download word list")
        end

        for word in response.Body:gmatch("[^\r\n]+") do
            local w = word:lower()

            if w ~= "" and not WordSet5[w] then
                WordSet5[w] = true
                table.insert(Words5, w)

                local first = w:sub(1, 1)

                if not WordDictionary5[first] then
                    WordDictionary5[first] = {}
                end

                table.insert(WordDictionary5[first], w)
            end
        end

        table.sort(Words5)

        for _, words in pairs(WordDictionary5) do
            table.sort(words)
        end

        Loaded5 = true
    end)

    if not success then
        LoadError5 = tostring(err)
    end
end

task.spawn(LoadWords5)

local function Shuffle5(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

local Players5 = game:GetService("Players")
local UIS5 = game:GetService("UserInputService")
local Player5 = Players5.LocalPlayer
local PlayerGui5 = Player5:WaitForChild("PlayerGui")
local Gui5 = Instance.new("ScreenGui")

local function GetMatchFrame5()
    local inGame = PlayerGui5:FindFirstChild("InGame")

    if not inGame or not inGame:IsA("ScreenGui") or not inGame.Enabled then
        return nil
    end

    local frame = inGame:FindFirstChild("Frame")

    if not frame or not frame.Visible then
        return nil
    end

    return frame
end

local function GetCurrentTurnPlayer5()
    local frame = GetMatchFrame5()
    local typeLabel = frame and frame:FindFirstChild("Type")

    if not typeLabel or not typeLabel:IsA("TextLabel") then
        return nil
    end

    local text = typeLabel.Text:gsub("<[^>]->", ""):lower()

    for _, candidate in ipairs(Players5:GetPlayers()) do
        local name = candidate.Name:lower()

        if text:find(name, 1, true) then
            return candidate.Name
        end
    end

    for _, candidate in ipairs(Players5:GetPlayers()) do
        local name = candidate.DisplayName:lower()

        if name ~= "" and text:find(name, 1, true) then
            return candidate.Name
        end
    end

    if text:match("your%s+turn") or text:match("you%s+are%s+typing") then
        return Player5.Name
    end

    return nil
end

local function IsMyTurn5()
    return GetCurrentTurnPlayer5() == Player5.Name
end

Gui5.Name = "WordSuggestorV3"
Gui5.ResetOnSpawn = false
Gui5.Parent = PlayerGui5

local Main5 = Instance.new("Frame")
Main5.Size = UDim2.new(0, 420, 0, 650)
Main5.Position = UDim2.new(0.5, -210, 0, 60)
Main5.BackgroundColor3 = Dark5
Main5.BorderSizePixel = 0
Main5.Active = true
Main5.Parent = Gui5

Instance.new("UICorner", Main5).CornerRadius = UDim.new(0, 10)

local MainStroke5 = Instance.new("UIStroke")
MainStroke5.Thickness = 2
MainStroke5.Color = Orange5
MainStroke5.Parent = Main5

local Content5 = Instance.new("Frame")
Content5.Size = UDim2.new(1, 0, 1, 0)
Content5.BackgroundTransparency = 1
Content5.Parent = Main5

local Title5 = Instance.new("TextLabel")
Title5.Size = UDim2.new(1, -145, 0, 35)
Title5.Position = UDim2.new(0, 10, 0, 5)
Title5.BackgroundTransparency = 1
Title5.Text = "🎃 Word Finder V3"
Title5.TextColor3 = Orange5
Title5.Font = Enum.Font.GothamBold
Title5.TextSize = 20
Title5.TextXAlignment = Enum.TextXAlignment.Left
Title5.Parent = Main5

local function MakeButton5(parent, text, size, pos)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = pos
    button.BackgroundColor3 = Purple5
    button.TextColor3 = Orange5
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Orange5
    stroke.Parent = button

    return button
end

local Min5 = MakeButton5(
    Main5,
    "-",
    UDim2.new(0, 35, 0, 35),
    UDim2.new(1, -120, 0, 5)
)

local Deleted5 = MakeButton5(
    Main5,
    "R",
    UDim2.new(0, 35, 0, 35),
    UDim2.new(1, -80, 0, 5)
)

local Close5 = MakeButton5(
    Main5,
    "X",
    UDim2.new(0, 35, 0, 35),
    UDim2.new(1, -40, 0, 5)
)

Min5.TextSize = 20
Deleted5.TextSize = 20
Close5.TextSize = 20

local Feedback5 = Instance.new("TextLabel")
Feedback5.Size = UDim2.new(1, -20, 0, 25)
Feedback5.Position = UDim2.new(0, 10, 0, 595)
Feedback5.BackgroundTransparency = 1
Feedback5.Text = ""
Feedback5.TextColor3 = White5
Feedback5.Font = Enum.Font.GothamBold
Feedback5.TextSize = 13
Feedback5.TextXAlignment = Enum.TextXAlignment.Center
Feedback5.TextTruncate = Enum.TextTruncate.AtEnd
Feedback5.Parent = Content5

local feedbackTimer5 = 0

local function ShowFeedback5(message, color)
    if message:find("#", 1, true) then
        message = "Error: Tags Detect"
        color = Color3.fromRGB(255, 80, 80)
    else
        local invalidWord = message:match("^%((.-)%) doesn't exist$")

        if invalidWord and (#invalidWord < 2 or #invalidWord > 4) then
            feedbackTimer5 += 1
            Feedback5.Text = ""
            Feedback5.Visible = false
            return
        end
    end

    feedbackTimer5 += 1
    local currentTimer = feedbackTimer5

    Feedback5.Text = message
    Feedback5.TextColor3 = color
    Feedback5.Visible = true

    task.delay(3, function()
        if currentTimer == feedbackTimer5 then
            Feedback5.Visible = false
        end
    end)
end

local dragging5 = false
local dragStart5
local startPos5
local dragInput5

Title5.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging5 = true
        dragStart5 = input.Position
        startPos5 = Main5.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging5 = false
            end
        end)
    end
end)

Title5.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput5 = input
    end
end)

UIS5.InputChanged:Connect(function(input)
    if input == dragInput5 and dragging5 then
        local delta = input.Position - dragStart5

        Main5.Position = UDim2.new(
            startPos5.X.Scale,
            startPos5.X.Offset + delta.X,
            startPos5.Y.Scale,
            startPos5.Y.Offset + delta.Y
        )
    end
end)

local minimized5 = false
local fullSize5 = Main5.Size

Min5.MouseButton1Click:Connect(function()
    minimized5 = not minimized5
    Content5.Visible = not minimized5
    Main5.Size = minimized5 and UDim2.new(0, 420, 0, 45) or fullSize5
end)

Close5.MouseButton1Click:Connect(function()
    Gui5:Destroy()
end)

local Sort5 = MakeButton5(
    Content5,
    "Sort Mode: Random",
    UDim2.new(1, -20, 0, 40),
    UDim2.new(0, 10, 0, 75)
)

Sort5.TextSize = 16

local SortModes5 = {"Shortest", "Longest", "Random", "Killer"}
local SortIndex5 = 3
local SortMode5 = "Random"

local Input5 = Instance.new("TextBox")
Input5.Size = UDim2.new(1, -20, 0, 40)
Input5.Position = UDim2.new(0, 10, 0, 125)
Input5.BackgroundColor3 = Purple5
Input5.TextColor3 = White5
Input5.PlaceholderColor3 = Color3.fromRGB(180, 150, 190)
Input5.PlaceholderText = "Type letters..."
Input5.Text = ""
Input5.ClearTextOnFocus = false
Input5.Font = Enum.Font.Gotham
Input5.TextSize = 18
Input5.TextXAlignment = Enum.TextXAlignment.Center
Input5.Parent = Content5

Instance.new("UICorner", Input5).CornerRadius = UDim.new(0, 6)

local InputStroke5 = Instance.new("UIStroke")
InputStroke5.Color = Orange5
InputStroke5.Thickness = 1
InputStroke5.Parent = Input5

local List5 = Instance.new("ScrollingFrame")
List5.Size = UDim2.new(1, -20, 0, 410)
List5.Position = UDim2.new(0, 10, 0, 175)
List5.BackgroundColor3 = Color3.fromRGB(35, 25, 43)
List5.BackgroundTransparency = 0
List5.BorderSizePixel = 0
List5.ScrollBarThickness = 8
List5.ScrollBarImageColor3 = Orange5
List5.AutomaticCanvasSize = Enum.AutomaticSize.Y
List5.CanvasSize = UDim2.new(0, 0, 0, 0)
List5.Parent = Content5

Instance.new("UICorner", List5).CornerRadius = UDim.new(0, 6)

local ListStroke5 = Instance.new("UIStroke")
ListStroke5.Color = LightPurple5
ListStroke5.Thickness = 1
ListStroke5.Parent = List5

local Layout5 = Instance.new("UIListLayout")
Layout5.Padding = UDim.new(0, 2)
Layout5.SortOrder = Enum.SortOrder.LayoutOrder
Layout5.Parent = List5

local Status5 = Instance.new("TextLabel")
Status5.Size = UDim2.new(1, -20, 0, 20)
Status5.Position = UDim2.new(0, 10, 0, 625)
Status5.BackgroundTransparency = 1
Status5.Text = "Loading Words..."
Status5.TextColor3 = Orange5
Status5.Font = Enum.Font.GothamBold
Status5.TextSize = 13
Status5.Parent = Content5

local LoadSuccessStart5 = nil

local Prefix5 = Instance.new("TextLabel")
Prefix5.Size = UDim2.new(1, -20, 0, 30)
Prefix5.Position = UDim2.new(0, 10, 0, 38)
Prefix5.BackgroundTransparency = 1
Prefix5.Text = "Prefix: -"
Prefix5.TextColor3 = Orange5
Prefix5.Font = Enum.Font.GothamBold
Prefix5.TextSize = 18
Prefix5.TextScaled = false
Prefix5.TextWrapped = false
Prefix5.TextXAlignment = Enum.TextXAlignment.Center
Prefix5.Parent = Content5

local function AdjustPrefixSize5()
    local availableWidth = Prefix5.AbsoluteSize.X - 4

    if availableWidth <= 0 then return end

    Prefix5.TextSize = 18

    local textWidth = Prefix5.TextBounds.X

    if textWidth > availableWidth then
        Prefix5.TextSize = math.max(1, 18 * availableWidth / textWidth)
    end
end

local Results5 = {}
local PrefixUpdateToken5 = 0

local function GetSuggestions5(prefix, count)
    if not Loaded5 or prefix == "" then
        return {}
    end

    if SortMode5 == "Killer" and not KillerLoaded5 then
        return {}
    end

    local source = WordDictionary5[prefix:sub(1, 1)] or Words5
    local low = 1
    local high = #source + 1

    while low < high do
        local mid = math.floor((low + high) / 2)

        if source[mid] < prefix then
            low = mid + 1
        else
            high = mid
        end
    end

    local results = {}
    local seen = 0

    local function IsBetter(a, b)
        if #a == #b then
            return a < b
        end

        if SortMode5 == "Shortest" then
            return #a < #b
        end

        return #a > #b
    end

    local categories = nil
    local categoryCounts = nil

    if SortMode5 == "Killer" then
        categories = {{}, {}, {}, {}, {}}
        categoryCounts = {0, 0, 0, 0, 0}
    end

    for i = low, #source do
        local word = source[i]

        if word:sub(1, #prefix) ~= prefix then
            break
        end

        if not EnteredWords5[word] then
            if SortMode5 == "Random" then
                seen += 1

                if #results < count then
                    table.insert(results, word)
                else
                    local position = math.random(seen)

                    if position <= count then
                        results[position] = word
                    end
                end

            elseif SortMode5 == "Killer" then
                local category = GetKillerCategory5(word)
                local bucket = categories[category]

                categoryCounts[category] += 1
                local categorySeen = categoryCounts[category]

                if #bucket < count then
                    table.insert(bucket, word)
                else
                    local position = math.random(categorySeen)

                    if position <= count then
                        bucket[position] = word
                    end
                end

            else
                local position = 1
                local left = 1
                local right = #results

                while left <= right do
                    local mid = math.floor((left + right) / 2)

                    if IsBetter(word, results[mid]) then
                        right = mid - 1
                    else
                        left = mid + 1
                    end
                end

                position = left

                if position <= count then
                    table.insert(results, position, word)

                    if #results > count then
                        table.remove(results)
                    end
                end
            end
        end
    end

    if SortMode5 == "Killer" then
        results = {}

        for i = 1, 5 do
            Shuffle5(categories[i])

            for _, word in ipairs(categories[i]) do
                if #results >= count then
                    break
                end

                table.insert(results, word)
            end

            if #results >= count then
                break
            end
        end

    elseif SortMode5 == "Random" then
        Shuffle5(results)
    end

    return results
end

local SuggestionButtons5 = {}
local MaxDisplay5 = 50

local function Clear5()
    for _, button in ipairs(SuggestionButtons5) do
        button.Parent = nil
    end
end

local function DisplayWords5(words, prefix)
    prefix = (prefix or ""):lower()

    for i, word in ipairs(words) do
        if i > MaxDisplay5 then
            break
        end

        local button = SuggestionButtons5[i]

        if not button then
            button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 32)
            button.BackgroundColor3 = Purple5
            button.TextColor3 = White5
            button.Font = Enum.Font.GothamBold
            button.TextSize = 16
            button.RichText = true

            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)

            button.MouseButton1Click:Connect(function()
                Input5.Text = button:GetAttribute("Word5") or ""
            end)

            SuggestionButtons5[i] = button
        end

        local color = KillerColors5[GetKillerCategory5(word)]
        local hex = color:ToHex()
        local matching = word:sub(1, #prefix)
        local remaining = word:sub(#prefix + 1)

        button:SetAttribute("Word5", word)
        button.LayoutOrder = i
        button.Text = '<font color="#' .. hex .. '">' .. matching .. '</font>' .. remaining
        button.TextColor3 = White5
        button.Parent = List5
    end

    for i = #words + 1, #SuggestionButtons5 do
        SuggestionButtons5[i].Parent = nil
    end
end

local function UpdateSuggestions5()
    PrefixUpdateToken5 += 1

    if not Loaded5 then return end

    local prefix = Input5.Text:lower()

    if prefix == "" then
        Results5 = {}
        Clear5()
        return
    end

    Results5 = GetSuggestions5(prefix, MaxDisplay5)
    DisplayWords5(Results5, prefix)
end

Input5:GetPropertyChangedSignal("Text"):Connect(function()
    UpdateSuggestions5()
end)

Sort5.MouseButton1Click:Connect(function()
    SortIndex5 = SortIndex5 % #SortModes5 + 1
    SortMode5 = SortModes5[SortIndex5]
    Sort5.Text = "Sort Mode: " .. SortMode5

    if Input5.Text ~= "" then
        UpdateSuggestions5()
    end
end)

local CurrentWord5 = nil
local PreviousWord5 = ""
local CapturedWord5 = ""
local LastPrefix5 = ""

local PrefixFull5 = ""
local PrefixDisplay5 = ""
local PrefixHistory5 = ""
local PreviousTurn5 = nil
local OpponentWord5 = ""

local LastSeenGameWord5 = ""
local LastCompleteWordInTurn5 = ""
local LongestWordInTurn5 = ""
local LastCapturedVisibleWord5 = ""
local TurnPrompt5 = ""

local AntiIntimidator5 = false

local function ReverseWord5(word)
    return word:reverse()
end

local function DetectIntimidator5()
    for _, obj in ipairs(PlayerGui5:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.Text:lower():find("reversed the word be careful!", 1, true) then
                return true
            end
        end
    end

    return false
end

local function RebuildPrefix5(raw)
    local marker = raw:find("%.%.%.", 1)

    if not marker then
        if raw == "" then
            PrefixFull5 = ""
            PrefixDisplay5 = ""
            PrefixHistory5 = ""
            return ""
        end

        PrefixFull5 = raw
        PrefixDisplay5 = raw
        PrefixHistory5 = raw

        return PrefixFull5
    end

    local suffix = raw:sub(marker + 3)

    if suffix == "" then
        PrefixDisplay5 = PrefixFull5
        return PrefixFull5
    end

    local position = PrefixHistory5:find(suffix, 1, true)

    if position then
        PrefixFull5 = PrefixHistory5:sub(1, position + #suffix - 1)
    else
        local overlap = 0

        for i = 1, math.min(#PrefixFull5, #suffix) do
            if PrefixFull5:sub(-i) == suffix:sub(1, i) then
                overlap = i
            end
        end

        if overlap > 0 then
            PrefixFull5 = PrefixFull5 .. suffix:sub(overlap + 1)
            PrefixHistory5 = PrefixFull5
        end
    end

    PrefixDisplay5 = PrefixFull5

    return PrefixFull5
end

local function DetectPrefix5()
    if not CurrentWord5 or not CurrentWord5.Parent then
        CurrentWord5 = PlayerGui5:FindFirstChild("CurrentWord", true)
    end

    if not CurrentWord5 then return "" end

    local letters = {}

    for _, child in ipairs(CurrentWord5:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local label = child:FindFirstChild("Letter")

            if label and label:IsA("TextLabel") then
                local value = label.Text:lower()

                if value ~= "" then
                    table.insert(letters, {
                        text = value,
                        x = child.AbsolutePosition.X
                    })
                end
            end
        end
    end

    table.sort(letters, function(a, b)
        return a.x < b.x
    end)

    local prefix = ""

    for _, letter in ipairs(letters) do
        prefix = prefix .. letter.text
    end

    return prefix
end

local function GetLiveGameWord5()
    local frame = GetMatchFrame5()
    local container = frame and frame:FindFirstChild("CurrentWord")

    if not container then
        return ""
    end

    local letters = {}

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local label = child:FindFirstChild("Letter")

            if label and label:IsA("TextLabel")
                and label.TextTransparency < 1 then

                table.insert(letters, {
                    text = label.Text,
                    x = child.AbsolutePosition.X,
                    y = child.AbsolutePosition.Y,
                    order = child.LayoutOrder or 0
                })
            end
        end
    end

    table.sort(letters, function(a, b)
        if a.order ~= b.order then
            return a.order < b.order
        end

        if math.abs(a.y - b.y) > 10 then
            return a.y < b.y
        end

        return a.x < b.x
    end)

    local word = ""

    for _, letter in ipairs(letters) do
        word = word .. tostring(letter.text)
    end

    return word:lower():gsub("%s+", "")
end

local function SchedulePrefixSuggestions5(prefix)
    PrefixUpdateToken5 += 1
    local token = PrefixUpdateToken5

    task.delay(0.08, function()
        if token ~= PrefixUpdateToken5 then
            return
        end

        if not Gui5.Parent or Input5.Text ~= "" then
            return
        end

        Results5 = GetSuggestions5(prefix, MaxDisplay5)
        DisplayWords5(Results5, prefix)
    end)
end

local function UpdatePrefix5(prefix)
    if prefix == "" then
        PrefixUpdateToken5 += 1
        Prefix5.Text = "Prefix: -"
        Prefix5.TextColor3 = Orange5

        if Input5.Text == "" then
            Results5 = {}
            Clear5()
        end

        return
    end

    Prefix5.Text = "Prefix: " .. PrefixDisplay5

    task.defer(function()
        if Prefix5.Parent then
            AdjustPrefixSize5()
        end
    end)

    if prefix:find("%.%.%.") or prefix:find("#") then
        PrefixUpdateToken5 += 1
        Prefix5.TextColor3 = Color3.fromRGB(255, 220, 0)

        if Input5.Text == "" then
            Results5 = {}
            Clear5()
        end

        return
    end

    Prefix5.TextColor3 = Orange5

    if Input5.Text ~= "" then return end

    SchedulePrefixSuggestions5(prefix)
end

Deleted5.MouseButton1Click:Connect(function()
    EnteredWords5 = {}

    ShowFeedback5(
        "All Deleted Words Are Restored...",
        Color3.fromRGB(100, 170, 255),
        3
    )

    if Input5.Text ~= "" then
        UpdateSuggestions5()
    elseif LastPrefix5 ~= "" then
        UpdatePrefix5(LastPrefix5)
    end
end)

local PrefixConnections5 = {}

local function RefreshPrefix5()
    local rawPrefix = DetectPrefix5()

    if rawPrefix == "" then
        if LastPrefix5 == "" then
            PrefixFull5 = ""
            PrefixDisplay5 = ""
            PrefixHistory5 = ""
        end

        return
    end

    local prefix = RebuildPrefix5(rawPrefix)

    if AntiIntimidator5 then
        prefix = ReverseWord5(PrefixFull5)
        PrefixDisplay5 = prefix
    end

    if prefix ~= LastPrefix5 then
        LastPrefix5 = prefix
        UpdatePrefix5(prefix)
    end
end

local WatchedCurrentWord5 = nil

local function WatchCurrentWord5()
    if not CurrentWord5 or not CurrentWord5.Parent then
        CurrentWord5 = PlayerGui5:FindFirstChild("CurrentWord", true)
    end

    if not CurrentWord5 then return end
    if WatchedCurrentWord5 == CurrentWord5 then return end

    for _, connection in ipairs(PrefixConnections5) do
        connection:Disconnect()
    end

    table.clear(PrefixConnections5)

    WatchedCurrentWord5 = CurrentWord5

    local function WatchLetter5(obj)
        if not obj:IsA("GuiObject") then return end

        table.insert(PrefixConnections5,
            obj:GetPropertyChangedSignal("Visible"):Connect(RefreshPrefix5)
        )

        local function WatchLabel5(child)
            if child.Name == "Letter" and child:IsA("TextLabel") then
                table.insert(PrefixConnections5,
                    child:GetPropertyChangedSignal("Text"):Connect(RefreshPrefix5)
                )
                RefreshPrefix5()
            end
        end

        local label = obj:FindFirstChild("Letter")

        if label then
            WatchLabel5(label)
        end

        table.insert(PrefixConnections5,
            obj.ChildAdded:Connect(WatchLabel5)
        )

        table.insert(PrefixConnections5,
            obj.ChildRemoved:Connect(RefreshPrefix5)
        )
    end

    for _, child in ipairs(CurrentWord5:GetChildren()) do
        WatchLetter5(child)
    end

    table.insert(PrefixConnections5,
        CurrentWord5.ChildAdded:Connect(function(child)
            WatchLetter5(child)
            RefreshPrefix5()
        end)
    )

    table.insert(PrefixConnections5,
        CurrentWord5.ChildRemoved:Connect(RefreshPrefix5)
    )

    RefreshPrefix5()
end

task.spawn(function()
    while Gui5.Parent do
        WatchCurrentWord5()
        task.wait(0.5)
    end
end)

local Visible5 = true

UIS5.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightControl
        or input.KeyCode == Enum.KeyCode.LeftControl then
        Visible5 = not Visible5
        Main5.Visible = Visible5
    end
end)

local function UpdateCaptured5()
    if not CurrentWord5 or not CurrentWord5.Parent then
        CurrentWord5 = PlayerGui5:FindFirstChild("CurrentWord", true)
    end

    if not CurrentWord5 then return end

    local letters = {}

    for _, child in ipairs(CurrentWord5:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local label = child:FindFirstChild("Letter")

            if label and label:IsA("TextLabel") then
                local value = label.Text:lower()

                if value ~= "" then
                    table.insert(letters, {
                        text = value,
                        x = child.AbsolutePosition.X
                    })
                end
            end
        end
    end

    table.sort(letters, function(a, b)
        return a.x < b.x
    end)

    if #letters == 0 then
        PreviousWord5 = ""
        return
    end

    local visible = ""

    for _, data in ipairs(letters) do
        visible = visible .. data.text
    end

    if PreviousWord5 == "" then
        CapturedWord5 = visible
        PreviousWord5 = visible
        return
    end

    if visible == PreviousWord5 then return end

    if #visible > #PreviousWord5
        and visible:sub(1, #PreviousWord5) == PreviousWord5 then

        CapturedWord5 = visible
        PreviousWord5 = visible
        return
    end

    if #visible < #PreviousWord5 then
        if CapturedWord5:sub(-#visible) == visible then
            PreviousWord5 = visible
            return
        end
    end

    local overlap = 0

    for i = 1, math.min(#CapturedWord5, #visible) do
        if CapturedWord5:sub(-i) == visible:sub(1, i) then
            overlap = i
        end
    end

    if overlap > 0 then
        CapturedWord5 = CapturedWord5 .. visible:sub(overlap + 1)
    else
        CapturedWord5 = visible
    end

    PreviousWord5 = visible
end

local DoneButton5
local DoneConnection5

local function FindDone5()
    for _, obj in ipairs(PlayerGui5:GetDescendants()) do
        if obj:IsA("TextButton") then
            if obj.Text:lower() == "done"
                or obj.Name:lower() == "done" then

                return obj
            end

        elseif obj:IsA("ImageButton")
            and obj.Name:lower() == "done" then

            return obj
        end
    end
end

local function SubmitWord5()
    UpdateCaptured5()

    local word = LastPrefix5:lower()

    if word == "" then
        return
    end

    if word:find("#", 1, true) then
        ShowFeedback5(
            "Error: Tags Detect",
            Color3.fromRGB(255, 80, 80)
        )

    elseif word:find("...", 1, true) then
        ShowFeedback5(
            "Error: ... detected",
            Color3.fromRGB(255, 0, 0)
        )

    elseif #word < 2 then
        return

    elseif not Loaded5 then
        ShowFeedback5(
            "Dictionary is still loading",
            Color3.fromRGB(255, 220, 0)
        )

    elseif WordSet5[word] then
        EnteredWords5[word] = true

        ShowFeedback5(
            "(" .. word .. ") has been deleted",
            Color3.fromRGB(0, 255, 100)
        )

        if Input5.Text ~= "" then
            UpdateSuggestions5()
        end

        task.delay(0.15, function()
            CapturedWord5 = ""
            PreviousWord5 = ""
            PrefixFull5 = ""
            PrefixDisplay5 = ""
            PrefixHistory5 = ""
            LastPrefix5 = ""
            RefreshPrefix5()
        end)

    else
        ShowFeedback5(
            "(" .. word .. ") doesn't exist",
            Color3.fromRGB(255, 220, 0)
        )

        if #word <= 11 then
            return
        end

        PrefixFull5 = word
        PrefixDisplay5 = word
        PrefixHistory5 = word
        LastPrefix5 = word
        UpdatePrefix5(word)

        CapturedWord5 = word
        PreviousWord5 = word
    end
end

local function ConnectDone5()
    local button = FindDone5()

    if not button or button == DoneButton5 then
        return
    end

    if DoneConnection5 then
        DoneConnection5:Disconnect()
    end

    DoneButton5 = button

    DoneConnection5 = button.Activated:Connect(SubmitWord5)
end

task.spawn(function()
    while Gui5.Parent do
        UpdateCaptured5()

        if not DoneButton5 or not DoneButton5.Parent then
            DoneButton5 = nil
            ConnectDone5()
        end

        task.wait(0.25)
    end
end)

UIS5.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Return
        or input.KeyCode == Enum.KeyCode.KeypadEnter then

        SubmitWord5()
    end
end)

task.spawn(function()
    while Gui5.Parent do
        local currentTurn = GetCurrentTurnPlayer5()
        local liveWord = GetLiveGameWord5()

        if currentTurn then
            if currentTurn ~= PreviousTurn5 then
                if PreviousTurn5 and PreviousTurn5 ~= Player5.Name then
                    local previousWord = LastCompleteWordInTurn5

                    if not WordSet5[previousWord] then
                        previousWord = LastSeenGameWord5
                    end

                    if not WordSet5[previousWord] then
                        previousWord = LongestWordInTurn5
                    end

                    if previousWord ~= "" then
                        OpponentWord5 = previousWord
                    end
                end

                if currentTurn ~= Player5.Name then
                    LastSeenGameWord5 = ""
                    LastCompleteWordInTurn5 = ""
                    LongestWordInTurn5 = ""
                    LastCapturedVisibleWord5 = ""
                    TurnPrompt5 = ""
                    OpponentWord5 = ""

                    CapturedWord5 = ""
                    PreviousWord5 = ""

                    PrefixFull5 = ""
                    PrefixDisplay5 = ""
                    PrefixHistory5 = ""
                    LastPrefix5 = ""

                    RefreshPrefix5()
                end
            end

            if currentTurn ~= Player5.Name and liveWord ~= "" then
                local previousVisible = LastSeenGameWord5

                if previousVisible ~= ""
                    and previousVisible ~= LastCapturedVisibleWord5
                    and #liveWord <= 4
                    and #previousVisible > #liveWord
                    and previousVisible:sub(1, #liveWord) ~= liveWord
                    and TurnPrompt5 ~= ""
                    and #previousVisible > #TurnPrompt5
                    and previousVisible:sub(1, #TurnPrompt5) == TurnPrompt5 then

                    LastCapturedVisibleWord5 = previousVisible

                    if WordSet5[previousVisible] then
                        LastCompleteWordInTurn5 = previousVisible
                    end
                end

                if TurnPrompt5 == "" then
                    TurnPrompt5 = liveWord
                end

                LastSeenGameWord5 = liveWord

                if #liveWord > #LongestWordInTurn5 then
                    LongestWordInTurn5 = liveWord
                end

                if #liveWord > #TurnPrompt5
                    and WordSet5[liveWord]
                    and liveWord:sub(1, #TurnPrompt5) == TurnPrompt5 then

                    LastCompleteWordInTurn5 = liveWord
                end
            end

            if currentTurn == Player5.Name
                and PreviousTurn5
                and PreviousTurn5 ~= Player5.Name
                and Loaded5 then

                local word = OpponentWord5

                if word ~= "" then
                    if WordSet5[word] then
                        EnteredWords5[word] = true

                        ShowFeedback5(
                            "(" .. word .. ") has been deleted",
                            Color3.fromRGB(0, 255, 100)
                        )

                        print("Opponent word deleted:", word)

                    else
                        ShowFeedback5(
                            "(" .. word .. ") doesn't exist",
                            Color3.fromRGB(255, 220, 0)
                        )

                        warn("Opponent word not found:", word)
                    end

                    if Input5.Text ~= "" then
                        UpdateSuggestions5()
                    elseif LastPrefix5 ~= "" then
                        UpdatePrefix5(LastPrefix5)
                    end
                end

                OpponentWord5 = ""
            end

            PreviousTurn5 = currentTurn
        end

        task.wait(0.05)
    end
end)

task.spawn(function()
    while Gui5.Parent do
        local detected = DetectIntimidator5()
        local myTurn = GetCurrentTurnPlayer5() == Player5.Name
        local newState = detected and myTurn

        if newState ~= AntiIntimidator5 then
            AntiIntimidator5 = newState

            PrefixFull5 = ""
            PrefixDisplay5 = ""
            PrefixHistory5 = ""
            LastPrefix5 = ""

            RefreshPrefix5()
        end

        if Loaded5 and not LoadSuccessStart5 then
            LoadSuccessStart5 = os.clock()
        end

        if AntiIntimidator5 then
            Status5.Text = "Intimidator Detect!"
            Status5.TextColor3 = Color3.fromRGB(255, 0, 0)

        elseif LoadError5 then
            Status5.Text = "Loading failed"
            Status5.TextColor3 = Color3.fromRGB(255, 0, 0)

        elseif Loaded5 then
            if os.clock() - LoadSuccessStart5 < 5 then
                Status5.Text = "Words Loaded Successfully!"
                Status5.TextColor3 = Orange5
            else
                Status5.Text = "The Useless Text Lol.. Btw the dictionary is outdated"
                Status5.TextColor3 = Color3.fromRGB(170, 85, 255)
            end
        else
            Status5.Text = "Loading Words..."
            Status5.TextColor3 = Orange5
        end

        task.wait(0.5)
    end
end)
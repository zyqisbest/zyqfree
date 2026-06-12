-- config.lua
-- Centralized configuration for the zyqfree script UI.
-- Extracting data and logic into a module makes the codebase testable
-- without requiring the Roblox runtime.

local Config = {}

-- Default and boosted humanoid stats used by the "Super Human" toggle
Config.DEFAULT_WALKSPEED = 16
Config.DEFAULT_JUMPPOWER = 50
Config.BOOSTED_WALKSPEED = 150
Config.BOOSTED_JUMPPOWER = 150

-- Remote script URLs loaded by each button
Config.SCRIPT_URLS = {
    fly            = "https://cdn.wearedevs.net/scripts/Fly.txt",
    aimbot         = "https://cdn.wearedevs.net/scripts/WRD%20Aimbot.txt",
    click_teleport = "https://cdn.wearedevs.net/scripts/Click%20Teleport.txt",
    btools         = "https://cdn.wearedevs.net/scripts/BTools.txt",
    teleport       = "https://cdn.wearedevs.net/scripts/Teleport%20To%20Player.txt",
    infinite_jump  = "https://cdn.wearedevs.net/scripts/Infinite%20Jump.txt",
    owl_hub        = "https://cdn.wearedevs.net/scripts/OwlHub.txt",
    ez_hub         = "https://cdn.wearedevs.net/scripts/Ez%20Hub.txt",
    rogue_hub      = "https://cdn.wearedevs.net/scripts/Rogue%20Hub.txt",
}

-- UI library source
Config.UI_LIBRARY_URL = "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"

-- Window metadata
Config.WINDOW_TITLE = "https://discord.gg/fz8nyX8FZW made by zyq#9999"
Config.WINDOW_THEME = "DarkTheme"

-- Tab definitions (order matters for the UI)
Config.TABS = { "Main", "Hubs", "Credits" }

-- Button definitions per section.
-- Each entry: { id, label, description }
Config.MAIN_BUTTONS = {
    { id = "fly",            label = "FLY",                    description = "idk u fly i guess" },
    { id = "aimbot",         label = "Aimbot",                 description = "cause u have shit aim im guessing" },
    { id = "click_teleport", label = "Click Teleport (check desc)", description = "ctrl + click" },
    { id = "btools",         label = "BTOOLS",                 description = "u shold know it" },
    { id = "teleport",       label = "TP",                     description = "tp to someone" },
    { id = "infinite_jump",  label = "Infinte Jump",           description = "jump a lot" },
}

Config.HUB_BUTTONS = {
    { id = "owl_hub",   label = "Owl hub",   description = "OWL HUB" },
    { id = "ez_hub",    label = "EZ Hub",     description = "EZ HUB" },
    { id = "rogue_hub", label = "Rogue Hub",  description = "ROGUE HUB" },
}

--- Apply the "Super Human" toggle to a humanoid table/object.
--- @param humanoid table  must expose .Walkspeed and .JumpPower fields
--- @param enabled  boolean
function Config.applySuperHuman(humanoid, enabled)
    if enabled then
        humanoid.Walkspeed = Config.BOOSTED_WALKSPEED
        humanoid.JumpPower = Config.BOOSTED_JUMPPOWER
    else
        humanoid.Walkspeed = Config.DEFAULT_WALKSPEED
        humanoid.JumpPower = Config.DEFAULT_JUMPPOWER
    end
end

--- Return the full remote-script URL for a given button id.
--- @param id string
--- @return string|nil
function Config.getScriptUrl(id)
    return Config.SCRIPT_URLS[id]
end

--- Validate that every button id in a list has a corresponding script URL.
--- @param buttons table  list of {id, label, description}
--- @return boolean, string|nil  true on success; false + missing id on failure
function Config.validateButtons(buttons)
    for _, btn in ipairs(buttons) do
        if not Config.SCRIPT_URLS[btn.id] then
            return false, btn.id
        end
    end
    return true
end

return Config

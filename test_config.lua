#!/usr/bin/env lua5.3
-- test_config.lua
-- Unit tests for config.lua using luaunit.

package.path = package.path .. ";./?.lua"
local lu = require("luaunit")
local Config = require("config")

---------------------------------------------------------------------------
-- Test: Super Human toggle logic
---------------------------------------------------------------------------
TestSuperHuman = {}

function TestSuperHuman:setUp()
    self.humanoid = { Walkspeed = 16, JumpPower = 50 }
end

function TestSuperHuman:test_enable_sets_boosted_values()
    Config.applySuperHuman(self.humanoid, true)
    lu.assertEquals(self.humanoid.Walkspeed, Config.BOOSTED_WALKSPEED)
    lu.assertEquals(self.humanoid.JumpPower, Config.BOOSTED_JUMPPOWER)
end

function TestSuperHuman:test_disable_restores_defaults()
    -- First enable, then disable
    Config.applySuperHuman(self.humanoid, true)
    Config.applySuperHuman(self.humanoid, false)
    lu.assertEquals(self.humanoid.Walkspeed, Config.DEFAULT_WALKSPEED)
    lu.assertEquals(self.humanoid.JumpPower, Config.DEFAULT_JUMPPOWER)
end

function TestSuperHuman:test_disable_from_initial_state()
    Config.applySuperHuman(self.humanoid, false)
    lu.assertEquals(self.humanoid.Walkspeed, Config.DEFAULT_WALKSPEED)
    lu.assertEquals(self.humanoid.JumpPower, Config.DEFAULT_JUMPPOWER)
end

function TestSuperHuman:test_boosted_values_are_150()
    lu.assertEquals(Config.BOOSTED_WALKSPEED, 150)
    lu.assertEquals(Config.BOOSTED_JUMPPOWER, 150)
end

function TestSuperHuman:test_default_walkspeed_is_16()
    lu.assertEquals(Config.DEFAULT_WALKSPEED, 16)
end

function TestSuperHuman:test_default_jumppower_is_50()
    lu.assertEquals(Config.DEFAULT_JUMPPOWER, 50)
end

function TestSuperHuman:test_toggle_idempotent_enable()
    Config.applySuperHuman(self.humanoid, true)
    Config.applySuperHuman(self.humanoid, true)
    lu.assertEquals(self.humanoid.Walkspeed, Config.BOOSTED_WALKSPEED)
    lu.assertEquals(self.humanoid.JumpPower, Config.BOOSTED_JUMPPOWER)
end

function TestSuperHuman:test_toggle_idempotent_disable()
    Config.applySuperHuman(self.humanoid, false)
    Config.applySuperHuman(self.humanoid, false)
    lu.assertEquals(self.humanoid.Walkspeed, Config.DEFAULT_WALKSPEED)
    lu.assertEquals(self.humanoid.JumpPower, Config.DEFAULT_JUMPPOWER)
end

---------------------------------------------------------------------------
-- Test: Script URL lookup
---------------------------------------------------------------------------
TestScriptUrls = {}

function TestScriptUrls:test_fly_url()
    lu.assertEquals(Config.getScriptUrl("fly"),
        "https://cdn.wearedevs.net/scripts/Fly.txt")
end

function TestScriptUrls:test_aimbot_url()
    lu.assertEquals(Config.getScriptUrl("aimbot"),
        "https://cdn.wearedevs.net/scripts/WRD%20Aimbot.txt")
end

function TestScriptUrls:test_click_teleport_url()
    lu.assertEquals(Config.getScriptUrl("click_teleport"),
        "https://cdn.wearedevs.net/scripts/Click%20Teleport.txt")
end

function TestScriptUrls:test_btools_url()
    lu.assertEquals(Config.getScriptUrl("btools"),
        "https://cdn.wearedevs.net/scripts/BTools.txt")
end

function TestScriptUrls:test_teleport_url()
    lu.assertEquals(Config.getScriptUrl("teleport"),
        "https://cdn.wearedevs.net/scripts/Teleport%20To%20Player.txt")
end

function TestScriptUrls:test_infinite_jump_url()
    lu.assertEquals(Config.getScriptUrl("infinite_jump"),
        "https://cdn.wearedevs.net/scripts/Infinite%20Jump.txt")
end

function TestScriptUrls:test_owl_hub_url()
    lu.assertEquals(Config.getScriptUrl("owl_hub"),
        "https://cdn.wearedevs.net/scripts/OwlHub.txt")
end

function TestScriptUrls:test_ez_hub_url()
    lu.assertEquals(Config.getScriptUrl("ez_hub"),
        "https://cdn.wearedevs.net/scripts/Ez%20Hub.txt")
end

function TestScriptUrls:test_rogue_hub_url()
    lu.assertEquals(Config.getScriptUrl("rogue_hub"),
        "https://cdn.wearedevs.net/scripts/Rogue%20Hub.txt")
end

function TestScriptUrls:test_unknown_id_returns_nil()
    lu.assertNil(Config.getScriptUrl("nonexistent"))
end

function TestScriptUrls:test_all_urls_are_https()
    for id, url in pairs(Config.SCRIPT_URLS) do
        lu.assertStrContains(url, "https://",
            string.format("URL for '%s' must use HTTPS", id))
    end
end

function TestScriptUrls:test_url_count()
    local count = 0
    for _ in pairs(Config.SCRIPT_URLS) do count = count + 1 end
    lu.assertEquals(count, 9)
end

---------------------------------------------------------------------------
-- Test: Button configuration integrity
---------------------------------------------------------------------------
TestButtons = {}

function TestButtons:test_main_buttons_have_valid_urls()
    local ok, missing = Config.validateButtons(Config.MAIN_BUTTONS)
    lu.assertTrue(ok, "Missing URL for main button: " .. tostring(missing))
end

function TestButtons:test_hub_buttons_have_valid_urls()
    local ok, missing = Config.validateButtons(Config.HUB_BUTTONS)
    lu.assertTrue(ok, "Missing URL for hub button: " .. tostring(missing))
end

function TestButtons:test_main_button_count()
    lu.assertEquals(#Config.MAIN_BUTTONS, 6)
end

function TestButtons:test_hub_button_count()
    lu.assertEquals(#Config.HUB_BUTTONS, 3)
end

function TestButtons:test_buttons_have_required_fields()
    local all_buttons = {}
    for _, b in ipairs(Config.MAIN_BUTTONS) do table.insert(all_buttons, b) end
    for _, b in ipairs(Config.HUB_BUTTONS) do table.insert(all_buttons, b) end

    for _, btn in ipairs(all_buttons) do
        lu.assertNotNil(btn.id,
            "Button missing 'id' field")
        lu.assertNotNil(btn.label,
            string.format("Button '%s' missing 'label'", btn.id))
        lu.assertNotNil(btn.description,
            string.format("Button '%s' missing 'description'", btn.id))
    end
end

function TestButtons:test_button_ids_are_unique()
    local seen = {}
    local all_buttons = {}
    for _, b in ipairs(Config.MAIN_BUTTONS) do table.insert(all_buttons, b) end
    for _, b in ipairs(Config.HUB_BUTTONS) do table.insert(all_buttons, b) end

    for _, btn in ipairs(all_buttons) do
        lu.assertNil(seen[btn.id],
            string.format("Duplicate button id: '%s'", btn.id))
        seen[btn.id] = true
    end
end

function TestButtons:test_validate_catches_missing_url()
    local bad_buttons = {{ id = "does_not_exist", label = "X", description = "X" }}
    local ok, missing = Config.validateButtons(bad_buttons)
    lu.assertFalse(ok)
    lu.assertEquals(missing, "does_not_exist")
end

function TestButtons:test_validate_empty_list_succeeds()
    local ok = Config.validateButtons({})
    lu.assertTrue(ok)
end

---------------------------------------------------------------------------
-- Test: Tab / window configuration
---------------------------------------------------------------------------
TestWindowConfig = {}

function TestWindowConfig:test_tab_count()
    lu.assertEquals(#Config.TABS, 3)
end

function TestWindowConfig:test_tab_names()
    lu.assertEquals(Config.TABS[1], "Main")
    lu.assertEquals(Config.TABS[2], "Hubs")
    lu.assertEquals(Config.TABS[3], "Credits")
end

function TestWindowConfig:test_window_theme()
    lu.assertEquals(Config.WINDOW_THEME, "DarkTheme")
end

function TestWindowConfig:test_window_title_contains_discord()
    lu.assertStrContains(Config.WINDOW_TITLE, "discord.gg")
end

function TestWindowConfig:test_ui_library_url_is_https()
    lu.assertStrContains(Config.UI_LIBRARY_URL, "https://")
end

function TestWindowConfig:test_ui_library_url_points_to_kavo()
    lu.assertStrContains(Config.UI_LIBRARY_URL, "Kavo-UI-Library")
end

---------------------------------------------------------------------------
-- Run
---------------------------------------------------------------------------
os.exit(lu.LuaUnit.run())

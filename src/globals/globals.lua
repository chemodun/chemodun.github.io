---@meta

-- X4: Foundations Globally Exposed Functions
-- Generated automatically from game files
-- These functions are made globally accessible.

--- The global colour lookup table.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Filled from the game's colour definitions and registered with MakeGlobalAvailable.
-- Index it by colour name - Color["text_warning"] - for a { r, g, b, a, glow } table.
-- An unknown name logs a DebugError with a traceback and returns magenta, so a typo
-- shows up on screen instead of erroring.
-- Environment: addons + core
-- Versions: 8.00, 9.00
Color = {}


--- The global lookup of colour codes for use inside formatted text.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Registered with MakeGlobalAvailable. Index it by colour name to get the escape
-- prefix to concatenate in front of the text; an unknown name logs a DebugError with
-- a traceback and returns an empty string.
-- Available in the addons Lua environment only.
-- Environment: addons only
-- Versions: 8.00, 9.00
ColorText = {}


--- Persistent chat-window state: its layout version, frame position and size, and the buffer of
--- announcements it has received. Being a saved variable it already holds the previous
--- session's value when `chatwindow.lua` starts, which is why that file creates it with
--- `__CORE_CHAT_WINDOW = __CORE_CHAT_WINDOW or { ... }` and migrates older layouts by the
--- version field.
-- Source: ui\addons\ego_chatwindow\chatwindow.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_CHAT_WINDOW
---@field version number Data version; the addon migrates older layouts on load.
---@field x number Frame x offset.
---@field y number Frame y offset.
---@field size string Frame size preset.
---@field announcements table Announcement buffer.
__CORE_CHAT_WINDOW = {}


--- The debug log's stored contents: its layout version, the version at which it was last
--- cleared, and the entries themselves. Setting it to nil clears the log. `debuglog.lua` starts
--- the last-clear version at 0.0 deliberately, so the log is cleared once on first use rather
--- than needing that number maintained.
-- Source: ui\addons\ego_debuglog\debuglog.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_DEBUGLOG_LOG
---@field version number Data version.
---@field lastClear table { major, minor } of the last clear.
---@field data table The log entries.
__CORE_DEBUGLOG_LOG = {}


--- Persistent map editor settings, kept across UI reloads and game starts. Being a saved
--- variable it already holds the previous value when `menu_mapeditor.lua` runs, so that file
--- creates it with the `X = X or { ... }` idiom rather than a plain assignment.
-- Source: ui\addons\ego_detailmonitor\menu_mapeditor.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_DETAILMONITOR_MAPEDITOR
---@field opacity number Map-editor overlay opacity, 0-100.
__CORE_DETAILMONITOR_MAPEDITOR = {}


--- Persistent map filter settings, the ones kept across savegames.
-- Source: ui\addons\ego_detailmonitor\menu_map.lua
-- Saved variable: userdata
-- Keyed by filter name - layer_trade, layer_fight, trade_price_maxprice, think_alert
-- and so on - plus a version field the menu migrates on load.
-- Environment: addons only
-- Versions: 8.00, 9.00
__CORE_DETAILMONITOR_MAPFILTER = {}


--- Per-savegame map filter settings.
-- Source: ui\addons\ego_detailmonitor\menu_map.lua
-- Saved variable: savegame
-- Unlike __CORE_DETAILMONITOR_MAPFILTER this one travels with the save rather than the
-- player profile. Holds the trade_storage_* toggles and a version field.
-- Environment: addons only
-- Versions: 8.00, 9.00
__CORE_DETAILMONITOR_MAPFILTER_SAVE = {}


--- Persistent ship configuration menu settings, kept across UI reloads and game starts. Being a
--- saved variable it already holds the previous value when `menu_ship_configuration.lua` runs,
--- so that file creates it with the `X = X or { ... }` idiom rather than a plain assignment.
-- Source: ui\addons\ego_detailmonitor\menu_ship_configuration.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_DETAILMONITOR_SHIPBUILD
---@field version number Data version.
---@field showStats2 string Stats panel mode, e.g. limited.
---@field showStatsPaintMod2 string Paint-mod stats mode, e.g. hidden.
__CORE_DETAILMONITOR_SHIPBUILD = {}


--- Persistent station build menu settings, kept across UI reloads and game starts. Being a
--- saved variable it already holds the previous value when `menu_station_configuration.lua`
--- runs, so that file creates it with the `X = X or { ... }` idiom rather than a plain
--- assignment.
-- Source: ui\addons\ego_detailmonitor\menu_station_configuration.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_DETAILMONITOR_STATIONBUILD
---@field version number Data version.
---@field discreteanglestep number Rotation snap in degrees.
---@field moduleoverlap boolean Whether module overlap is allowed.
---@field environment boolean Whether the environment is shown.
---@field gizmo boolean Whether the placement gizmo is shown.
__CORE_DETAILMONITOR_STATIONBUILD = {}


--- Persistent "do not ask again" answers for user questions.
-- Source: ui\addons\ego_detailmonitor\menu_userquestion.lua, menu_followcamera.lua
-- Saved variable: userdata
-- Carries a version field plus one entry per remembered answer; ego_gameoptions resets
-- entries when the player clears them.
-- Environment: addons only
-- Versions: 8.00, 9.00
__CORE_DETAILMONITOR_USERQUESTION = {}


--- Whether the player has accepted the online privacy policy.
-- Source: ui\addons\ego_gameoptions\gameoptions.lua
-- Saved variable: userdata
-- Reset to false on logout.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
---@type boolean
__CORE_GAMEOPTIONS_PRIVACYPOLICY = false


--- Where the options menu was when it was last closed, so it can reopen there.
-- Source: ui\addons\ego_gameoptions\gameoptions.lua
-- Saved variable: userdata
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_GAMEOPTIONS_RESTOREINFO
---@field history table The menu's page history.
---@field optionParameter any Parameter of the option to restore.
---@field returnhistory any Cleared on init.
__CORE_GAMEOPTIONS_RESTOREINFO = {}


--- Cached venture configuration flags, refreshed when the online client starts.
-- Source: ui\addons\ego_gameoptions\gameoptions.lua
-- Saved variable: userdata
-- Each field mirrors OnlineGetVentureConfig(key).
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class __CORE_GAMEOPTIONS_VENTURECONFIG
---@field allow_validation any
---@field allow_update any
---@field allow_update_once any
__CORE_GAMEOPTIONS_VENTURECONFIG = {}


--- Which hints the player has already been shown, so none is offered twice. It is a
--- **savegame** variable rather than a userdata one - the record travels with the save, so a
--- new game starts with the hints fresh. `helptext.lua` creates it with the `X = X or { ... }`
--- idiom, because the engine has already restored it by the time that file runs.
-- Source: ui\addons\ego_helptext\helptext.lua
-- Saved variable: savegame
-- Environment: addons only
-- Versions: 8.00, 9.00
__CORE_HELPTEXT_DISPLAYEDHINTS = {}


--- Hints queued for display.
-- Source: ui\addons\ego_helptext\helptext.lua
-- Saved variable: savegame
-- Carries a version field the addon migrates.
-- Environment: addons only
-- Versions: 8.00, 9.00
__CORE_HELPTEXT_QUEUE = {}


--- The registry of globals that SetEGOGlobals copies into a Lua environment.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- MakeGlobalAvailable(name) stores _G[name] here; AddGlobalAccess(name, impl) assigns
-- _G[name] and then registers it. Adding a name here is what makes it reachable from
-- the addons Lua environment - see SetEGOGlobals.
-- Environment: addons only
-- Versions: 8.00, 9.00
__EGO_GLOBALS = {}


-- Global access to widget_fullscreen.widgetSystem.activateEditBox
-- Mapped from: widgetSystem.activateEditBox
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Activates a specific edit box widget, allowing it to receive text input.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param editBoxID any -- The edit box widget to activate.
---@param cursorPos? number -- Cursor position to place the caret at.
---@param shiftStartPos? number -- Selection anchor position.
function ActivateEditBox(editBoxID, cursorPos, shiftStartPos) end


-- Global access to widget_fullscreen.widgetSystem.activateSliderCellInput
-- Mapped from: widgetSystem.activateSliderCellInput
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Activates the input field of a slider cell, typically for manual value entry.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param sliderCell table -- The slider cell widget to activate.
function ActivateSliderCellInput(sliderCell) end


-- Adds a specified amount of an ammo ware to a component (e.g., a ship or station).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 4-5 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:106, ui/addons/ego_detailmonitor/menu_map.lua:4636
---@param componentID any -- The ID of the component to add ammo to.
---@param wareID string -- The ID of the ammo ware.
---@param amount number -- The integer amount of ammo to add.
---@param checkOnly? boolean -- (inferred) Return how much would fit without adding it.
---@param arg5? any -- Unidentified in 9.00 vanilla usage; always true.
function AddAmmo(componentID, wareID, amount, checkOnly, arg5) end


-- Adds a specified amount of a ware to a component's cargo bay.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4606
---@param componentID any -- The ID of the component to add cargo to.
---@param wareID string -- The ID of the ware.
---@param amount number -- The integer amount of the ware to add; may be negative to remove.
---@param arg4? any -- Unidentified in 9.00 vanilla usage; always true.
function AddCargo(componentID, wareID, amount, arg4) end


-- Exposes a Lua function to the global scope, making it accessible by its string name.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param name string -- The name to expose the function under.
---@param func function -- The Lua function to expose.
function AddGlobalAccess(name, func) end


--- Adds a ware to an inventory. The first argument is the component that receives it, and `nil`
--- means the player - which is what every vanilla call passes, whether crafting is depositing
--- what it made or the SETA cheat is handing over `inv_timewarp`. Vanilla passes three
--- arguments or four, so the last one is optional; what it selects is not identifiable from the
--- call sites.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3-4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:115, ui/addons/ego_detailmonitor/menu_map.lua:19163
---@param componentID any -- The ID of the component receiving the items; nil for the player.
---@param wareID any -- The ID of the ware to add.
---@param amount number -- The amount to add.
---@param arg4? any -- Unidentified in 9.00 vanilla usage; always true.
function AddInventory(componentID, wareID, amount, arg4) end


-- Unlocks a specific encyclopedia entry or other knowledge item for the player.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 70 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:300, ui/addons/ego_detailmonitor/menu_diplomacy.lua:1856
---@param category string -- The category of the item (e.g., "wares", "factions").
---@param itemID string -- The ID of the item to unlock.
function AddKnownItem(category, itemID) end


--- Grants a licence to a faction. The three arguments are the faction that receives it -
--- `"player"` in the only vanilla call - the licence type, and the faction the licence is with.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_trader_blueprintsorlicences.lua:600
---@param factionID string -- The ID of the faction receiving the licence.
---@param licenceID string -- The ID of the licence to grant.
---@param otherFactionID? string -- The faction the licence applies to.
function AddLicence(factionID, licenceID, otherFactionID) end


--- Writes an entry into the player's logbook under a category. Vanilla passes five arguments
--- where the declaration names three plus a vararg tail, so the entry carries more than a title
--- and a text - the help text menu logs a tip with `nil` for the text and a string in the fifth
--- position.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 5 arguments
-- Seen at: ui/addons/ego_helptext/helptext.lua:152
---@param category string -- The logbook category (e.g., "general", "upkeep").
---@param title string -- The title of the log entry.
---@param text string -- The main content of the log entry.
---@param ... any -- Optional additional parameters for formatting or context.
function AddLogbookEntry(category, title, text, ...) end


--- Adds money to the player's account, and a negative amount takes it away. No vanilla code
--- calls it - the menus move money with `TransferPlayerMoneyTo` and `TransferMoneyToPlayer`,
--- which name a counterparty.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param amount number -- The amount of money to add. Can be negative.
function AddMoney(amount) end


--- Queues a trade offer on a ship. `amount` is always positive - the map menu negates its own
--- signed amount before passing it - and `immediate` puts the trade at the front rather than
--- the back. Vanilla passes four arguments from the map and five from the interact menu, so the
--- last one is optional.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 4-5 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3637, ui/addons/ego_interactmenu/menu_interactmenu.lua:985
---@param tradeOfferID any -- The ID of the trade offer.
---@param shipID any -- The ID of the ship performing the trade.
---@param amount number -- The amount of the ware to trade.
---@param immediate? boolean -- Whether the trade should be executed immediately.
---@param fromTrader? boolean -- (inferred) Whether the trade is initiated by a trader.
function AddTradeToShipQueue(tradeOfferID, shipID, amount, immediate, fromTrader) end


--- Raises a UI event that the game and any listening Mission Director code can react to - the
--- menu name, the event name, and optionally more values. Vanilla uses it to announce what the
--- player is doing (`AddUITriggeredEvent(menu.name, mode, "on")`), and it is the usual way a
--- mod tells MD that its own UI did something. It became available in the core Lua environment
--- as well in 9.00.
-- Environment: addons + core
-- Versions: 8.00 (addons), 9.00 (addons + core)
-- Usage: confirmed - 122 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:381, ui/addons/ego_detailmonitor/menu_diplomacy.lua:662
---@param menuName string -- The name of the menu or UI area where the event occurred.
---@param eventName string -- The name of the event.
---@param ... any -- Optional additional data associated with the event.
function AddUITriggeredEvent(menuName, eventName, ...) end


--- Adds units - drones, marines - to a component, by unit macro and amount. No vanilla code
--- calls it; `RemoveAmmo` is the one the ware exchange uses on the way out.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param componentID any -- The ID of the component to add units to.
---@param macro string -- The macro name of the unit to add.
---@param amount number -- The number of units to add.
function AddUnits(componentID, macro, amount) end


-- Adjusts a multi-line string, likely for formatting or word wrapping.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6285
---@param text string -- The string to adjust.
---@return string -- The adjusted string.
function AdjustMultilineString(text) end

-- This function is likely called by the engine when AI-related ranges are updated. No direct Lua call sites were found.
-- Its parameters and purpose are inferred from its name.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param component any -- The component whose AI range was updated. (inferred)
---@param range number -- The new range value. (inferred)
function AIRangeUpdated(component, range) end


--- The Anark data port, the runtime's data-table interface.
--- The getTable/getRow/getColumn/getValue/setValue family works against it.
--- No vanilla code touches it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla reference
---@type userdata
AKDataPort = nil


--- The Anark gameplan object, the runtime's presentation state machine.
--- fireGameplanEvent raises events on it. No vanilla code touches it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla reference
---@type userdata
AKGameplan = nil


-- Called when the "Attack Enemies" setting is changed for a ship or fleet.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param controllableID any -- The ID of the controllable entity.
---@param enabled boolean -- The new state of the setting.
function AttackEnemySettingChanged(controllableID, enabled) end


--- Computes the bounding box of a scene element.
--- Sibling of calculateGlobalTransform. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@param ... any Receives the box; the exact form is unverified.
---@return any box
function calculateBoundingBox(element, ...) end


--- Returns a scene element's opacity with every ancestor's opacity folded in.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@return number opacity
function calculateGlobalOpacity(element) end


--- Runs the handlers registered for a named event, with one argument. `widget_fullscreen.lua`
--- calls it to dispatch an event to everything that registered through `RegisterEvent`.
-- Global access to widget_fullscreen.callEventScripts
-- Mapped from: widgetSystem.callEventScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param eventName string -- The name of the event to trigger.
---@param argument1 any -- An argument to pass to the event scripts.
function CallEventScripts(eventName, argument1) end


--- Runs the handlers registered for a hotkey action. No vanilla code calls it: the engine is
--- what raises hotkeys, and menu code registers into it with `SetScript("onHotkey", ...)`.
-- Global access to widget_fullscreen.callHotkeyScripts
-- Mapped from: widgetSystem.callHotkeyScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param action string -- The hotkey action that was triggered.
function CallHotkeyScripts(action) end


--- Runs the handlers registered for tab scrolling, in a direction. `widget_fullscreen.lua`
--- calls it from its own left and right handlers, and menu code registers into it with
--- `Helper.setTabScrollCallback`.
-- Global access to widget_fullscreen.callTabScrollScripts
-- Mapped from: widgetSystem.callTabScrollScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param direction string -- The direction of the scroll ("left" or "right").
function CallTabScrollScripts(direction) end


-- Global access to widget_fullscreen.callUpdateScripts
-- Mapped from: widgetSystem.callUpdateScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Calls all registered update scripts, typically on each frame.
-- Environment: addons only
-- Versions: 8.00, 9.00
function CallUpdateScripts() end


-- Global access to widget_fullscreen.callWidgetEventScripts
-- Mapped from: widgetSystem.callWidgetEventScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Dispatches an event to a specific widget's registered event handlers.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param widgetID table -- The widget to which the event is sent.
---@param eventName string -- The name of the event (e.g., "onClick", "onTextChanged").
---@param ... any -- Arguments to pass to the widget's event handler.
function CallWidgetEventScripts(widgetID, eventName, ...) end


-- Checks if a controllable can be a subordinate to a commander.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param subordinateID any -- The ID of the potential subordinate.
---@param commanderID any -- The ID of the potential commander.
---@return boolean -- True if the assignment is possible, false otherwise.
function CanBeSubordinateOf(subordinateID, commanderID) end


--- Cancels the running player conversation. No vanilla code calls it; the menus end a
--- conversation by closing themselves, and `UnsuspendConversation` is what they do call around
--- one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function CancelConversation() end


-- Global access to widget_fullscreen.widgetSystem.cancelEditBoxInput
-- Mapped from: widgetSystem.cancelEditBoxInput
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Cancels the current input action in an edit box, reverting any changes.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param editBoxID table -- The edit box widget to cancel input for.
function CancelEditBoxInput(editBoxID) end


-- Checks if a trade is possible between a trade offer and a ship.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 3-4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21382, ui/addons/ego_detailmonitor/menu_map.lua:21403
---@param tradeOfferID any -- The ID of the trade offer.
---@param shipID any -- The ID of the ship.
---@param amount number -- The amount to trade.
---@param isMultiTrade? boolean -- (inferred) Whether this is part of a multi-trade sequence.
---@return boolean -- True if the trade is possible.
function CanTradeWith(tradeOfferID, shipID, amount, isMultiTrade) end


-- Checks if the player has the necessary access to view live data for a component (e.g., video feed from a station).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6210
---@param componentID any -- The ID of the component.
---@return boolean -- True if live data can be viewed.
function CanViewLiveData(componentID) end


-- Checks for regressions or issues in the current input profile settings.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:5961
---@return boolean -- True if a regression is detected.
function CheckInputProfileRegression() end


-- Checks if a component has a suitable transport type for a given ware (e.g., solid, liquid, container).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21868, ui/addons/ego_detailmonitor/menu_station_overview.lua:497
---@param componentID any -- The ID of the component (e.g., a ship or station).
---@param wareID string -- The ID of the ware to check.
---@return boolean -- True if the component can transport the ware.
function CheckSuitableTransportType(componentID, wareID) end


--- Claims the rewards of completed ventures. No vanilla code calls it - the map menu clears
--- them with `OnlineClearLogbookRewards` instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function ClaimVentureRewards() end


-- Clears a previously set stock limit override for a specific ware in a container.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_station_overview.lua:2423, ui/addons/ego_detailmonitorhelper/helper.lua:12448
---@param containerID any -- The ID of the container.
---@param wareID string -- The ID of the ware.
function ClearContainerStockLimitOverride(containerID, wareID) end


-- Clears a previously set ware price override for a specific ware in a container.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:5050, ui/addons/ego_detailmonitor/menu_station_overview.lua:2417
---@param containerID any -- The ID of the container.
---@param wareID string -- The ID of the ware.
---@param isBuyOverride boolean -- True to clear the buy price, false to clear the sell price.
function ClearContainerWarePriceOverride(containerID, wareID, isBuyOverride) end


--- Clears the error log. No vanilla code calls it, though `GetNumErrors` and `GetError` read
--- the same log.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function ClearErrors() end


--- Clears logbook entries of one category, or of every category when the category is nil. The
--- first argument is an age and vanilla always passes 0, which clears them all regardless of
--- when they were written.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:847
---@param age number -- (inferred) The age of entries to clear (e.g., 0 for all).
---@param category string|nil -- The category to clear, or nil for all categories.
function ClearLogbook(age, category) end


--- Clears a ship's queued trades. No vanilla code calls it; the map menu removes trades one at
--- a time instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param shipID any -- The ID of the ship whose trade queue should be cleared.
function ClearTradeQueue(shipID) end


--- Clips a line to a rectangle and returns the clipped endpoints. It returns nothing when the
--- line falls entirely outside, which is what `widget_fullscreen.lua` tests for - `if not x0
--- then` - rather than clamping the coordinates itself.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 8 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:7105
---@param x0 number -- The starting x-coordinate of the line.
---@param y0 number -- The starting y-coordinate of the line.
---@param x1 number -- The ending x-coordinate of the line.
---@param y1 number -- The ending y-coordinate of the line.
---@param xmin number -- The minimum x-coordinate of the boundary.
---@param ymin number -- The minimum y-coordinate of the boundary.
---@param xmax number -- The maximum x-coordinate of the boundary.
---@param ymax number -- The maximum y-coordinate of the boundary.
---@return number, number, number, number -- The clipped line coordinates (x0, y0, x1, y1).
function ClipLine(x0, y0, x1, y1, xmin, ymin, xmax, ymax) end


--- Closes an open dropdown's option list. `helper.lua` reaches the dropdown widget with
--- `GetCellContent` first, so what it takes is the widget, not a table position.
-- Global access to widget_fullscreen.widgetSystem.closeDropDownOptions
-- Mapped from: widgetSystem.closeDropDownOptions
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param dropdownID table -- The dropdown widget to close.
function CloseDropDownOptions(dropdownID) end


--- Closes one frame of the current view. The eight flags after the frame repeat what the view
--- was created with - player controls, animation, mini widget system, HUD, crosshair, ticker,
--- blur, panel mode - because closing a frame re-evaluates all of them for what stays on
--- screen.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 9 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:74
---@param frameID any -- The ID of the frame to close.
---@param hasPlayerControls boolean
---@param startAnimation boolean
---@param useMiniWidgetSystem boolean
---@param keepHUDVisible boolean
---@param keepCrosshairVisible boolean
---@param showTickerPermanently boolean
---@param blurBackground? boolean
---@param usePanelMode? boolean
function CloseFrame(frameID, hasPlayerControls, startAnimation, useMiniWidgetSystem, keepHUDVisible, keepCrosshairVisible, showTickerPermanently, blurBackground, usePanelMode) end


--- Closes any open menus, as a click outside them would. The core target system calls it when
--- the player clicks in space to pick a target, so selecting something out there also dismisses
--- what was on screen.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1276
function CloseMenusUponMouseClick() end


--- Reports whether two jump routes are the same. No vanilla code calls it, nor `FindJumpRoute`
--- which would produce the routes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param routeA any -- The first jump route.
---@param routeB any -- The second jump route.
---@return boolean -- True if the routes are identical.
function CompareJumpRoute(routeA, routeB) end


--- The widget system's configuration table.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Created as "config = config or {}" and then filled with the sizing, colour and
-- animation constants the widget system draws with (config.nativePresentationWidth,
-- config.flowchart, config.statusbar, ...). Several core and addon files declare
-- their own file-scope config table of the same name, which shadows this one.
-- Environment: addons only
-- Versions: 8.00, 9.00
config = {}


-- Global access to widget_fullscreen.widgetSystem.confirmEditBoxInput
-- Mapped from: widgetSystem.confirmEditBoxInput
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Confirms the input in an edit box, triggering its 'onConfirmed' event.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param editBoxID table -- The edit box widget to confirm.
function ConfirmEditBoxInput(editBoxID) end


-- Converts a game object or ID to its 64-bit integer representation.
-- This is often required for passing IDs to C-level engine functions.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 287 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1648, ui/addons/ego_detailmonitor/menu_docked.lua:746
---@param id any -- The component, object, or ID to convert.
---@return integer64 -- The 64-bit integer representation of the ID.
function ConvertIDTo64Bit(id) end


-- Formats a number into a localized string with various options.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 279 vanilla call sites, 2-6 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:2167, ui/addons/ego_detailmonitor/menu_docked.lua:725
---@param number number -- The number to format.
---@param useGroupingSeparator? boolean -- Whether to use thousand separators (e.g., 1,000). (inferred, default: false)
---@param padZeros? integer -- The number of digits to pad with leading zeros. (inferred, default: 0)
---@param forceSign? boolean -- Whether to always show a sign (+/-). (inferred, default: false)
---@param allowFloat? boolean -- Whether to allow floating point numbers. (inferred, default: false)
---@param useShortScale? boolean -- Whether to use short scale abbreviations (k, M, B). (inferred, default: false)
---@return string -- The formatted number as a string.
function ConvertIntegerString(number, useGroupingSeparator, padZeros, forceSign, allowFloat, useShortScale) end


-- Converts a mission difficulty level into a localized display string and a mouseover tooltip.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18405, ui/addons/ego_detailmonitor/menu_missionbriefing.lua:336
---@param difficulty number|string -- The difficulty level of the mission (e.g., 1, "easy", "hard").
---@return string localizedName -- The localized string for the difficulty (e.g., "Easy", "Very Hard").
---@return string mouseOverText -- The tooltip text for the difficulty.
function ConvertMissionLevelString(difficulty) end


--- Formats an amount as money in the player's language, and is what every price in the UI goes
--- through. Vanilla's usual call is `ConvertMoneyString(value, false, true, 0, true)` - no
--- forced sign, thousands separators, no decimals, coloured - followed by `ReadText(1001, 101)`
--- for the currency name, which this call does not add.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 134 vanilla call sites, 3-6 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:602, ui/addons/ego_detailmonitor/menu_diplomacy.lua:1772
---@param money number -- The amount of money to format.
---@param showSign? boolean -- Whether to always show a sign (+/-). (inferred, default: false)
---@param useGrouping? boolean -- Whether to use thousand separators. (inferred, default: true)
---@param accuracy? integer -- The number of decimal places to show. (inferred, default: 0)
---@param colorize? boolean -- Whether to apply color based on the value (e.g., red for negative). (inferred, default: false)
---@param ignoreSign? boolean -- Whether to ignore the sign for formatting. (inferred, default: false)
---@return string -- The formatted currency string.
function ConvertMoneyString(money, showSign, useGrouping, accuracy, colorize, ignoreSign) end


-- Converts a string representation of an ID into a 64-bit integer ID.
-- This is often used when an ID has been converted to a string and needs to be passed back to an engine function.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 355 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:487, ui/addons/ego_detailmonitor/menu_diplomacy.lua:1657
---@param idString string -- The string to convert.
---@return integer64 -- The resulting 64-bit integer ID.
function ConvertStringTo64Bit(idString) end


-- Converts a string representation of an ID into a Lua-usable object ID.
-- This is primarily used when setting parameters for ship orders.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 164 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:344, ui/addons/ego_detailmonitor/menu_diplomacy.lua:448
---@param idString string -- The string representation of the game ID.
---@return any -- The Lua object ID, likely a specific userdata type.
function ConvertStringToLuaID(idString) end


-- Formats a time value in seconds into a human-readable string.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 63 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1524, ui/addons/ego_detailmonitor/menu_docked.lua:1343
---@param time number -- The time in seconds to format.
---@param format? string -- A format string (e.g., "%h:%M:%S", "%T").
---@param isFloat? boolean -- Treat the time as a float for formatting, allowing fractional seconds. (inferred)
---@param accuracy? integer -- The number of decimal places to show if isFloat is true. (inferred)
---@return string -- The formatted time string.
function ConvertTimeString(time, format, isFloat, accuracy) end


-- Copies the default order parameters for a component to be used in the planning map.
-- This likely prepares an object's default command (e.g., "Attack") with its parameters for modification in the UI.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:10480
---@param component any -- The component whose default order parameters are to be copied.
---@return nil
function CopyDefaultOrderParamsForPlanning(component) end


--- Converts a graph axis property into the descriptor the engine expects.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- Internal to the helper; it is a global only because it is declared at file scope.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param axisproperty table The axis property, with startvalue, endvalue, granularity,
--- offset, grid, color, gridcolor, glowfactor and unittext.
---@return table info
function createAxisPropertyInfo(axisproperty) end


-- Creates a text element within a colored box, often used for headers or distinct labels in tables.
-- Mapped from: widgetSystem.createBoxText (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:5646
---@param text string|table -- The text to display, or a descriptor table for the widget.
---@param properties? table -- A table of properties for the widget (e.g., { width, fontsize, boxColor, halign, mouseOverText }).
---@return table widget -- The created box text widget.
function CreateBoxText(text, properties) end


--- Builds a button widget and returns its descriptor. One table carries everything - icon,
--- colours, size, mouse-over text and the click handler. Menu code normally goes through
--- `Helper.createButton`, but the help text menu builds one directly and keeps the descriptor
--- to release later.
-- Mapped from: widgetSystem.createButton (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:420, ui/addons/ego_detailmonitorhelper/helper.lua:2047
---@param properties? table -- A table of properties for the button (e.g., { active, mouseOverText, icon, onClick, height, width }).
---@return table widget -- The created button widget.
function CreateButton(properties) end


--- Builds a checkbox widget and returns its descriptor. `helper.lua`, the only vanilla caller,
--- passes a single descriptor table carrying the state and the properties together; menu code
--- reaches it through `Helper.createCheckBox`.
-- Mapped from: widgetSystem.createCheckBox (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:6375
---@param checked boolean|function -- The initial state of the checkbox, or a function that returns the state.
---@param properties? table -- A table of properties for the checkbox (e.g., { active, height, width, mouseOverText, onCheckChanged }).
---@return table widget -- The created checkbox widget.
function CreateCheckBox(checked, properties) end


-- Creates a descriptor table for a cutscene, specifying the cutscene to play and any required reference objects.
-- The resulting descriptor is used to play in-engine cutscenes.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 15 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2389, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4464
---@param cutsceneKey string -- The key/name of the cutscene to play (e.g., "OrbitIndefinitelySlow").
---@param refObjects table -- A table of reference objects for the cutscene, with keys like 'targetobject' or 'npcref'.
---@return table descriptor -- The created cutscene descriptor table.
function CreateCutsceneDescriptor(cutsceneKey, refObjects) end


--- Builds a dropdown widget and returns its descriptor. `helper.lua`, the only vanilla caller,
--- passes a single descriptor table holding the options and the properties together; menu code
--- goes through `Helper.createDropDown`.
-- Mapped from: widgetSystem.createDropDown (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2180
---@param options table -- A table of option entries to populate the dropdown. Each entry is a table (e.g., { id, text, mouseOverText }).
---@param properties? table -- A table of properties for the dropdown (e.g., { startOption, active, height, onOptionChanged }).
---@return table widget -- The created dropdown widget.
function CreateDropDown(options, properties) end


--- Builds an edit box widget and returns its descriptor. The single descriptor table carries
--- the default text, whether the text is hidden, and the changed and confirmed handlers; menu
--- code goes through `Helper.createEditBox`.
-- Mapped from: widgetSystem.createEditBox (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2224
---@param properties? table -- A table of properties for the edit box (e.g., { description, defaultText, textHidden, onTextChanged, onConfirmed }).
---@return table widget -- The created edit box widget.
function CreateEditBox(properties) end


--- Builds a flowchart widget and returns its descriptor. The single descriptor table carries
--- everything - nodes, edges and layout; `Helper.createFlowchart` assembles it, and no menu
--- calls this directly.
-- Mapped from: widgetSystem.createFlowchart (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7169
---@param descriptor table -- A descriptor table containing all properties for the flowchart (nodes, edges, layout, etc.).
---@return table widget -- The created flowchart widget.
function CreateFlowchart(descriptor) end


--- Builds one edge of a flowchart - the connector between two nodes - and returns its
--- descriptor. As with the rest of the flowchart family, the single descriptor table carries
--- everything and `helper.lua` assembles it.
-- Mapped from: widgetSystem.createFlowchartEdge (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7660
---@param descriptor table -- A descriptor table containing properties for the edge (e.g., source and target nodes).
---@return table widget -- The created flowchart edge widget.
function CreateFlowchartEdge(descriptor) end


--- Builds one node of a flowchart and returns its descriptor. As with the other widget
--- constructors, the single descriptor table carries everything, and `helper.lua` assembles it.
-- Mapped from: widgetSystem.createFlowchartNode (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7379
---@param descriptor table -- A descriptor table containing properties for the node (e.g., text, position, size, content).
---@return table widget -- The created flowchart node widget.
function CreateFlowchartNode(descriptor) end


-- Creates a font string descriptor for use in other UI elements.
-- Mapped from: widgetSystem.createFontString (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:418, ui/addons/ego_detailmonitorhelper/helper.lua:905
---@param text string|table -- The text to display, or a full descriptor table for the font string.
---@param properties? table -- A table of properties for the font string (e.g., { font, fontsize, color, halign }).
---@return table descriptor -- The created font string descriptor.
function CreateFontString(text, properties) end


-- Creates a UI frame widget, which is a container for other UI elements. (Legacy version)
-- Note: Most code uses Helper.createFrameHandle() or CreateFrame2() instead.
-- Mapped from: widgetSystem.createFrame (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 10-11 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:786, ui/addons/ego_debuglog/debuglog.lua:805
---@param children table -- A table of child widgets to add to the frame.
---@param layer? string -- The rendering layer for the frame.
---@param background? string -- The background style or texture.
---@param name? any -- An optional name for the frame.
---@param parent? any -- The parent widget.
---@param width? number -- The width of the frame.
---@param height? number -- The height of the frame.
---@param x? number -- The x-position of the frame.
---@param y? number -- The y-position of the frame.
---@param properties? table -- An additional table of properties.
---@param arg11? any -- Unidentified in 9.00 vanilla usage; a standard-button table such as { close = true }.
---@return table widget -- The created frame widget.
function CreateFrame(children, layer, background, name, parent, width, height, x, y, properties, arg11) end


--- Builds a frame - the box a menu's tables and widgets live in - and returns its descriptor.
--- One table carries the children, the layer, the size and the offset.
--- `Helper.createFrameHandle` wraps it for menu code; the help text menu builds one directly.
-- Mapped from: widgetSystem.createFrame2 (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4102, ui/addons/ego_helptext/helptext.lua:410
---@param descriptor table -- A descriptor table containing all properties for the frame (e.g., { children, layer, width, height, x, y }).
---@return table widget -- The created frame widget.
function CreateFrame2(descriptor) end


--- Converts a frame texture property into the descriptor the engine expects.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- Internal to the helper; it is a global only because it is declared at file scope.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param textureproperty table The texture property, with icon, color, width, height,
--- the rotation* fields and the initialScaleFactor/scaleDuration pair.
---@return table info
function createFrameTexturePropertyInfo(textureproperty) end


--- Builds a graph widget and returns its descriptor. The single descriptor table carries the
--- data and the scaling; `Helper.createGraph` assembles it, and `SelectGraphDataPoint` selects
--- a point on the finished widget.
-- Mapped from: widgetSystem.createGraph (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:6598
---@param properties table -- A table of properties for the graph (e.g., { height, scaling, data }).
---@return table widget -- The created graph widget.
function CreateGraph(properties) end


--- Builds an icon widget and returns its descriptor. `helper.lua`, the only vanilla caller,
--- passes a single descriptor table that already carries the icon and its properties together.
-- Mapped from: widgetSystem.createIcon (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:5741
---@param icon string -- The ID or name of the icon texture to display.
---@param properties? table -- A table of properties for the icon (e.g., { width, height, color, mouseOverText }).
---@return table widget -- The created icon widget.
function CreateIcon(icon, properties) end


-- Creates a descriptor for a player interaction. (Legacy)
-- Note: CreateInteractionDescriptor2 is now preferred.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param interaction string -- The name of the interaction (e.g., "PlayerDockShip").
---@return any -- The interaction descriptor.
function CreateInteractionDescriptor(interaction) end


-- Creates a descriptor for a player interaction with a specific component.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:1046
---@param interaction string -- The name of the interaction (e.g., "PlayerDockShip").
---@param component any -- The component that is the target of the interaction.
---@return any -- The interaction descriptor.
function CreateInteractionDescriptor2(interaction, component) end


-- Creates a copy of a game object within a special 3D rendering environment (a "presentation cluster") for UI display.
-- Used for things like the encyclopedia and ship previews.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2392, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4468
---@param object any -- The game object to display.
---@param clusterMacro string -- The macro for the presentation cluster environment (e.g., "cluster_black_wlight_bg_macro").
---@return table cluster -- The created presentation cluster.
---@return any presentationObject -- The handle to the new object inside the cluster.
function CreateObjectInPresentationCluster(object, clusterMacro) end


--- Builds the help-overlay descriptor for a widget, or nil when it has no overlay text.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- Internal to the helper; it is a global only because it is declared at file scope.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param widget table The widget whose helpOverlay* properties are read.
---@return table|nil info
function createOverlayPropertyInfo(widget) end


-- Creates a render target widget, which is an area in the UI used to display 3D objects or scenes.
-- Mapped from: widgetSystem.createRenderTarget (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 10 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4665
---@param width number -- Width of the render target.
---@param height number -- Height of the render target.
---@param x? number -- X position.
---@param y? number -- Y position.
---@param alpha? number -- Alpha value.
---@param mouseOverText? string -- Mouse-over text.
---@param helpOverlay? any -- Help overlay descriptor.
---@param clear? boolean -- Whether the target is cleared before drawing.
---@param startNoise? boolean -- Whether the target starts with the noise effect.
---@param frameBorder? any -- Frame border descriptor.
---@return table widget -- The created render target widget.
function CreateRenderTarget(width, height, x, y, alpha, mouseOverText, helpOverlay, clear, startNoise, frameBorder) end


--- Builds the combined shield and hull bar and returns its descriptor. `helper.lua`, the only
--- vanilla caller, passes a single descriptor table with the size filled in, so the separate
--- shield and hull parameters here are the older shape.
-- Mapped from: widgetSystem.createShieldHullBar (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:5950
---@param shield number|table -- The shield percentage, or a full descriptor table.
---@param hull? number -- The current hull percentage (0-100).
---@param properties? table -- A table of properties for the bar (e.g., { width, height, scaling }).
---@return table widget -- The created shield/hull bar widget.
function CreateShieldHullBar(shield, hull, properties) end


-- Creates a data sink for the target element system, used to manage HUD target indicators.
-- Source: Game Engine
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1712
---@param sinkName string -- The unique name for the sink (e.g., "explicittarget", "poi").
---@param numElements integer|table -- The maximum number of elements, or the position elements themselves.
---@param elements? table -- The target elements managed by the sink.
---@return nil
function CreateSink(sinkName, numElements, elements) end


-- Creates a slider cell widget, used for selecting a numerical value within a range.
-- Mapped from: widgetSystem.createSliderCell (inferred)
-- Source: ui/widget/lua/widget_fullscreen.lua (inferred)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2331
---@param properties table -- A table of properties for the slider (e.g., { min, max, start, step, onValueChanged }).
---@return table widget -- The created slider cell widget.
function CreateSliderCell(properties) end


-- Creates a data source for the target element system, used to provide targetable objects.
-- Source: Game Engine
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 12 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:1788
---@param sourceName string -- The unique name for the source (e.g., "basic", "missionobjective").
---@return nil
function CreateSource(sourceName) end


---@meta
---@class StatusBarProperties
---@field current number
---@field start number
---@field max number
---@field cellBGColor? any
---@field valueColor? any
---@field posChangeColor? any
---@field negChangeColor? any
---@field markerColor? any
---@field width? number
---@field x? number
---@field scaling? boolean
---@field height? number

--- Builds a status bar widget from a property table and returns its descriptor. `helper.lua`
--- fills the size in and hands the whole descriptor over as the single argument; menu code
--- reaches it through `Helper.createStatusBar` rather than directly.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:6452
---@param properties StatusBarProperties
---@return any
function CreateStatusBar(properties) end


---@meta
---@class InitialSelection
---@field selectedcol? integer

--- Builds a table widget and returns its descriptor. Only the first two arguments are ever
--- required - vanilla calls it with anything from 8 to all 22 - so everything from the column
--- widths on has a default. Almost no mod needs it directly: `Helper.createTable` wraps it and
--- is what menu code uses.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 8-22 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:784, ui/addons/ego_debuglog/debuglog.lua:799
---@param header table|string
---@param tableContent table
---@param columnWidths table|number
---@param columnWidthPercent? boolean
---@param borderEnabled? boolean
---@param tabOrder? any
---@param skipTabChange? boolean
---@param defaultInteractiveObject? boolean
---@param numFixedRows? integer
---@param offsetX? number
---@param offsetY? number
---@param maxHeight? number
---@param initialSelection? InitialSelection|table
---@param wraparound? boolean
---@param highlightMode? any
---@param multiselect? boolean
---@param backgroundID? any
---@param backgroundColor? any
---@param helpOverlay? any
---@param backgroundPadding? any
---@param rowGroups? table
---@param borderID? any
---@return any
function CreateTable(header, tableContent, columnWidths, columnWidthPercent, borderEnabled, tabOrder, skipTabChange, defaultInteractiveObject, numFixedRows, offsetX, offsetY, maxHeight, initialSelection, wraparound, highlightMode, multiselect, backgroundID, backgroundColor, helpOverlay, backgroundPadding, rowGroups, borderID) end


--- Builds a view - the container every menu frame lives in - and returns its descriptor, which
--- then goes to `DisplayView`. The nine flags after the frame descriptors decide how the view
--- behaves while it is up: whether it takes interaction exclusively, closes on a click it does
--- not handle, uses the mini widget system, animates in, keeps the HUD, the crosshair or the
--- ticker visible, blurs what is behind it, and whether it is a panel. The view helper is the
--- only vanilla caller and passes all ten.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 10 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:39
---@param frameDescriptors table
---@param exclusiveInteractions boolean
---@param closeOnUnhandledClick boolean
---@param useMiniWidgetSystem boolean
---@param startAnimation boolean
---@param keepHUDVisible boolean
---@param keepCrosshairVisible boolean
---@param showTickerPermanently boolean
---@param blurBackground? boolean
---@param usePanelMode? boolean
---@return any
function CreateView(frameDescriptors, exclusiveInteractions, closeOnUnhandledClick, useMiniWidgetSystem, startAnimation, keepHUDVisible, keepCrosshairVisible, showTickerPermanently, blurBackground, usePanelMode) end


--- Deactivates a view. No vanilla code calls it, so nothing here confirms what it takes or how
--- it differs from `HideView`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param view any
function DeactivateView(view) end


--- The debug library's configuration, kept global so it can be changed at runtime.
-- Source: ui\addons\ego_debug\debug.lua
-- enabled is switched on automatically when IsLuaDebugInputEnabled() reports true.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class DebugConfig
---@field enabled boolean Whether debug input handling is active.
---@field reprRecursionDepth number Table recursion depth used by ToReprString.
---@field reprIndentStep string Indent added per level by ToReprString.
DebugConfig = {}


--- Writes a message into the game's error log - the UI's own way of reporting a problem, and
--- what the debug log menu reads back. It is the closest thing UI Lua has to a print that
--- survives, and vanilla uses it for everything from a failed engine call to invalid saved
--- data.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 449 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:445, ui/addons/ego_debuglog/debuglog.lua:973
---@param message string
function DebugError(message) end


--- Opens a profiling timer under a name, to be closed with `DebugProfileStop`. No vanilla code
--- calls either half.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param profileName string
function DebugProfileStart(profileName) end


--- Stops the profiling timer `DebugProfileStart` opened under that name. No vanilla code calls
--- either half.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param profileName string
function DebugProfileStop(profileName) end


--- Destroys a presentation cluster and everything drawn in it. Menus that show a rendered
--- object - the encyclopedia, the paint mod showcase - destroy their cluster on the way out,
--- after stopping the cutscene and releasing its descriptor.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2343, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4421
---@param cluster any
function DestroyPresentationCluster(cluster) end


--- Tells the game that the dialog menu has gone, the counterpart of `DialogMenuShown`. The core
--- dialog menu calls it while hiding itself, so whatever was waiting on the dialog can carry
--- on.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:680
function DialogMenuHidden() end


--- Tells the game that the dialog menu is now on screen, so anything waiting on it - a
--- conversation, for one - can proceed. The core dialog menu calls it once it has finished
--- displaying itself.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:878
function DialogMenuShown() end


--- Detaches the presentation from the camera effects, so its elements stay still while the
--- camera wobbles. Every core bar that has to read as fixed to the screen - the info bars, the
--- sub-channel bar - calls it while setting up.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/debugline.lua:124, ui/core/lua/infobar.lua:109
function DisableCameraEffectSync() end


--- Displays a view built by `CreateView` and returns its frames, one per layer. Vanilla wraps
--- the call in `table.pack`, because the number of returned frames depends on how many frame
--- descriptors the view was created with.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:40
---@param viewDescriptor any
---@param suppressDisplayErrors? boolean
---@param hasPlayerControls? boolean
---@return ... any
function DisplayView(viewDescriptor, suppressDisplayErrors, hasPlayerControls) end


--- Queues a circle to be drawn - it is a drawing command, not a widget, so nothing appears
--- until the queue is processed. `helper.lua` passes the same radius twice, which is what makes
--- it a circle rather than an ellipse. `HideCircle` and `HideAllCircles` take them off again.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param radiusZ number
---@param radiusY number
---@param centerX number
---@param centerY number
---@param z number
---@param color any
---@return any
function DrawCircle(radiusZ, radiusY, centerX, centerY, z, color) end


--- Queues a rectangle to be drawn - a drawing command rather than a widget, so nothing appears
--- until the queue is processed. Unlike `DrawTriangle` next to it, `helper.lua` passes the
--- angle straight through without converting it. `HideRect` and `HideAllRects` take them off
--- again.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param width number
---@param height number
---@param offsetX number
---@param offsetY number
---@param angle number
---@param z number
---@param color any
---@return any
function DrawRect(width, height, offsetX, offsetY, angle, z, color) end


--- Queues a triangle to be drawn - a drawing command rather than a widget, so nothing appears
--- until the queue is processed. The angle is in **radians**: `helper.lua` converts its own
--- degrees with `math.rad` before passing them.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param width number
---@param height number
---@param offsetX number
---@param offsetY number
---@param angle number
---@param z number
---@param color any
---@return any
function DrawTriangle(width, height, offsetX, offsetY, angle, z, color) end


--- Flushes the queued messages. The core target system calls it when a target sink goes away,
--- to clear the messages still waiting for it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:897
function DumpAllMessages() end


--- Discards every registered message sink. The core target system calls it when resetting
--- itself, right after `DumpAllMessageSources`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1717
function DumpAllMessageSinks() end


--- Discards every registered message source. The core target system calls it first when
--- resetting itself, before `DumpAllMessageSinks`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1716
function DumpAllMessageSources() end


--- Enables camera effect synchronisation. No vanilla code calls it, and the declaration carries
--- no parameters.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function EnableCameraEffectSync() end


--- Runs a debug command with one parameter. The chat window parses what the player typed into
--- command and parameter and passes both through.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:464
---@param command string
---@param parameter? string
function ExecuteDebugCommand(command, parameter) end


--- Reports whether a text entry exists, so a missing one can be handled instead of read. No
--- vanilla code calls it, and the declaration takes a single ID where `ReadText` needs a page
--- and an entry - so how the entry is addressed here is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param textID integer
---@return boolean
function ExistsText(textID) end


--- Returns a jump route between two sectors, up to `maxJumps` jumps. No vanilla code calls it,
--- so the shape of the returned table is unverified - the map menu builds its routes elsewhere.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param startSector any
---@param endSector any
---@param maxJumps integer
---@return table
function FindJumpRoute(startSector, endSector, maxJumps) end


--- Raises a named event on a scene element.
--- The counterpart of registerForEvent. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element to raise the event on.
---@param event string The event name.
---@param ... any Event arguments.
function fireEvent(element, event, ...) end


--- Raises a named event on a whole presentation rather than one element.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param presentation any The presentation.
---@param event string The event name.
---@param ... any Event arguments.
function fireEventOnPresentation(presentation, event, ...) end


--- Raises an event on the Anark gameplan.
--- See AKGameplan. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param event string The event name.
---@param ... any Event arguments.
function fireGameplanEvent(event, ...) end


--- Forces the Anark presentation to update now instead of on the next frame. The core target
--- system calls it when it has changed something the player has to see immediately.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:4238, ui/widget/lua/widget_fullscreen.lua:2788
function ForceAnarkUpdate() end


--- Reads one field of a component's account - `money` is what vanilla asks for. It returns
--- nothing when the component has no account, so every caller falls back with `or 0`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:14278, ui/addons/ego_detailmonitor/menu_playerinfo.lua:962
---@param component any
---@param key string
---@return any
function GetAccountData(component, key) end


--- Returns everything the HUD needs about the actions offered for a message, as eleven values:
--- the action name, whether it is possible, how many actions there are, whether the first is an
--- instant action, the display state, how many are shown, a pointer into them, and the
--- selected, active and inactive icons. Callers take only the ones they need - the crosshair
--- asks for the fourth to decide whether the target has an instant action at all.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1501, ui/core/lua/firstperson_crosshair.lua:173
---@param messageID any
---@return string, boolean, integer, boolean, any, any, integer, any, any, any, any
function GetActionInfo(messageID) end


--- Returns the frame that currently owns interaction. Menu code compares it against its own
--- frame before reacting to a row change, so a background menu does not play hover sounds for a
--- table the player is not actually in.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:27238, ui/addons/ego_detailmonitorhelper/helper.lua:966
---@return any
function GetActiveFrame() end


--- Returns the component the active guidance mission points at. No vanilla code calls it - the
--- map reads `GetActiveMission` and works from the mission.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any
function GetActiveGuidanceMissionComponent() end


--- Returns the mission currently set as active - the one the guidance shows. The map menu
--- compares each mission against it to mark the active row.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18698
---@return any
function GetActiveMission() end


--- Returns the graphics adapter in use. The options menu pairs it with `GetPossibleAdapters` to
--- build the dropdown and preselect the current entry.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6935
---@return any
function GetAdapterOption() end


--- Returns the aim assist level on the engine's scale, which starts at zero. The options menu
--- adds one to turn it into a dropdown index, the same offset `SetAimAssistOption` takes back
--- off.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6557
---@return number
function GetAimAssistOption() end


--- Returns the alignment of a text widget. `widget_fullscreen.lua` reads it with `GetWordWrap`
--- and the width when it measures a text for layout.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:13142
---@param fontStringID any
---@return any
function GetAlignment(fontStringID) end


--- Returns the whole commander chain above a controllable, not just the one directly above it -
--- the map menu walks the list to find how far up a subordinate sits from a given commander.
--- `GetCommander` returns only the immediate one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:7621
---@param controllable any
---@return table
function GetAllCommanders(controllable) end


--- Returns the settings of every installed extension as one table. The options menu reads it
--- when it builds the extensions page and clears its own changed flag at the same time.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2979
---@return table
function GetAllExtensionSettings() end


--- Returns every statistics ID the game keeps, as a flat list. The player information menu
--- walks it to build the statistics page; the value behind an ID comes from `GetStatValue`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:2525
---@return table
function GetAllStatIDs() end


--- Returns the weapons of a component as a table. The target monitor reads it for the weapon
--- systems block, next to the check that weapon information is unlocked for the player at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:1199
---@param component any
---@return table
function GetAllWeapons(component) end


--- Returns what a container's ammunition will be once its queued trade orders have run, rather
--- than what it holds now - the ammunition counterpart of `GetCargoAfterTradeOrders`, and the
--- map menu reads the two together.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21341
---@param container any
---@return table
function GetAmmoCountAfterTradeOrders(container) end


--- Returns the object the autopilot is flying to, or nothing when the autopilot is off. The map
--- menu reads it next to the softtarget to decide what to mark.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6734
---@return any
function GetAutoPilotTarget() end


--- Returns whether autoroll is on. The options menu turns it straight into the On/Off label of
--- the row whose callback toggles it with `SetAutorollOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2029
---@return boolean
function GetAutorollOption() end


--- Returns whether autosaving is on, and pairs with `SetAutosaveOption` the same way the other
--- option rows do.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1996
---@return boolean
function GetAutosaveOption() end


--- Returns the bonus content entries as a list. The options menu only asks for it when
--- `IsSteamworksEnabled` is true, and walks the result to build the page.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:10474
---@return table
function GetBonusContentData() end


--- Returns whether boost is set to toggle rather than to hold, and pairs with
--- `SetBoostToggleOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2045
---@return boolean
function GetBoostToggleOption() end


--- Returns a table of budget data for a station. No vanilla code calls it, so neither the shape
--- of that table nor what counts as the station argument is confirmed here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param station any
---@return table
function GetBudgetData(station) end


--- Returns the build anchor of a component, or nothing when it has none. The target monitor
--- asks for it once it knows the component is a container, to show what is being built there.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:869
---@param component any
---@return any
function GetBuildAnchor(component) end


--- Returns how long a build order will take at a container. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param containerid any
---@param order any
---@return number
function GetBuildDuration(containerid, order) end


--- Returns the builder ship macros matching a set of tags and a race. No vanilla code calls it,
--- so neither the form of `tags` nor the shape of the returned table is confirmed here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param tags any
---@param race any
---@return table
function GetBuilderMacros(tags, race) end


--- Returns the production method of a build macro. No vanilla code calls it, so the form of the
--- result is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param macro any
---@return any
function GetBuildProductionMethod(macro) end


--- Returns the colour of a button widget as four values - red, green, blue and alpha.
--- `widget_fullscreen.lua` reads them to re-apply the button's glow factor on top.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:15416
---@param buttonID any
---@return number, number, number, number
function GetButtonColor(buttonID) end


--- Returns the hotkey badge of a button as four values: whether to show it, the icon, and its x
--- and y offset. `widget_fullscreen.lua` zeroes the nil ones straight away, so any of them can
--- come back empty.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12000
---@param buttonID any
---@return boolean, any, number, number
function GetButtonHotkeyDetails(buttonID) end


--- Returns the icon of a button widget. `widget_fullscreen.lua` uses it to read back what a
--- button is showing before it changes it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12057
---@param buttonID any
---@return any
function GetButtonIcon(buttonID) end


--- Returns the second icon of a button, or nothing when it has only one. A button can carry two
--- icons side by side, which is how vanilla draws a paired state on one button.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12098
---@param buttonID any
---@return any
function GetButtonIcon2(buttonID) end


--- Returns the colour of a button's second icon as four values. `widget_fullscreen.lua` reads
--- it after switching that icon element to its active slide, and dims it when the button is
--- inactive.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12103
---@param buttonID any
---@return number, number, number, number
function GetButtonIcon2Color(buttonID) end


--- Returns the x and y offset of a button's second icon. Like `GetButtonIconOffset` it only
--- applies to an icon that is not full-sized.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12118
---@param buttonID any
---@return number, number
function GetButtonIcon2Offset(buttonID) end


--- Returns the width and height of a button's second icon. A zero in either means there is no
--- second icon to place, the same convention as `GetButtonIconSize`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12115
---@param buttonID any
---@return number, number
function GetButtonIcon2Size(buttonID) end


--- Returns the colour of a button's icon as four values. `widget_fullscreen.lua` reads it after
--- switching the icon element to its active slide, then applies the glow factor on top.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12062
---@param buttonID any
---@return number, number, number, number
function GetButtonIconColor(buttonID) end


--- Returns the x and y offset of a button's icon. It only means anything for an icon that is
--- not full-sized: `widget_fullscreen.lua` combines it with `GetButtonIconSize`, which returns
--- zeroes when the icon fills the button.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12080
---@param buttonID any
---@return number, number
function GetButtonIconOffset(buttonID) end


--- Returns the width and height of a button's icon. `widget_fullscreen.lua` treats a zero in
--- either as no icon at all.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12077
---@param buttonID any
---@return number, number
function GetButtonIconSize(buttonID) end


--- Returns the second icon of a button - the one it swaps to on mouse-over or when toggled.
--- `widget_fullscreen.lua` caches it next to the main icon.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12070
---@param buttonID any
---@return any
function GetButtonSwapIcon(buttonID) end


--- Returns the swap icon of a button's second icon - the state a two-icon button flips to.
--- `GetButtonIcon2` returns the second icon itself.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12108
---@param buttonID any
---@return any
function GetButtonSwapIcon2(buttonID) end


--- Returns the label a button widget is showing. `widget_fullscreen.lua` reads it back before
--- deciding whether the button needs one at all.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12136
---@param buttonID any
---@return string
function GetButtonText(buttonID) end


--- Returns the alignment of a button's label, which `widget_fullscreen.lua` turns into the
--- horizontal offset it draws the text at.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12140
---@param buttonID any
---@return any
function GetButtonTextAlignment(buttonID) end


--- Returns the colour of a button's label as four values, red, green, blue and alpha.
--- `widget_fullscreen.lua` reads it to re-apply the text glow factor on top.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:15506
---@param buttonID any
---@return number, number, number, number
function GetButtonTextColor(buttonID) end


--- Returns the font and font size of a button's label, as two values.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12035
---@param buttonID any
---@return any, number
function GetButtonTextFont(buttonID) end


--- Returns the x and y offset of a button's label. `widget_fullscreen.lua` uses it to place
--- text that is not simply centred.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12142
---@param buttonID any
---@return number, number
function GetButtonTextOffset(buttonID) end


--- Returns whether high quality screenshot capture is on, and pairs with `SetCaptureHQOption`
--- the way the other option rows do.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1899
---@return boolean
function GetCaptureHQOption() end


--- Returns what a ship's cargo will hold once its queued trade orders have run, rather than
--- what is in it now. That is the number a trade dialogue has to reason with;
--- `includeSubordinates` counts the subordinates' queued trades as well.
--- `GetAmmoCountAfterTradeOrders` is the same idea for ammunition.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:14099, ui/addons/ego_detailmonitor/menu_map.lua:21340
---@param component any
---@param includeSubordinates? boolean
---@return table
function GetCargoAfterTradeOrders(component, includeSubordinates) end


--- Returns the widget in a table cell, whatever kind it is - a button, an editbox, a slider. It
--- is how vanilla reaches an existing widget to change it in place instead of rebuilding the
--- table: read the cell, then call `SetButtonColor` or `SetScript` on what comes back.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 41 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1088, ui/addons/ego_detailmonitorhelper/helper.lua:2654
---@param tableObj any
---@param row integer
---@param col integer
---@return any
function GetCellContent(tableObj, row, col) end


--- Returns the text widget inside a table cell - the widget itself, not a string, which is why
--- vanilla passes the result straight to `SetText`. It returns nothing when the cell holds no
--- text widget, and `Helper.updateCellText` tests for that before writing.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1496, ui/addons/ego_detailmonitorhelper/helper.lua:2642
---@param tableObj any
---@param row integer
---@param col integer
---@return string
function GetCellText(tableObj, row, col) end


--- Returns the character density setting. No vanilla code calls it, and neither is
--- `SetCharacterDensityOption` called.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return number
function GetCharacterDensityOption() end


--- Returns the child widgets of a frame, one return value each and in the order they were
--- added. The caller has to know how many to expect - `debuglog.lua` takes two, and code that
--- does not know wraps the call in `table.pack`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1087, ui/addons/ego_detailmonitorhelper/helper.lua:1634
---@param frame any
---@return ... any
function GetChildren(frame) end


--- Returns the child elements of a scene element.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@return table children
function getChildren(element) end


--- Returns the galaxy's clusters as a list. `includeHighways` decides whether highway-only
--- clusters come with them; every vanilla call passes true.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:524, ui/addons/ego_detailmonitor/menu_map.lua:20885
---@param includeHighways? boolean
---@return table
function GetClusters(includeHighways) end


--- Returns what a collectable object holds: a table with a `type` (`ammo` and the rest) and a
--- `wares` list the map menu walks to show what is out there to pick up.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:20221, ui/addons/ego_targetmonitor/targetmonitor.lua:689
---@param component any
---@return table
function GetCollectableData(component) end


--- Returns whether collision avoidance assist is on, and pairs with
--- `SetCollisionAvoidanceAssistOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2037
---@return boolean
function GetCollisionAvoidanceAssistOption() end


--- Returns the colour of a text widget as four values, red, green, blue and alpha.
--- `widget_fullscreen.lua` reads it alongside `GetSize` and `GetWordWrap` when it measures a
--- text.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:17732
---@param fontStringID any
---@return number, number, number, number
function GetColor(fontStringID) end


--- Returns one column of an Anark data table.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param table any The data table, as returned by getTable.
---@param column any Column name or index.
---@return any column
function getColumn(table, column) end


--- Returns the column names of an Anark data table.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param table any The data table, as returned by getTable.
---@return table names
function getColumnNames(table) end


--- Returns the commander of a controllable, or nothing when it has none - which is the test for
--- whether a ship is a subordinate at all. The second parameter addresses a fleet unit; no
--- vanilla call passes it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 19 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:7890, ui/addons/ego_detailmonitor/menu_ship_configuration.lua:1674
---@param controllableid any
---@param fleetUnitID? any
---@return any
function GetCommander(controllableid, fleetUnitID) end


--- Returns the commander entity of a controllable - the NPC in command rather than the ship
--- above it, which is what `GetCommander` returns. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param controllableid any
---@return any
function GetCommanderEntity(controllableid) end


--- Reads named properties off a component, and is the workhorse of the whole UI. Every argument
--- after the component is a property name, and it returns one value per name, in the order
--- asked: `GetComponentData(id, "isshipyard", "iswharf", "istradestation")` returns three
--- booleans. Vanilla asks for anything from one property to thirteen at a time, and one call
--- for several is cheaper than several calls for one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 832 vanilla call sites, 2-16 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:488, ui/addons/ego_detailmonitor/menu_crafting.lua:228
---@param component any
---@param ... string
---@return ... any
function GetComponentData(component, ...) end


--- Returns a component's name, already truncated to fit. The font, size and width after the
--- component are the box it has to fit into, so the engine measures and shortens the name
--- instead of the caller doing it. Vanilla passes six arguments; what the last two select is
--- not identifiable from the call sites.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 6 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_station_overview.lua:3243, ui/addons/ego_targetmonitor/targetmonitor.lua:358
---@param componentid any
---@param font? string Font used to measure the name for truncation.
---@param fontsize? number Font size used to measure the name.
---@param maxwidth? number Width the name is truncated to.
---@param arg5? any Unidentified in 9.00 vanilla usage; a boolean or nil.
---@param arg6? any Unidentified in 9.00 vanilla usage; a boolean.
---@return string
function GetComponentName(componentid, font, fontsize, maxwidth, arg5, arg6) end


--- Returns whether the mouse is confined to the window, and pairs with `SetConfineMouseOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2464
---@return boolean
function GetConfineMouseOption() end


--- Returns the build storages of one owner. The player information page reads it for `"player"`
--- and filters the list down itself.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:2585
---@param owner string
---@return table
function GetContainedBuildStoragesByOwner(owner) end


--- Returns the objects of one owner, as a list. Called with just a faction ID - `"player"` - it
--- covers everything that faction owns; with a container as the second argument it is limited
--- to what is inside that container, which is how the undock menu lists the ships docked at a
--- station.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2258, ui/addons/ego_detailmonitor/menu_map.lua:4836
---@param owner string
---@param container? any
---@return table
function GetContainedObjectsByOwner(owner, container) end


--- Returns the ships inside a container, whoever owns them. No vanilla code calls it - the
--- menus want the owner filter and use `GetContainedShipsByOwner` or
--- `GetContainedObjectsByOwner`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param container any
---@return table
function GetContainedShips(container) end


--- Returns the ships of one owner inside a container. No vanilla code calls it, so the form of
--- `owner` - a faction ID string - is taken from the declaration rather than from usage.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param owner string
---@param container? any
---@return table
function GetContainedShipsByOwner(owner, container) end


--- Returns the spaces belonging to one owner. No vanilla code calls it, so the shape of the
--- result is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param owner string
---@return table
function GetContainedSpacesByOwner(owner) end


--- Returns the stations inside a container, whoever owns them - `GetContainedStationsByOwner`
--- is the same with an owner filter. The second argument decides whether gates count as
--- stations; both vanilla calls pass true.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2727, ui/addons/ego_detailmonitor/menu_map.lua:14812
---@param container any
---@param includeGates? boolean
---@return table
function GetContainedStations(container, includeGates) end


--- Returns the stations of one owner. With a container it is limited to that container; with
--- `nil` it covers the whole galaxy, which is how the map builds the player's station list. The
--- third argument decides whether gates count as stations.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1925, ui/addons/ego_detailmonitor/menu_map.lua:5132
---@param owner string
---@param container? any
---@param includeGates? boolean
---@return table
function GetContainedStationsByOwner(owner, container, includeGates) end


--- Returns what one ware costs at one container. `isBuy` picks the side of the trade, and the
--- fourth argument asks for the build price instead of the trade price - the station
--- configuration menu passes it, the trade dialogues do not. Callers clamp the result between
--- the ware's min and max price, and `HasContainerWarePriceOverride` says whether a manual
--- price is in force.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 3-4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_ship_configuration.lua:4887, ui/addons/ego_detailmonitor/menu_station_configuration.lua:4269
---@param container any
---@param ware any
---@param isBuy boolean
---@param useBuildPrice? boolean
---@return number
function GetContainerWarePrice(container, ware, isBuy, useBuildPrice) end


--- Walks up from a component to the enclosing object of a given class - the container a ship or
--- an NPC is in, for instance - and returns it. `includeSelf` decides whether the component
--- itself counts when it is already of that class.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4151, ui/addons/ego_detailmonitor/menu_map.lua:14895
---@param componentid any
---@param classname string
---@param includeSelf? boolean
---@return any
function GetContextByClass(componentid, classname, includeSelf) end


--- Returns the control entity of a component - the NPC actually flying or running it - or
--- nothing when there is none. The interact menu uses its absence to explain why an action is
--- unavailable.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_interactmenu/menu_interactmenu.lua:6881
---@param component any
---@return any
function GetControlEntity(component) end


--- Returns which input device the player is currently using, as a string - `mouseCursor`,
--- `gamepad` or `joystick`. Menus branch on it to show the right button prompts and to decide
--- whether an input bar is needed at all.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:20560, ui/addons/ego_detailmonitor/menu_scenario_selection.lua:326
---@return string, number?
function GetControllerInfo() end


--- Returns a table of data about a control post. No vanilla code calls it, so the shape of that
--- table is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param controlpost any
---@return table
function GetControlPostData(controlpost) end


--- Returns whether crash reporting is on, and pairs with `SetCrashReportOption` on the privacy
--- page.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2887
---@return boolean
function GetCrashReportOption() end


--- Returns the current real time in seconds - wall clock, so it keeps running while the game is
--- paused. UI timing uses it: an update interval, how long a mouse button has been down, when a
--- help text was last refreshed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 20 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_ship_configuration.lua:9924, ui/addons/ego_detailmonitor/menu_station_configuration.lua:6385
---@return number
function GetCurRealTime() end


--- Returns the font and size the mouse-over text is drawn in. Vanilla passes both, with
--- `GetCurrentMouseOverWidth`, into `Helper.indentText`, so wrapped text is measured in the
--- font it will actually appear in.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@return string, number
function GetCurrentMouseOverFont() end


--- Returns the width the mouse-over text box is being drawn at. Vanilla passes it, with
--- `GetCurrentMouseOverFont`, into `Helper.indentText`, so wrapped lines are measured against
--- the box they land in.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@return number
function GetCurrentMouseOverWidth() end


--- Returns the current game time in seconds, which pause stops and SETA speeds up. Anything the
--- player is told about in game time - an ETA, an order's remaining time - is computed against
--- this, not against `GetCurRealTime`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21083, ui/addons/ego_detailmonitorhelper/helper.lua:11583
---@return number
function GetCurTime() end


--- Formats a timestamp as a date string, with a `strftime` style format - the debug log copies
--- entries to the clipboard with `GetDate("!%c", entry.timestamp)`, where the leading `!` asks
--- for UTC.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1027
---@param format string
---@param timestamp? number
---@return string
function GetDate(format, timestamp) end


--- Returns the controller deadzone, on the engine's own 0 to 1 scale. The options menu
--- multiplies it back up for its 0-100 slider, whose callback is `SetDeadzoneOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7560
---@return number
function GetDeadzoneOption() end


--- Returns one option of the running dialog, by index: its text, whether it is selectable,
--- whether it is immediate, its shortcut key and its mouse-over text - five values in that
--- order. The core dialog menu walks the indexes and treats an empty text as an inactive
--- button.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/dialogmenu.lua:850
---@param index integer
---@return string, boolean, boolean, string, string
function GetDialogOption(index) end


--- Returns whether the distortion graphics option is on, and pairs with `SetDistortionOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1815
---@return boolean
function GetDistortionOption() end


--- Reports whether an edit box closes the menu when the player backs out of it.
--- `widget_fullscreen.lua` caches it on the element as `closeMenuOnBack`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12693
---@param editBoxID any
---@return boolean
function GetEditBoxCloseMenuOption(editBoxID) end


--- Returns the colour of an edit box as four values, red, green, blue and alpha.
--- `widget_fullscreen.lua` reads them back to keep its cached element colour in step.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12736
---@param editBoxID any
---@return number, number, number, number
function GetEditBoxColor(editBoxID) end


--- Returns the font and the font size of an edit box, as two values. `widget_fullscreen.lua`
--- caches both on the element when it builds it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12651
---@param editBoxID any
---@return any, number
function GetEditBoxFont(editBoxID) end


--- Returns the hotkey badge of an edit box as four values: whether to show it, the icon, and
--- its x and y offset. Any of them can come back empty, and `widget_fullscreen.lua` zeroes them
--- straight away.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12616
---@param editBoxID any
---@return boolean, any, number, number
function GetEditBoxHotkeyDetails(editBoxID) end


--- Returns what an edit box currently holds. `widget_fullscreen.lua` polls it and only reacts
--- when the text differs from what it last saw.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:2649
---@param editBoxID any
---@return string
function GetEditBoxText(editBoxID) end


--- Returns the text alignment of an edit box, which `widget_fullscreen.lua` turns into the
--- horizontal offset it draws the text at.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12674
---@param editBoxID any
---@return any
function GetEditBoxTextAlignment(editBoxID) end


--- Returns the colour of an edit box's text as four values, red, green, blue and alpha - the
--- box's own colour comes from `GetEditBoxColor`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:12754
---@param editBoxID any
---@return number, number, number, number
function GetEditBoxTextColor(editBoxID) end


--- Returns the effect distance on the engine's 0 to 1 scale; the options menu multiplies by 100
--- for its slider.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7010
---@return number
function GetEffectDistanceOption() end


--- Returns the efficiency upgrades of a ware. No vanilla code calls it, so the shape of the
--- result is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param ware any
---@return table
function GetEfficiencyUpgrades(ware) end


--- Returns the type name of a scene element.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@return string type
function getElementType(element) end


--- Returns a table describing an entity type. No vanilla code calls it, so neither the argument
--- nor the shape of the result is confirmed here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param entityType any
---@return table
function GetEntityTypeData(entityType) end


--- Returns an error message by ID. No vanilla code calls it; the UI reports its own errors
--- through `DebugError` instead.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param messageID any
---@return string
function GetError(messageID) end


--- Returns the severity of a logged error. The debug log turns it into the prefix each line
--- gets - Info, Warning, Error - so severity is what separates a note from a real fault.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:809
---@param messageID number The ID of the error message.
---@return number severity The severity level of the error.
function GetErrorSeverity(messageID) end


--- Returns when an error was logged. The debug log reads it with `GetError` and
--- `GetErrorSeverity` to build one line - timestamp, prefix, message.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:822
---@param messageID number The ID of the error message.
---@return any timestamp The timestamp of the error.
function GetErrorTimestamp(messageID) end


--- Returns the installed extensions as a list, each with its own fields. The options menu walks
--- it to build the extensions page and to decide whether to show a warning icon at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_mapeditor.lua:1012, ui/addons/ego_gameoptions/gameoptions.lua:5899
---@return table extensions A table containing the list of extensions.
function GetExtensionList() end


--- Returns the warning to show about extension updates, or nothing when there is none - the
--- options menu only appends a paragraph when something comes back. Its two arguments are
--- always `""` and `false` in vanilla, so what they select is not identifiable.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6313
---@param arg1 string A string parameter (purpose unclear from usage).
---@param arg2 boolean A boolean parameter (purpose unclear from usage).
---@return string|nil warning The warning text, or nil if no warning is present.
function GetExtensionUpdateWarningText(arg1, arg2) end


--- Retrieves specific data about a faction. This is a variadic function.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 65 vanilla call sites, 2-6 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1198, ui/addons/ego_detailmonitor/menu_diplomacy.lua:1224
---@param faction string The ID of the faction.
---@param ... string One or more string keys for the data to retrieve (e.g., "name", "color", "shortname").
---@return any ... The requested faction data. The number and types of return values depend on the keys provided.
function GetFactionData(faction, ...) end


--- Returns the live state of a flowchart widget - which row and column are selected and which
--- are the first visible ones. It can come back empty, and `widget_fullscreen.lua` checks
--- before reading it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4182, ui/widget/lua/widget_fullscreen.lua:12810
---@param widgetID any The ID of the flowchart widget.
---@return table flowchartData A table with flowchart data, including fields like `selectedRow`, `selectedCol`, `firstVisibleRow`, `firstVisibleCol`.
function GetFlowchartData(widgetID) end


--- Returns the live data of one flowchart edge. It can come back empty, and
--- `widget_fullscreen.lua` checks before refreshing the edge it holds.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:7215
---@param flowchartEdgeID any The ID of the flowchart edge.
---@return table edgeData The data for the specified edge.
function GetFlowchartEdgeData(flowchartEdgeID) end


--- Returns the ID of one edge of a flowchart, by index. Edges are addressed by index from 1 to
--- `flowchartData.numEdges`, and the ID it returns is what `GetFlowchartEdgeData` takes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4205, ui/widget/lua/widget_fullscreen.lua:12969
---@param widgetID any The ID of the flowchart widget.
---@param edgeIdx number The index of the edge.
---@return any edgeID The ID of the specified edge.
function GetFlowchartEdgeID(widgetID, edgeIdx) end


--- Returns the row and column of the first visible cell of a flowchart - its scroll position.
--- Vanilla reads it with `GetFlowchartSelectedCell` when a menu is torn down, so both the
--- scroll and the selection can be restored on the way back in.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param flowchartID any The ID of the flowchart.
---@return number firstVisibleRow The row of the first visible cell.
---@return number firstVisibleCol The column of the first visible cell.
function GetFlowchartFirstVisibleCell(flowchartID) end


--- Returns the live data of one flowchart node. Like the edge version it can come back empty,
--- which `widget_fullscreen.lua` tests before using it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:7179
---@param flowchartNodeID any The ID of the flowchart node.
---@return table nodeData The data for the specified node.
function GetFlowchartNodeData(flowchartNodeID) end


--- Returns where an expanded flowchart node's frame goes: the node's x and y and the frame's x
--- and y padding. A nil x means the node has no expanded frame, which is what `helper.lua`
--- checks before building one.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param flowchartNodeID any The ID of the flowchart node.
---@return table frameData The data for the expanded frame.
function GetFlowchartNodeExpandedFrameData(flowchartNodeID) end


--- Retrieves the ID of a specific node in a flowchart by its row and column.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2920, ui/widget/lua/widget_fullscreen.lua:12953
---@param flowChartID any The ID of the flowchart widget.
---@param row number The row of the node.
---@param col number The column of the node.
---@return any nodeID The ID of the specified node.
function GetFlowchartNodeID(flowChartID, row, col) end


--- Returns the row and column of the selected cell of a flowchart. Vanilla reads it together
--- with `GetFlowchartFirstVisibleCell` when a menu is torn down, so the selection and the
--- scroll position can both be put back on the way in.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param flowchartID any The ID of the flowchart.
---@return number selectedRow The row of the selected cell.
---@return number selectedCol The column of the selected cell.
function GetFlowchartSelectedCell(flowchartID) end


--- Returns the font name and size of a text widget, as two values. `widget_fullscreen.lua`
--- reads them with `GetText` when it measures a text, and turns them into a height with
--- `GetFontHeight`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:17728
---@param fontStringID any The ID of the font string.
---@return string font The name of the font.
---@return number size The size of the font.
function GetFont(fontStringID) end


--- Returns the pixel height of a font at a size. `widget_fullscreen.lua` caches the answer per
--- size, because layout asks for it constantly and the value never changes.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:7352
---@param fontName string The name of the font.
---@param fontSize number The size of the font.
---@return number fontHeight The height of the font.
function GetFontHeight(fontName, fontSize) end


--- Returns the field of view as a factor around 1, not an angle: the options menu multiplies by
--- 90 to show degrees, and `SetFOVOption` divides by 90 on the way back.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7060
---@return number fov The current FOV value.
function GetFOVOption() end


--- Gets the background ID of a frame. (No usage found in provided files)
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param frameID any The ID of the frame.
---@return any backgroundID The background ID of the frame.
function GetFrameBackgroundID(frameID) end


--- Returns the layer a frame sits on. Vanilla compares two frames by layer rather than by
--- identity - `widget_fullscreen.lua` skips a call when a pending frame shares the layer of the
--- one it would act on.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7388, ui/widget/lua/widget_fullscreen.lua:5518
---@param frameID any The ID of the frame.
---@return number layer The layer of the frame.
function GetFrameLayer(frameID) end


--- Gets the overlay ID of a frame. (No usage found in provided files)
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param frameID any The ID of the frame.
---@return any overlayID The overlay ID of the frame.
function GetFrameOverlayID(frameID) end


--- Returns the x and y position of a frame. The chat window subtracts it from the mouse
--- position to work out where inside the frame the player grabbed it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:337, ui/widget/lua/widget_fullscreen.lua:16925
---@param frameID any The ID of the frame.
---@return number x The x-coordinate of the frame.
---@return number y The y-coordinate of the frame.
function GetFramePosition(frameID) end


--- Calculates the free cargo space for a specific ware on a ship after accounting for trade orders.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21793
---@param shipID any The ID of the ship.
---@param ware string The ware to check.
---@return number freeCargo The amount of free cargo space.
function GetFreeCargoAfterTradeOrders(shipID, ware) end


--- Calculates the free unit storage on a ship after accounting for trade orders.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21789
---@param shipID any The ID of the ship.
---@return number freeUnitStorage The amount of free unit storage.
function GetFreeUnitStorageAfterTradeOrders(shipID) end


--- Returns two values, whether fullscreen is on and whether the window is borderless - the
--- display mode is a pair of flags, not one setting, though `SetFullscreenOption` takes a
--- single dropdown index.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7181
---@return boolean fullscreen True if fullscreen is enabled.
---@return boolean borderless True if borderless window is enabled.
function GetFullscreenOption() end


--- Returns the gamepad mode on the engine's scale, which starts at zero; the options menu adds
--- one for its dropdown index.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7537
---@return number gamepadMode The current gamepad mode.
function GetGamepadModeOption() end


--- Returns the gamma setting on the engine's 0 to 1 scale. The options menu multiplies by 100
--- for its slider, which hands the value back divided by 100 through `SetGammaOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7204
---@return number gamma The current gamma value.
function GetGammaOption() end


--- Retrieves a list of gates. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table gates A table containing gate information.
function GetGates() end


--- Returns the graphics quality preset on the engine's scale, which starts at zero and where
--- zero means Custom; the options menu adds one for its dropdown index. Any individual graphics
--- setter drops it back to Custom with `SetGfxQualityOption(0)`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7349
---@return number quality The current graphics quality setting.
function GetGfxQualityOption() end


--- Returns the global sync setting - whether settings follow the player between installations.
--- The options menu reads it for the privacy page.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3368
---@return any syncSetting The current global sync setting.
function GetGlobalSyncSetting() end


--- Returns the glow quality level on the engine's scale, which starts at zero; the options menu
--- adds one to turn it into a dropdown index.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7229
---@return number glowOption The current glow option.
function GetGlowOption() end


--- Returns the header widget of a table, the row that stays put while the rest scrolls.
--- `widget_fullscreen.lua` measures it to work out how much height is left for the table
--- itself.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14419
---@param tableID any The ID of the table.
---@return any header The header of the table.
function GetHeader(tableID) end


--- Retrieves a list of licences held by the player. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table licences A table containing the held licences.
function GetHeldLicences() end


--- Returns the x and y of a named hint position, as percentages of the view. The help text menu
--- turns them into pixels against `Helper.viewWidth` and clamps the result so a hint cannot
--- hang off the edge.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_helptext/helptext.lua:406
---@param position any The identifier for the hint's position.
---@return number position_x The x-coordinate.
---@return number position_y The y-coordinate.
function GetHintPosition(position) end


--- Returns the whole holomap colour set in one call - twenty-two colours, from production and
--- build through the alert levels to gates and highways. `Helper.getHoloMapColors` names them
--- into a table, and that wrapper is what menu code uses.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13070
---@return any productionColor
---@return any buildColor
---@return any storageColor
---@return any radarColor
---@return any droneDockColor
---@return any efficiencyColor
---@return any defenceColor
---@return any playerColor
---@return any friendColor
---@return any enemyColor
---@return any missionColor
---@return any currentPlayerShipColor
---@return any visitorColor
---@return any lowAlertColor
---@return any mediumAlertColor
---@return any highAlertColor
---@return any gateColor
---@return any highwayGateColor
---@return any missileColor
---@return any superhighwayColor
---@return any highwayColor
---@return any hostileColor
function GetHoloMapColors() end


--- Returns everything an icon is drawn with: the texture name and its red, green, blue and
--- alpha. `widget_fullscreen.lua` reads them and applies the glow factor from
--- `C.GetIconGlowFactor` on top.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:17864
---@param iconID any The ID of the icon.
---@return string textureName The name of the texture.
---@return number red The red color component.
---@return number green The green color component.
---@return number blue The blue color component.
---@return number alpha The alpha component.
function GetIconDetails(iconID) end


--- Returns the action bindings - the inputs that fire on a press. Called with no argument for
--- the player's current map and with true for the default one, next to `GetInputStateMap` and
--- `GetInputRangeMap`; the options menu keeps both sets to show what has been rebound.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table actions The input action map.
function GetInputActionMap(default) end


--- Returns the input profiles - the shipped ones and the player's own - as a table. The
--- controls page splits the user profiles back out of it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:12558
---@return table inputProfiles A table of input profiles.
function GetInputProfiles() end


--- Returns the range bindings - the axis inputs - as a table. Called with no argument for the
--- player's current map and with true for the default one, which the options menu keeps side by
--- side to show what has been changed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table ranges The input range map.
function GetInputRangeMap(default) end


--- Returns the state bindings - the inputs that act while held. Called with no argument for the
--- current map and with true for the default one, alongside `GetInputActionMap` and
--- `GetInputRangeMap`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table states The input state map.
function GetInputStateMap(default) end


--- Returns the widget inside a frame that currently has interaction, or nothing when the frame
--- has none. Vanilla pairs it with `GetActiveFrame`: a menu only reacts to a row change when
--- its own frame is active **and** the table that changed is the interactive one.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:27238, ui/addons/ego_detailmonitorhelper/helper.lua:966
---@param frameID any The ID of the frame.
---@return any interactiveWidgetID The ID of the interactive widget.
function GetInteractiveObject(frameID) end


--- Retrieves the inventory of an entity (e.g., ship, station, NPC).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 10 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:4112, ui/addons/ego_detailmonitor/menu_map.lua:6516
---@param entityID any The ID of the entity.
---@return table inventory A table representing the entity's inventory.
function GetInventory(entityID) end


--- Reports whether one control range is inverted. The options menu turns it straight into the
--- Inverted or Normal label of that row, whose callback is `SetInversionSetting`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7556
---@param rangeID any The ID of the control range.
---@return boolean isInverted True if the control is inverted.
function GetInversionSetting(rangeID) end


--- Returns the joystick slot assignments. The controls page reads it next to
--- `GetMappedJoysticks`, which lists the devices actually mapped, and writes back one slot at a
--- time with `SetJoysticksOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4926
---@return table joysticks A table containing joystick information.
function GetJoysticksOption() end


--- Gets the legacy shaders option. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean legacyShadersEnabled True if legacy shaders are enabled.
function GetLegacyShadersOption() end


--- Returns a whole data library as a table - `factions`, `stationtypes` and the rest of the
--- libraries the encyclopedia is built from. `GetLibrarySize` gives the entry count without
--- reading the entries.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 16 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1188, ui/addons/ego_detailmonitor/menu_docked.lua:627
---@param libraryName string The name of the library to retrieve (e.g., "factions", "stationtypes").
---@return table library A table containing the library data.
function GetLibrary(libraryName) end


--- Returns one entry of a data library, by library name and entry ID. The library name is often
--- not a constant: the map asks `GetMacroData(macro, "infolibrary")` which library a macro
--- belongs to and passes the answer straight in.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 34 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1568, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:776
---@param libraryName string The name of the library.
---@param entryID any The ID of the entry to retrieve.
---@return table entry The requested library entry.
function GetLibraryEntry(libraryName, entryID) end


--- Returns how many entries a data library holds. The encyclopedia sums it over its
--- subcategories to show a count per category without reading the entries themselves.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2574
---@param libraryName string The name of the library.
---@return number size The number of entries in the library.
function GetLibrarySize(libraryName) end


--- The live-data hook of the target monitor: `ui/addons/ego_targetmonitor/targetmonitor.lua`
--- defines it at file scope, so it lands in the addons Lua environment where anything can reach
--- it. Nothing in vanilla calls it - the engine does, to fill in a target monitor placeholder -
--- which makes it the usual place a mod hooks to put its own text on the monitor.
-- Source: ui\addons\ego_targetmonitor\targetmonitor.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param placeholder any A placeholder parameter (purpose unclear).
---@param component any The component requesting the data.
---@param templateConnectionName string The name of the template connection.
---@return any data The live data.
function GetLiveData(placeholder, component, templateConnectionName) end


--- Retrieves live data from a bridge, used for UI updates between different components.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/monitors.lua:1742
---@param dataName string The name of the data to retrieve (e.g., "targetmonitorstate").
---@param component string The component requesting the data.
---@param connection any The connection context.
---@return any data The live data.
function GetLiveDataBridge(dataName, component, connection) end


--- Returns the state of the loading screen as eight values: the loading text and percentage,
--- how many items have loaded, whether a savegame is being loaded, how many proverbs there are,
--- and the initial screen's identifier, text and time. The loading screen takes only the ones
--- it needs and skips the rest with `_`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/loading.lua:269
---@return string text The current loading text.
---@return number percentage The loading progress percentage.
---@return number loadCount The number of items loaded.
---@return boolean isSavegame True if loading a savegame.
---@return number numProverbs The number of proverbs available.
---@return any initialLoadingScreen The initial loading screen identifier.
---@return string initialLoadingScreenText The initial loading screen text.
---@return number initialLoadingScreenTime The initial loading screen time.
function GetLoadingInfo() end


--- Gets the localized name for a key based on its input type and ID.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 14 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:436, ui/addons/ego_detailmonitorhelper/helper.lua:8849
---@param inputType string The type of input (e.g., "action").
---@param inputID any The ID of the input.
---@return string keyName The localized name of the key.
function GetLocalizedKeyName(inputType, inputID) end


--- Returns the name of a raw key code in the player's language - what the controls page prints
--- for a keyboard binding, next to the icon for the device.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4955
---@param code any The raw key code.
---@return string keyName The localized name of the key.
function GetLocalizedRawKeyName(code) end


--- Returns where the last click landed, in the local frame's coordinates - the position of the
--- click rather than of the pointer now, which is what `GetLocalMousePosition` gives.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:2992
---@return number x The x-coordinate of the mouse click.
---@return number y The y-coordinate of the mouse click.
function GetLocalMouseClickPosition() end


--- Returns the mouse position in the local frame's coordinates. Both values come back nil when
--- there is no pointer to report - with a gamepad, or off screen - so vanilla wraps the call in
--- `table.pack` and tests the first value before using it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 92 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:336, ui/addons/ego_detailmonitor/menu_crafting.lua:454
---@return number x The x-coordinate of the mouse.
---@return number y The y-coordinate of the mouse.
function GetLocalMousePosition() end


--- Returns the level of detail on the engine's 0 to 1 scale; the options menu multiplies by 100
--- and clamps to its slider's 1 to 100 range.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7294
---@return number lod The current LOD value.
function GetLODOption() end


--- Returns a page of logbook entries: `numQuery` of them starting at `startIndex`, limited to
--- one category. It can return nothing, so both callers fall back with `or {}`, and both page
--- the log rather than asking for all of it - the query limit is a config value.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:16808, ui/addons/ego_detailmonitor/menu_playerinfo.lua:2855
---@param startIndex number The starting index for retrieval.
---@param numQuery number The number of entries to query.
---@param category any The category of logbook entries to retrieve.
---@return table logbook A table containing the logbook entries.
function GetLogbook(startIndex, numQuery, category) end


--- Retrieves specific data from a macro definition. This is a variadic function.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 251 vanilla call sites, 2-9 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:509, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:574
---@param macro string The name of the macro.
---@param ... string One or more string keys for the data to retrieve (e.g., "name", "icon", "infolibrary").
---@return any ... The requested macro data. The number and types of return values depend on the keys provided.
function GetMacroData(macro, ...) end


--- Returns how many units - drones and the like - a macro can hold. It works from the macro, so
--- the ship configuration menu can show the capacity of a ship that does not exist yet.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_ship_configuration.lua:10461
---@param macro any The macro to check.
---@return number capacity The unit storage capacity.
function GetMacroUnitStorageCapacity(macro) end


--- Returns the joysticks that are actually mapped to a slot, next to `GetJoysticksOption` which
--- returns the slot assignments themselves.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4927
---@return table mappedjoysticks A table of mapped joysticks.
function GetMappedJoysticks() end


--- Gets the maximum text length for an element. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param elementID any The ID of the element.
---@return number maxLength The maximum text length.
function GetMaxTextLength(elementID) end


--- Gets the parameters of the current menu. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table params The menu parameters.
function GetMenuParameters() end


--- Returns what the menu was opened with: its name and two parameters. `helper.lua` calls it at
--- the top of every menu setup and compares the name against its own, so a menu can tell that
--- the parameters on offer are not for it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1345
---@return string name The name of the menu.
---@return any param The first parameter.
---@return any param2 The second parameter.
function GetMenuParameters2() end


--- Returns the cutscene parameter carried by a message, addressed by message ID and category -
--- what the player information menu needs to play the cutscene a message refers to.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:4491
---@param messageID any The ID of the message.
---@param category any The category of the message.
---@return any cutsceneparameter The cutscene parameter.
function GetMessageCutsceneParameter(messageID, category) end


--- Projects a message's world position onto the screen and returns four values: the x and y in
--- screen coordinates, whether it is on screen at all, and the distance from the camera. The x
--- comes back nil when there is no position to project, which is what the core target system
--- tests.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:2166
---@param messageID any The ID of the message.
---@return number x2d The x-coordinate on the screen.
---@return number y2d The y-coordinate on the screen.
---@return boolean onScreen True if the position is on the screen.
---@return number cameraDistance The distance from the camera.
function GetMessageScreenPosition(messageID) end


--- Retrieves macros for mining units. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table macros A table of mining unit macros.
function GetMiningUnitMacros() end


--- Returns everything about a mission in one call - twenty-four values, of which vanilla names
--- about a dozen and skips the rest with `_`: the mission ID, name, description, difficulty,
--- thread type, main and sub type, faction, reward and reward text, the mission time, whether
--- it can be aborted, whether guidance is disabled, the associated component, the alert level,
--- whether it has an objective, and the thread mission ID. Missions are addressed by index,
--- from 1 to `GetNumMissions`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:10052, ui/addons/ego_detailmonitor/menu_missionbriefing.lua:144
---@param mission any The mission identifier.
---@return any missionID
---@return string name
---@return string description
---@return any difficulty
---@return any threadType
---@return any mainType
---@return any subtype
---@return string subTypeName
---@return string faction
---@return any reward
---@return string rewardText
---@return any _
---@return any _
---@return any _
---@return any _
---@return any _
---@return any missionTime
---@return any _
---@return boolean abortable
---@return boolean disableGuidance
---@return any associatedComponent
---@return any alertLevel
---@return boolean hasObjective
---@return any threadMissionID
function GetMissionDetails(mission) end


--- Returns the current objective of a mission as five values: the objective text, its timeout,
--- the name of its progress tracker, and the current and maximum progress. Everything the map
--- needs for one objective line comes out of this single call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18686
---@param mission any The mission identifier.
---@return string objectiveText The text of the objective.
---@return any timeout The timeout for the objective.
---@return string progressName The name of the progress tracker.
---@return number curProgress The current progress.
---@return number maxProgress The maximum progress.
function GetMissionObjective(mission) end


--- Returns where a mission objective points in the encyclopedia: the library name and up to two
--- item references. The objective is addressed by index, and the third argument reaches an
--- objective of a sub-mission - the briefing menu passes both shapes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:28271, ui/addons/ego_detailmonitor/menu_missionbriefing.lua:934
---@param missionID any The ID of the mission.
---@param i number The index of the objective.
---@param j? number An optional sub-index.
---@return string library The name of the encyclopedia library.
---@return any item The primary item reference.
---@return any item2 The secondary item reference.
function GetMissionObjectiveEncyclopediaReference(missionID, i, j) end


--- Returns the mission offer sitting at one connection of a component - eleven values, of which
--- the eleventh is the offer ID. The interact menu skips straight to that ID with a row of `_`;
--- the target monitor takes the descriptive ones as well. A connection has to be tagged
--- `mission` for there to be anything to return.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_interactmenu/menu_interactmenu.lua:3332, ui/addons/ego_targetmonitor/targetmonitor.lua:934
---@param component any The component ID.
---@param templateConnectionName string The name of the template connection.
---@return string mName Mission name.
---@return string mDesc Mission description.
---@return string mFaction Mission faction.
---@return any mType Mission type.
---@return any mLevel Mission level.
---@return any mReward Mission reward.
---@return string mRewardText Mission reward text.
---@return string mOppFactionName Opposing faction name.
---@return string mLicenceName Required license name.
---@return any _
---@return any mid Mission offer ID.
function GetMissionOfferAtConnection(component, templateConnectionName) end


--- Returns everything about a mission offer in one call - twenty-three values: name,
--- description, difficulty, thread type, main and sub type, faction, reward money and text, the
--- briefing objectives and which step is active, the briefing missions, the opposing faction,
--- the licence, the mission time and duration, whether it can be aborted, whether guidance is
--- disabled, the associated component, the alert level, and the offer's actor and component.
--- `GetMissionDetails` is the same idea for a mission already accepted.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18512, ui/addons/ego_detailmonitor/menu_missionbriefing.lua:894
---@param missionOfferID any The ID of the mission offer.
---@return string name
---@return string description
---@return any difficulty
---@return any threadType
---@return any mainType
---@return any subtype
---@return string subTypeName
---@return string faction
---@return any rewardMoney
---@return string rewardText
---@return table briefingObjectives
---@return any activeBriefingStep
---@return table briefingMissions
---@return string oppFaction
---@return any licence
---@return any missionTime
---@return any duration
---@return boolean abortable
---@return boolean guidanceDisabled
---@return any associatedComponent
---@return any alertLevel
---@return any offerActor
---@return any offerComponent
function GetMissionOfferDetails(missionOfferID) end


--- Returns the type of a station module. The two parameters are alternatives, not a pair:
--- vanilla passes a module component when it has one, and `nil` plus a macro name when it only
--- has the macro.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:8867, ui/addons/ego_detailmonitor/menu_map.lua:8895
---@param moduleID any The ID of the module.
---@param moduleMacro? any An optional macro for the module.
---@return string moduleType The type of the module.
function GetModuleType(moduleID, moduleMacro) end


--- Returns whether mouse look is set to toggle rather than to hold, and pairs with
--- `SetMouseLookToggleOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2096
---@return boolean isToggleEnabled True if mouse look toggle is enabled.
function GetMouseLookToggleOption() end


--- Returns the mouse pointer position in screen pixels.
--- Sibling of getScreenInfo. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return number x
---@return number y
function getMousePosition() end


--- Returns everything about a notification as a table. It can come back empty for a
--- notification that is already gone, so the monitor code falls back with `or {}` and files the
--- result under the priority it got from `GetNotificationPriority`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/monitors.lua:2709
---@param notificationID any The ID of the notification.
---@return table notificationInfos A table containing the details of the notification.
function GetNotificationDetails(notificationID) end


--- Returns the priority of a notification, or nothing when the notification is already gone -
--- which is exactly what the monitor code tests for before showing it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:2986
---@param notificationID any The ID of the notification.
---@return any priority The priority of the notification.
function GetNotificationPriority(notificationID) end


--- Reads one value off an NPC's blackboard, where Mission Director code keeps it. The key is
--- the MD variable name including its `$`: `$HiringFee`, `$config_attackenemies`,
--- `$diplomacy_exp_negotiation`. It returns nothing when the variable was never set, so callers
--- fall back with `or 0`. `SetNPCBlackboard` writes the same values back.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:740, ui/addons/ego_detailmonitor/menu_map.lua:4137
---@param entity any The ID of the NPC entity.
---@param key string The key for the value to retrieve (e.g., "$HiringFee").
---@return any value The value associated with the key on the blackboard.
function GetNPCBlackboard(entity, key) end


--- Retrieves a table of NPCs from a given container (e.g., a room or a ship).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:15435, ui/addons/ego_detailmonitor/menu_transporter.lua:819
---@param containerID any The ID of the container.
---@return table npcs A table of NPCs.
function GetNPCs(containerID) end


--- Retrieves NPCs located on stations within a specific sector. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param sectorID any The ID of the sector.
---@return table npcs A table of NPCs on stations in the sector.
function GetNPCsInSectorOnStations(sectorID) end


--- Calculates the number of items that can be afforded with a given amount of money.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21858
---@param availableMoney number The amount of money available.
---@param itemPrice number The price of a single item.
---@return number affordableAmount The number of items that can be afforded.
function GetNumAffordableTradeItems(availableMoney, itemPrice) end


--- Returns how many errors the game has logged. The debug log reads it to decide whether it has
--- anything to report at all, without walking the log.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:884
---@return number numErrors The total number of errors.
function GetNumErrors() end


--- Returns how many logbook entries a category holds. The menus ask for the count first and
--- then page through the entries with `GetLogbook`, which takes a start index and a length.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:16803, ui/addons/ego_detailmonitor/menu_playerinfo.lua:2829
---@param category any The category of the logbook.
---@return number numEntries The number of entries in that category.
function GetNumLogbook(category) end


--- Returns how many missions are active. Every vanilla caller immediately loops from 1 to that
--- count and asks for each mission in turn, so the missions are addressed by index, not handed
--- over as a list.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:10050, ui/addons/ego_detailmonitor/menu_missionbriefing.lua:142
---@return number numMissions The number of missions.
function GetNumMissions() end


--- Returns the x and y offset of a widget inside its parent. Vanilla adds the frame's own
--- position on top to get a screen position - the offset alone is relative, not absolute.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 19 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:865, ui/widget/lua/widget_fullscreen.lua:12016
---@param widgetID any The ID of the widget.
---@return number x The x-offset.
---@return number y The y-offset.
function GetOffset(widgetID) end


--- Returns the parameters of one order failure, so the map can explain why an order could not
--- run. The failure is addressed by its numeric ID on the object that failed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:11923
---@param object any The object associated with the order.
---@param failureID number The ID of the failure.
---@return table params A table containing the failure parameters.
function GetOrderFailureParams(object, failureID) end


--- Returns the parameters of one order as a list of entries, each with a `value`. The order is
--- addressed by its queue index, or by the strings `"default"` and `"planneddefault"` for the
--- default order slots - the same addressing `SetOrderParam` takes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 20 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:8727, ui/addons/ego_detailmonitor/menu_ship_configuration.lua:2880
---@param object any The object (e.g., ship) whose order is being queried.
---@param orderIndex number | "default" | "planneddefault" The index of the order in the queue, or a string for the default order.
---@return table params A table containing the order parameters.
function GetOrderParams(object, orderIndex) end


--- Gets the origin of something. (No usage found in provided files)
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any origin The origin.
function GetOrigin() end


--- Returns the licences a faction holds, as a list. Called per faction rather than for all of
--- them - the diplomacy and player information menus loop over the relations and ask for each
--- one, then sort the result themselves.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1200, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:564
---@param factionID string The ID of the faction.
---@return table licences A table of licences owned by the faction.
function GetOwnLicences(factionID) end


--- Retrieves role data for people. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table roleData The role data.
function GetPeopleRoleData() end


--- Returns whether crash reports carry the player's user ID, and pairs with
--- `SetPersonalizedCrashReportsOption` on the privacy page - the separate question from whether
--- reports are sent at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2895
---@return boolean isEnabled True if personalized crash reports are enabled.
function GetPersonalizedCrashReportsOption() end


--- Retrieves a list of platforms. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table platforms A table of platforms.
function GetPlatforms() end


--- Returns what the player is currently doing as three values: the activity name, its colour
--- and its background colour. The name is `none` when there is nothing running, and `travel`,
--- `seta` or `scan` when there is; the interact menu passes it straight into
--- `C.StopPlayerActivity` to stop whatever it turns out to be.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:447, ui/addons/ego_detailmonitor/menu_map.lua:5370
---@return string activity The name of the current activity (e.g., "travel", "seta", "scan").
---@return any activityColor The color associated with the activity.
---@return any activityBackgroundColor The background color for the activity.
function GetPlayerActivity() end


--- Returns the object of a given class the player is currently inside - the container they are
--- docked at, for instance. It is `GetContextByClass` with the player as the starting point,
--- and the two are used together to test whether the player and something else are in the same
--- place.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_station_overview.lua:388, ui/addons/ego_detailmonitor/menu_trader_inventory.lua:84
---@param className string The class name of the context to retrieve (e.g., "container").
---@return any contextID The ID of the context object.
function GetPlayerContextByClass(className) end


--- Returns the player's inventory as a table. Every menu that shows or spends inventory wares -
--- crafting, the mod shop, the player information page - reads it fresh rather than caching it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:227, ui/addons/ego_detailmonitor/menu_diplomacy.lua:4110
---@return table inventory A table representing the player's inventory.
function GetPlayerInventory() end


--- Returns the player's money. It is what every affordability check in the UI compares against,
--- and menus clamp it with `math.max(0, ...)` where a negative balance would break their
--- arithmetic.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 41 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:2572, ui/addons/ego_detailmonitor/menu_map.lua:3495
---@return number money The player's current money.
function GetPlayerMoney() end


--- Gets the player's current room. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any roomID The ID of the player's room.
function GetPlayerRoom() end


--- Returns the player ship's hull and shield percentages, plus the time since the last attack
--- and the shield charging and charged sounds - five values, of which the crosshair takes only
--- the shield.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/crosshair handling.lua:2231
---@return number playerHull The current hull percentage.
---@return number playerShield The current shield percentage.
---@return any timeSinceLastAttack Time since the last attack.
---@return any shieldChargingSound Sound for shield charging.
---@return any shieldChargedSound Sound for shield fully charged.
function GetPlayerShipHullShield() end


--- Returns the player ship's speed as eight values: the actual speed, the targeted speed, the
--- speed per second, whether it is boosting, whether travel mode is on, whether it is matching
--- speed, and the target's speed both raw and normalised. The crosshair takes only the flag it
--- needs and skips the rest with `_`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/crosshair handling.lua:2938
---@return number actualSpeed The current actual speed.
---@return number targetedSpeed The targeted speed.
---@return number actualSpeedPerSecond The speed in units per second.
---@return boolean boosting True if the ship is boosting.
---@return boolean travelMode True if in travel mode.
---@return boolean matchSpeed True if matching speed with a target.
---@return number targetSpeed The speed of the target.
---@return number normalTargetSpeed The normal speed of the target.
function GetPlayerSpeed() end


--- Returns how hard the player is currently steering. The core target system compares it
--- against a configured limit to decide that the player is actively flying, and holds the
--- softtarget lock while that is true.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:2399
---@return number strength The current steering strength.
function GetPlayerSteeringStrength() end


--- Returns the player's current target, or nothing when there is none. The interact menu tests
--- it before offering an Attack My Target action.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_interactmenu/menu_interactmenu.lua:4971
---@return any targetID The ID of the player's target.
function GetPlayerTarget() end


--- Returns the graphics adapters that can be selected, as a list. The options menu pairs it
--- with `GetAdapterOption` to build the dropdown and mark the current one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6936
---@return table adapters A table of available adapters.
function GetPossibleAdapters() end


--- Retrieves a list of possible products for a module. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param moduleID any The ID of the module.
---@return table products A table of possible products.
function GetPossibleProducts(moduleID) end


--- Returns the resolutions the display can take, as a list of tables with `width` and `height`.
--- The options menu sorts them itself and marks the one `GetResolutionOption` reports.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7386
---@return table resolutions A table of available resolutions.
function GetPossibleResolutions() end


--- Returns the NPCs on a platform, already ordered by how interesting they are - the target
--- monitor shows the first few without ranking them itself, and the transporter menu builds its
--- room list from the same order.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_transporter.lua:814, ui/addons/ego_targetmonitor/targetmonitor.lua:776
---@param component any The platform component.
---@return table npcs A table of prioritized NPCs.
function GetPrioritizedPlatformNPCs(component) end


--- Returns the live data of a processing module. The station overview reads it per module, and
--- still checks the module with `IsValidComponent` and `IsComponentConstruction` before using
--- the result.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_station_overview.lua:2680
---@param module any The module identifier.
---@return table data The data for the processing module.
function GetProcessingModuleData(module) end


--- Returns the live production state of a module - its `state` (`producing`,
--- `waitingforresources`, `empty`) and its `cycleprogress`. It can come back empty for a module
--- that is not producing at all, and the map menu tests for that.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:17814, ui/addons/ego_detailmonitor/menu_research.lua:271
---@param module any The module identifier.
---@return table data The data for the production module, including `cycleprogress` and `state`.
function GetProductionModuleData(module) end


--- Returns the production modules of a station, as a list. Vanilla uses both the list itself
--- and just its length - `#GetProductionModules(id) > 0` is how a menu decides whether a
--- station produces anything at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2761, ui/addons/ego_detailmonitor/menu_map.lua:14498
---@param objectID any The ID of the object (e.g., station).
---@return table modules A table of production modules.
function GetProductionModules(objectID) end


--- Gets the name of the radar module. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return string name The name of the radar module.
function GetRadarModuleName() end


--- Returns the radar quality level on the engine's scale, which starts at zero; the options
--- menu adds one for its dropdown index.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7367
---@return number radarOption The current radar option.
function GetRadarOption() end


--- Returns the reference profit of a trade: the ship, the ware, the price and the amount. The
--- map menu calls it twice, once with an amount of zero and once with the real one, and shows
--- the difference - so the amount is what the comparison turns on. It can return nothing, and
--- both calls fall back with `or 0`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21721
---@param shipID any The ID of the ship.
---@param ware string The ware being traded.
---@param price number The price of the ware.
---@param amount number The amount being traded.
---@return number profit The calculated reference profit.
function GetReferenceProfit(shipID, ware, price, amount) end


--- Returns the registered game modules - tutorials and scenarios - as a list. Called with no
--- argument it leaves scenarios out; the scenario selection passes true to get them.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_help.lua:215, ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:90
---@param includeScenarios? boolean If true, includes scenarios in the list.
---@return table modules A table of registered modules.
function GetRegisteredModules(includeScenarios) end


--- Returns the mouse position relative to one element, as fractions rather than pixels:
--- `widget_fullscreen.lua` maps the result to -1..1 with `posX * 2 - 1`. `useElementSize`
--- decides whether the element's size is taken into account, and the x comes back nil when the
--- pointer is not over it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:892, ui/core/lua/monitors.lua:3633
---@param elementID any The ID of the UI element.
---@param useElementSize boolean Whether to consider the element's size.
---@return number x The relative x-coordinate.
---@return number y The relative y-coordinate.
---@return number z The relative z-coordinate (if applicable).
function GetRelativeMousePosition(elementID, useElementSize) end


--- Returns the mouse position inside a render target, in that target's own coordinates rather
--- than the screen's. Both values come back nil when the pointer is outside it, and every
--- vanilla caller passes that fact on to `C.SetMapRelativeMousePosition` as a flag.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param renderTargetID any The ID of the render target.
---@return number x The x-coordinate within the render target.
---@return number y The y-coordinate within the render target.
function GetRenderTargetMousePosition(renderTargetID) end


--- Returns the texture filename behind a render target - what you hand to `StartCutscene` or to
--- an icon so it draws what the render target holds. It can come back empty, and every vanilla
--- caller checks before using it.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param renderTargetID any The ID of the render target.
---@return string textureFilename The filename of the render target's texture.
function GetRenderTargetTexture(renderTargetID) end


--- Returns the resolution as a table with `width` and `height`. With no argument it is the
--- resolution in force; with true it is the one stored in the settings, which is how the cancel
--- branch of the change dialogue puts the old one back.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7385, ui/addons/ego_gameoptions/gameoptions.lua:8990
---@param fromSettings? boolean If true, gets the value from settings rather than the current state.
---@return any resolution The current resolution setting.
function GetResolutionOption(fromSettings) end


--- Retrieves NPCs of a specific role and skill tier from a controllable object.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:3763
---@param controllableID any The ID of the controllable object (e.g., ship).
---@param role string The role to search for (e.g., "unassigned").
---@param skillLevel number The skill level tier.
---@return table npcs A table of NPCs matching the criteria.
function GetRoleTierNPCs(controllableID, role, skillLevel) end


--- Returns one row of an Anark data table.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param table any The data table, as returned by getTable.
---@param row number Row index.
---@return any row
function getRow(table, row) end


--- Returns the controller rumble strength on the engine's 0 to 1 scale; the options menu
--- multiplies by 100 for its slider.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6741
---@return number rumble The current rumble value.
function GetRumbleOption() end


--- Returns the savegames as a table. The argument is a filter function the engine calls per
--- file - vanilla passes `Helper.validSaveFilenames`, which keeps the game's own naming scheme
--- and drops anything else in the folder.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:24909, ui/addons/ego_gameoptions/gameoptions.lua:11608
---@param filter? function An optional function to filter the save game list.
---@return table savegames A table of save game information.
function GetSaveList(filter) end


--- Returns the sectors of a cluster as a list. Walking the galaxy means `GetClusters` and then
--- this per cluster - there is no call that returns every sector at once.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:528, ui/addons/ego_detailmonitor/menu_map.lua:20887
---@param cluster any The cluster identifier.
---@return table sectors A table of sectors in the cluster.
function GetSectors(cluster) end


--- Returns a table's multi-selection: the list of selected row indexes, and the row that
--- carries the highlight border. This is where a multiselect table's state lives - not in a
--- click handler - so reading the selection means asking the widget.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID any The ID of the table.
---@return table selectedRows A table containing the indices of the selected rows.
function GetSelectedRows(tableID) end


--- Returns the sensitivity of one control range on the engine's 0 to 1 scale; the options menu
--- multiplies by 100 and clamps to its slider's range.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7602
---@param rangeID any The ID of the control range.
---@return number sensitivity The current sensitivity value.
function GetSensitivitySetting(rangeID) end


--- Returns the shader quality level on the engine's scale, which starts at zero; the options
--- menu adds one for its dropdown index.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7412
---@return number qualityOption The current shader quality setting.
function GetShaderQualityOption() end


--- Returns the shadow quality level - 0 off, 1 low, 2 medium, 3 high. Unlike its neighbours the
--- options menu uses the value as the dropdown index unchanged, which is the same offset
--- `SetShadowOption` expects back.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7429
---@return integer option 0 off, 1 low, 2 medium, 3 high.
function GetShadowOption() end


--- Global access to widget_fullscreen.widgetSystem.getShiftStartEndRow
-- Mapped from: widgetSystem.getShiftStartEndRow
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Returns the anchor and end row of the table's shift-click selection range.
-- On failure the first return is nil and the other two carry an error code and text.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID any The table widget.
---@return table|nil range { shiftStart, shiftEnd }, or nil on error.
---@return number|nil errorcode 1 invalid table element, 2 table has no non-fixed rows.
---@return string|nil errortext Human-readable reason.
function GetShiftStartEndRow(tableID) end


--- Returns the rendered size of a widget or scene element in pixels.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 26 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:864, ui/widget/lua/widget_fullscreen.lua:6645
---@param elementID any The widget or element to measure.
---@return number width
---@return number height
function GetSize(elementID) end


--- Returns whether soft shadows are on, and pairs with `SetSoftShadowsOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1766
---@return boolean enabled
function GetSoftShadowsOption() end


--- Returns whether sound output is on, and pairs with `SetSoundOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1926
---@return boolean enabled
function GetSoundOption() end


--- Gets the current Screen Space Ambient Occlusion (SSAO) setting.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7446
---@return number ssaoOption The current SSAO option.
function GetSSAOOption() end


--- Returns which of the standard title-bar buttons a frame shows - back, close, minimize and
--- help, as four values. `widget_fullscreen.lua` collects them into a table and skips the whole
--- title bar when none is set.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14217
---@param frame any The frame element.
---@return any back
---@return any close
---@return any minimize
---@return any help
function GetStandardButtons(frame) end


--- Returns the macros of the standard (non-mining, non-transport) unit types.
--- No vanilla code calls this; the return shape is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any macros
function GetStandardUnitMacros() end


--- Reads named properties of one statistic and returns one value per name, in order -
--- `"hidden"`, `"displayname"`, `"displayvalue"`. Same shape as `GetComponentData`: ask for
--- everything you need in one call. The statistic IDs come from `GetAllStatIDs`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:2527, ui/addons/ego_detailmonitor/menu_playerinfo.lua:2531
---@param stat any The statistic ID.
---@param ... string Property names, e.g. hidden, displayname, displayvalue.
---@return ... any One value per requested property, in order.
function GetStatData(stat, ...) end


--- Returns whether the steering control mode messages are shown, and pairs with
--- `SetSteeringNoteOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2183
---@return boolean enabled
function GetSteeringNoteOption() end


--- Gets whether the player ship is stopped while a menu is open.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2060
---@return boolean enabled
function GetStopShipInMenuOption() end


--- Returns the storage modules of a station or build storage, with their capacities.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:14043, ui/addons/ego_targetmonitor/targetmonitor.lua:878
---@param object any The container to inspect.
---@return table storagemodules
function GetStorageData(object) end


--- Returns the subordinates of a commander. The third argument limits the result to
--- subordinates currently rendered, which the map uses when it is drawing them; the middle one
--- is always `nil` in vanilla and its purpose is not identifiable from the call sites.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 28 vanilla call sites, 1-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:939, ui/addons/ego_detailmonitor/menu_map.lua:4902
---@param component any The commander.
---@param unknown? any Unidentified in 9.00 vanilla usage; always nil.
---@param checkRendered? boolean Restrict the result to subordinates currently rendered.
---@return table subordinates
function GetSubordinates(component, unknown, checkRendered) end


--- Gets the current subtitle setting.
--- One of auto, true, false - the ids the options menu offers.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6803
---@return any option
function GetSubtitleOption() end


--- Looks up an Anark data table by name.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param name string The table name.
---@return any table
function getTable(name) end


--- Returns how many columns a table cell's background spans.
--- 0 means the cell is covered by the background of an earlier column.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:6014
---@param tableID any The table widget.
---@param row number 1-based row index.
---@param col number 1-based column index.
---@return number colspan
function GetTableBackgroundColumnSpan(tableID, row, col) end


--- Returns the background colour of a table cell as four values. `widget_fullscreen.lua`
--- collects them into a table with `{ GetTableCellColor(...) }` to compare a row's cells
--- against each other.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:9446
---@param tableID any The table widget.
---@param row number 1-based row index.
---@param col number 1-based column index.
---@return number r
---@return number g
---@return number b
---@return number a
function GetTableCellColor(tableID, row, col) end


--- Returns how many columns a table cell spans.
--- 0 means the cell is covered by a span starting in an earlier column.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 3 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:5985
---@param tableID any The table widget.
---@param row number 1-based row index.
---@param col number 1-based column index.
---@return number colspan
function GetTableColumnSpan(tableID, row, col) end


--- Returns every column width of a table, one value per column. Vanilla collects them with `{
--- GetTableColumnWidths(tableID) }` and asks `IsTableColumnWidthPercentage` whether they are
--- pixels or percentages.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14365
---@param tableID any The table widget.
---@return table widths One entry per column.
function GetTableColumnWidths(tableID) end


--- Declared by the generator but absent from the engine.
--- No definition, no call site and no runtime presence in any version from 7.10 to 9.00.
--- Kept only so the name is documented as unavailable.
-- Environment: neither - declared here, but in no measured Lua environment
-- Versions: none - present in neither version
-- Usage: unverified - no vanilla call site
---@param ... any
---@return any
function GetTableData(...) end


--- Returns the height of all table rows together, ignoring the visible height.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14343
---@param tableID any The table widget.
---@return number height In pixels.
function GetTableFullHeight(tableID) end


--- Returns how many leading rows of a table are fixed, i.e. do not scroll.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14321
---@param tableID any The table widget.
---@return number numfixedrows
function GetTableNumFixedRows(tableID) end


--- Returns how many rows a table has, fixed header rows included - so it is the full extent,
--- not the number of selectable rows.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:5702
---@param tableID any The table widget.
---@return number numrows
function GetTableNumRows(tableID) end


--- Returns the height a table row was actually rendered at. `helper.lua` compares it against
--- the height the row asked for, which is how a menu notices that content did not fit and has
--- to be laid out again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4142, ui/widget/lua/widget_fullscreen.lua:5584
---@param tableID any The table widget.
---@param row number 1-based row index.
---@return number height
function GetTableRowHeight(tableID, row) end


--- Resolves a target-element query into the target's display information.
--- The target system uses it to build the target elements drawn around the crosshair.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:5370
---@param targetElementQuery any The query descriptor.
---@return any info
function GetTargetElementInfo(targetElementQuery) end


--- Builds the full target-monitor description for a component.
-- Source: ui\addons\ego_targetmonitor\targetmonitor.lua
-- Defined by an addon file, not by the engine, and explicitly not part of the public
-- UI API - the vanilla source says so at targetmonitor.lua:1044. Returns an empty table
-- for an invalid component.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param component any The component to describe.
---@param templateConnectionName string The connection the template is bound to.
---@param isSofttarget boolean Whether the component is the current soft target.
---@return table details
function GetTargetMonitorDetails(component, templateConnectionName, isSofttarget) end


--- Core-side bridge to GetTargetMonitorDetails, taking the component as a string ID.
--- The target monitor runs in the core Lua environment, which cannot reach the addon function
--- directly, so it calls this instead. See also GetNotificationDetails.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/monitors.lua:2129
---@param componentID string The component ID as a string.
---@param connectionName string The connection the template is bound to.
---@param isSofttarget boolean Whether the component is the current soft target.
---@return table details
function GetTargetMonitorDetailsBridge(componentID, connectionName, isSofttarget) end


--- Returns the text currently displayed by a font-string element.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:17727
---@param fontStringID any The font-string element.
---@return string text
function GetText(fontStringID) end


--- Word-wraps a string to a given width and returns the resulting lines.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 74 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:277, ui/addons/ego_detailmonitor/menu_diplomacy.lua:1354
---@param text string The text to wrap.
---@param font string Font name.
---@param fontsize number Font size, already scaled.
---@param width number Available width in pixels.
---@return table lines One string per line.
function GetTextLines(text, font, fontsize, width) end


--- Returns how many lines a string wraps to, and the width it needs.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 4 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:953, ui/widget/lua/widget_fullscreen.lua:16769
---@param text string The text to measure.
---@param fontName string Font name.
---@param fontSize number Font size, already scaled.
---@param maxWidth number Available width in pixels.
---@return number numlines
---@return number textwidth
function GetTextNumLines(text, fontName, fontSize, maxWidth) end


--- Returns a scene element's current timeline position.
--- The read counterpart of goToTime. No vanilla code calls it; signature unverified.
--- For the UI clock use getElapsedTime instead.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@return number time
function getTime(element) end


--- Global access to widget_fullscreen.widgetSystem.getTopRow
-- Mapped from: widgetSystem.getTopRow
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Returns the first non-fixed row currently scrolled into view.
-- On failure the first return is nil and the other two carry an error code and text.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID any The table widget.
---@return number|nil toprow 1-based row index, or nil on error.
---@return number|nil errorcode 1 invalid table element, 2 table has no non-fixed rows.
---@return string|nil errortext Human-readable reason.
function GetTopRow(tableID) end


--- Returns the highest-priority target messages of a category.
--- The target system uses it to pick which target elements to draw.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/targetsystem.lua:2474
---@param category string Message category, e.g. basic or fastobject.
---@param maxMessages number Maximum number of messages to return.
---@return table messages
function GetTopTargetPriorityMessages(category, maxMessages) end


--- Returns the total value of a ship, optionally priced at a specific shipyard.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:26284
---@param ship any The ship to price.
---@param unknown boolean Unidentified in 9.00 vanilla usage; always true.
---@param shipyard any The shipyard whose prices apply.
---@return number value
function GetTotalValue(ship, unknown, shipyard) end


--- Returns everything about one trade - the ware, the amounts, the price. The second argument
--- is the container it is being looked at from, which decides whether the trade reads as a buy
--- or a sell; without it the trade is described from its own side. Guard it with
--- `IsValidTrade`, because a trade can be gone by the time the row showing it is redrawn.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:1063, ui/addons/ego_detailmonitor/menu_map.lua:27498
---@param tradeID any The trade to read.
---@param component? any Container the trade is viewed from, which decides the buy/sell direction.
---@return table tradedata
function GetTradeData(tradeID, component) end


--- Returns the trade offers of a container, as seen from a given ship.
--- Vanilla passes nothing for the tradeable offers and false for the non-trade entries.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21371, ui/addons/ego_detailmonitor/menu_map.lua:21372
---@param tradeOfferContainer any The station or ship offering the trades.
---@param currentShip? any The ship the offers are evaluated for.
---@param unknown? boolean Selects which half of the list is returned.
---@return table tradeoffers
function GetTradeList(tradeOfferContainer, currentShip, unknown) end


--- Returns the trade orders currently queued.
--- No vanilla code calls this; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any orders
function GetTradeOrders() end


--- Returns the trade restrictions in effect.
--- No vanilla code calls this; the parameters and return shape are unverified.
--- ToggleFactionTradeRestriction and ToggleFactionTradeWareOverride are the setters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any restrictions
function GetTradeRestrictions() end


--- Returns the trades offered at a specific container connection.
--- No vanilla code calls this; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any trades
function GetTradesAtConnection() end


--- Returns a container's trade offers for one ware. The interact menu treats an empty result as
--- nothing to offer; what the third argument selects is not identifiable from the single call
--- site, which always passes true.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_interactmenu/menu_interactmenu.lua:6143
---@param component any The station or ship offering the trades.
---@param ware any The ware ID to filter by.
---@param unknown boolean Unidentified in 9.00 vanilla usage; always true.
---@return table tradeoffers
function GetTradesForWare(component, ware, unknown) end


--- Returns the trade-related data of a single ship.
--- No vanilla code calls this; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any shipdata
function GetTradeShipData() end


--- Returns the player ships currently available for trade orders.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:30308
---@return table ships
function GetTradeShipList() end


--- Gets the current traffic density setting.
--- No vanilla code calls the getter; SetTrafficDensityOption is its setter.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any density
function GetTrafficDensityOption() end


--- Reads a value out of an Anark data table.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param table any The data table, as returned by getTable.
---@param row number Row index.
---@param column any Column name or index.
---@return any value
function getValue(table, row, column) end


--- Returns the ventures currently known to the client.
--- No vanilla code calls this; the parameters and return shape are unverified.
--- The Online* family is the interface vanilla actually uses for ventures.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any ventures
function GetVentures() end


--- Returns the success chance of a venture.
--- No vanilla code calls this; the parameters and return shape are unverified.
--- OnlineGetVentureBaseSuccessChance is the Online* equivalent.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any chance
function GetVentureSuccessChance() end


--- Returns the game version as a string. The options menu shows it followed by
--- `C.GetBuildVersionSuffix()`, which carries the build number.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:1249
---@return string # The version string.
function GetVersionString() end


--- Returns the volume of one sound category on the engine's 0 to 1 scale; the options menu
--- multiplies by 100 for its slider, which hands it back through `SetVolumeOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7890
---@param sfxType any The sound category, as passed to SetVolumeOption.
---@return number volume In the 0-1 range.
function GetVolumeOption(sfxType) end


--- Retrieves the total cargo capacity for a specific ware on a component.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:12381, ui/addons/ego_detailmonitor/menu_map.lua:20230
---@param componentID any The ID of the component (e.g., ship, station).
---@param wareID any The ID of the ware.
---@param arg3? any Unidentified in 9.00 vanilla usage; a boolean.
---@return number capacity The total capacity for the specified ware.
function GetWareCapacity(componentID, wareID, arg3) end


--- Retrieves data for a specific ware. This is a variadic function.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 338 vanilla call sites, 2-8 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:102, ui/addons/ego_detailmonitor/menu_crafting.lua:238
---@param wareID string The ID of the ware.
---@param ... string One or more string keys for the data to retrieve (e.g., "name", "description", "price").
---@return any ... The requested ware data.
function GetWareData(wareID, ...) end


--- Returns the trades available for a ware exchange between two containers, as a list of trade
--- offers. Despite the parameter names here, the map menu passes the **ship** and the **other
--- container**, not a station and a ware.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21362
---@param stationID any The ID of the station.
---@param wareID string The ID of the ware.
---@return table tradeList A table containing the ware exchange trade list.
function GetWareExchangeTradeList(stationID, wareID) end


--- Returns the production limit set for a ware at a container - the amount the station is meant
--- to keep rather than what it holds. The map compares it against the current amount to show a
--- shortfall.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:14116, ui/addons/ego_detailmonitorhelper/helper.lua:11604
---@param componentID any The component (station or storage) to query.
---@param wareID string The ID of the ware.
---@return number limit The production limit for the ware.
function GetWareProductionLimit(componentID, wareID) end


--- Returns the width and height of the widget system - the drawing area menus lay themselves
--- out in. `Helper.viewWidth` and `Helper.viewHeight` are set from it, and are what menu code
--- normally uses.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@return number width The width of the widget system.
---@return number height The height of the widget system.
function GetWidgetSystemSize() end


--- Reports whether a text widget wraps its text. `widget_fullscreen.lua` reads it with
--- `GetAlignment` and `GetSize` when it measures a text for layout.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:13143
---@param fontStringID any The ID of the font string.
---@return boolean isWordWrapEnabled True if word wrap is enabled.
function GetWordWrap(fontStringID) end


--- Returns the workforce resource needs per race for a container - what the station has to
--- supply to keep its people. Despite the parameter name here, every vanilla call passes a
--- **container**, not a race ID, and guards it with `IsComponentClass(container, "container")`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_ship_configuration.lua:6026, ui/addons/ego_detailmonitor/menu_station_overview.lua:895
---@param raceID string The ID of the race.
---@return table resources A table of workforce resources for the race.
function GetWorkForceRaceResources(raceID) end


--- Returns a scene element to the slide it was on before the current one.
--- Sibling of goToSlide. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
function goToBackSlide(element) end


--- Advances a scene element to the next slide.
--- Sibling of goToSlide. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
function goToNextSlide(element) end


--- Moves a scene element back to the previous slide.
--- Sibling of goToSlide. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
function goToPreviousSlide(element) end


--- Checks if all resources required to craft an item are available.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:101, ui/addons/ego_detailmonitor/menu_playerinfo.lua:730
---@param componentID? any The component crafting; vanilla always passes nil.
---@param wareID? any The ID of the ware to craft.
---@param amount? number The amount to craft.
---@return boolean hasResources True if all resources are available.
function HasAllResourcesToCraft(componentID, wareID, amount) end


--- Reports whether a scene element has the given attribute.
--- Use it before getAttribute to avoid the engine's error on an unknown attribute.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@param attribute string Attribute path, e.g. position.x.
---@return boolean has
function hasAttribute(element, attribute) end


--- Checks if a container has a stock limit override for a specific ware.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:11683
---@param containerID any The ID of the container.
---@param wareID string The ID of the ware.
---@return boolean hasOverride True if a stock limit override is set.
function HasContainerStockLimitOverride(containerID, wareID) end


--- Checks if a container has a price override for a specific ware.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:10999, ui/addons/ego_detailmonitorhelper/helper.lua:11985
---@param containerID any The ID of the container.
---@param wareID string The ID of the ware.
---@param isBuyOverride boolean True to check for a buy price override, false for a sell price override.
---@return boolean hasOverride True if a price override is set.
function HasContainerWarePriceOverride(containerID, wareID, isBuyOverride) end


--- Reports whether the player currently has flight control. All three vanilla calls pass
--- nothing and read it as a question about the player: `crosshair handling.lua` activates the
--- crosshair when this is true and the game is not in external target mode. `componentID` is
--- marked optional because no vanilla code passes one, so whether the engine accepts one, and
--- what it would mean, is unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/crosshair handling.lua:1131
---@param componentID? any Optional component to ask about. No vanilla code passes one.
---@return boolean hasFlightControl True if flight control is held.
function HasFlightControl(componentID) end


--- Reports whether a faction holds a licence with another faction. Always three arguments: who
--- holds it (`"player"`), which licence, and who it is with - a trade licence is a relationship
--- between two factions, not a property of one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1780, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2103
---@param factionID string The ID of the faction.
---@param licenceID string The ID of the licence.
---@param otherFactionID? string The faction the licence applies to.
---@return boolean hasLicence True if the faction holds the licence.
function HasLicence(factionID, licenceID, otherFactionID) end


--- Reports whether a component has a shipyard. No vanilla code calls it - the menus ask
--- `GetComponentData(id, "isshipyard")`, which answers several such questions at once.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param componentID any The ID of the component.
---@return boolean isShipyard True if the component is a shipyard.
function HasShipyard(componentID) end


--- Reports whether a connection of a component carries a tag. The connection matters as much as
--- the component - the target monitor asks whether the connection the player actually triggered
--- is tagged `shipconsole`, which is a different question from whether the object has one
--- somewhere.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 15 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:376
---@param componentID any The ID of the component.
---@param connectionName string The connection on the component to check.
---@param tag string The tag to check for.
---@return boolean hasTag True if the component has the tag.
function HasTag(componentID, connectionName, tag) end


--- Reports whether a component has a wharf. No vanilla code calls it - the menus ask
--- `GetComponentData(id, "iswharf")` instead, which answers several such questions in one call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param componentID any The ID of the component.
---@return boolean hasWharf True if the component has a wharf.
function HasWharf(componentID) end


--- Reports whether any extension setting has been changed since the game started - what the
--- options menu turns into the warning icon that a restart is needed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:5903
---@return boolean haveChanged True if settings have changed.
function HaveExtensionSettingsChanged() end


--- The shared UI helper library every menu is built on.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- Registered with MakeGlobalAvailable("Helper"), so it reaches the whole addons Lua environment.
-- Carries the standard fonts, sizes and colours (Helper.standardFont, Helper.scaleX,
-- Helper.standardTextHeight), the frame and table builders, and the menu registry.
-- Not available in the core Lua environment.
-- Environment: addons only
-- Versions: 8.00, 9.00
Helper = {}


--- Hides every circle drawn with `DrawCircle`. No vanilla code calls it - the menus clear all
--- shape kinds at once with `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
function HideAllCircles() end


--- Hides every rectangle drawn with `DrawRect`. No vanilla code calls it - the menus clear all
--- shape kinds at once with `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
function HideAllRects() end


--- Hides every queued shape at once - circles, rectangles and triangles together. This is the
--- one the menus actually use; the per-kind and per-shape variants are all uncalled in vanilla.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
function HideAllShapes() end


--- Hides every triangle drawn with `DrawTriangle`. No vanilla code calls it - the menus clear
--- all shape kinds at once with `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
function HideAllTriangles() end


--- Hides one circle drawn with `DrawCircle`, by its ID. No vanilla code calls it -
--- `HideAllCircles` and `HideAllShapes` are what the menus use.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param circleID any The ID of the circle to hide.
function HideCircle(circleID) end


--- Hides the presentation. All 11 vanilla calls pass nothing and every one of them is paired
--- with `LockPresentation` - the HUD element goes to its inactive slide, hides, and locks so
--- nothing redraws it. All of them sit in `ui/core/*` files, where the presentation being
--- hidden is the current one. `clusterID` is marked optional because no vanilla code passes
--- one, so whether the engine accepts one is unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/compass.lua:438, ui/core/lua/debugline.lua:184
---@param clusterID? any Optional presentation cluster to hide. No vanilla code passes one.
function HidePresentation(clusterID) end


--- Hides one rectangle drawn with `DrawRect`, by its ID. No vanilla code calls it - the menus
--- clear shapes with `HideAllRects` or `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param rectID any The ID of the rectangle to hide.
function HideRect(rectID) end


--- Hides one triangle drawn with `DrawTriangle`, by its ID. No vanilla code calls it - the
--- menus clear shapes with `HideAllTriangles` or `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param triangleID any The ID of the triangle to hide.
function HideTriangle(triangleID) end


--- Hides the current view. Its one vanilla caller, `ego_viewhelper/viewhelper.lua:84`, passes
--- nothing and clears its own frame table afterwards, so the engine hides whatever view is up.
--- `viewID` is marked optional because no vanilla code passes one, so whether the engine
--- accepts one is unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:84
---@param viewID? any Optional view to hide. No vanilla code passes one.
function HideView(viewID) end


--- Adds to a statistic. No vanilla code calls it - the shipped menus only read statistics, with
--- `GetAllStatIDs` and `GetStatValue` - so it is there for code that has its own counters to
--- keep.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param statID string The ID of the statistic to increment.
---@param value number The value to add to the statistic.
function IncStatValue(statID, value) end


--- Runs a module's one-off setup.
-- Source: extension sn_mod_support_apis - ui\time\interface.lua, ui\time\pipe_time.lua
-- Not a game global. Two of that extension's modules declare `function Init()` at file
-- scope, so the name leaks into the addons Lua environment whenever it is installed. Takes no
-- arguments; vanilla X4 never defines or calls it.
function Init() end


--- Applies the UI scale factor to the mission bar's text and geometry.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment.
-- Environment: core only
-- Versions: 8.00, 9.00
function initMissionBarScale() end


--- Installs a DLC through Steam, by its app ID. The extensions page offers it for an entry that
--- is not installed, and `UninstallSteamDLC` for one that is.
--- Global access to widget_fullscreen.widgetSystem.installSteamDLC
-- Mapped from: widgetSystem.installSteamDLC
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:13537
---@param appid any -- The AppID of the DLC to install.
function InstallSteamDLC(appid) end


--- Global access to widget_fullscreen.widgetSystem.interruptPlayerComputer
-- Mapped from: widgetSystem.interruptPlayerComputer
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Interrupts the player's computer control, likely to regain control for the UI.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function InterruptPlayerComputer() end


--- Reports whether a table draws its border. `widget_fullscreen.lua` reads it once while
--- building the table element and caches it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14479
---@param tableID any The ID of the table.
---@return boolean isBorderEnabled True if the border is enabled.
function IsBorderEnabled(tableID) end


--- Reports whether a button is active, meaning it can be pressed. `widget_fullscreen.lua`
--- checks it before handling a hotkey, so a shortcut cannot trigger a button the menu has
--- greyed out.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:5313
---@param buttonID any The ID of the button.
---@return boolean isActive True if the button is active.
function IsButtonActive(buttonID) end


--- Reports whether this is a cheat build of the game. Vanilla puts developer-only entries
--- behind it - the map's cheat menu, the map editor's extra construction plans - so the same UI
--- code ships in both builds.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:12742, ui/addons/ego_detailmonitor/menu_mapeditor.lua:297
---@return boolean isCheatVersion True if it is a cheat version.
function IsCheatVersion() end


--- Reports whether a component is of a class - `sector`, `ship`, `station`, `zone`, `highway`,
--- `container`. It is the type test the whole UI is built on, often two at once to separate a
--- class from one that inherits it, as in zone-but-not-highway. `C.IsComponentClass` is the
--- same test through the ffi interface.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 92 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:912, ui/addons/ego_detailmonitor/menu_map.lua:1964
---@param componentID any The ID of the component.
---@param className string The name of the class to check against.
---@return boolean isClass True if the component is of the specified class.
function IsComponentClass(componentID, className) end


--- Reports whether a component is still being built. It separates a finished module from a
--- planned one throughout the station menus, and a component ID of 0 means the same thing,
--- which is why vanilla tests both together.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 32 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:8999, ui/addons/ego_detailmonitor/menu_station_configuration.lua:4668
---@param componentID any The ID of the component.
---@return boolean isConstructing True if the component is under construction.
function IsComponentConstruction(componentID) end


--- Reports whether a component is still working - not destroyed, not wrecked, not under
--- construction. The UI guards nearly everything with it: shield and hull readouts return 0
--- when it is false, and actions like comm or change formation are not offered at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 17 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:5470, ui/addons/ego_detailmonitor/menu_platformundock.lua:160
---@param componentID any The ID of the component.
---@return boolean isOperational True if the component is operational.
function IsComponentOperational(componentID) end


--- Reports whether a container's operational range covers what it is meant to reach. No vanilla
--- code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param containerID any The ID of the container.
---@return boolean isSufficient True if the range is sufficient.
function IsContainerOperationalRangeSufficient(containerID) end


--- Reports whether a conversation dialog is running. The core dialog menu checks it while
--- starting up, because a UI reload during a conversation has to find the dialog already in
--- progress rather than wait for an event that has been and gone.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:1124
---@return boolean isActive True if a dialog is active.
function IsDialogActive() end


--- Reports whether a ship may dock at a dock. Vanilla passes two, four or five arguments, so
--- everything after the dock is optional; what those extra arguments select is not identifiable
--- from the call sites, which pass a container, `true` and a boolean respectively.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 2-5 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:1031, ui/addons/ego_detailmonitor/menu_map.lua:16355
---@param shipID any The ID of the ship.
---@param dockID any The ID of the dock.
---@param arg3? any Unidentified in 9.00 vanilla usage; a container, or nil.
---@param arg4? any Unidentified in 9.00 vanilla usage; true or nil.
---@param arg5? any Unidentified in 9.00 vanilla usage; a boolean.
---@return boolean isPossible True if docking is possible.
function IsDockingPossible(shipID, dockID, arg3, arg4, arg5) end


--- Reports whether the player knows a faction. The target monitor asks before adding the
--- faction to the known items, so what the player has already met is not re-announced.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:259
---@param factionID string The ID of the faction.
---@return boolean isKnown True if the faction is known.
function IsFactionKnown(factionID) end


--- Reports whether the player is out of the pilot seat and walking. It changes what the UI may
--- do: softtargeting is refused in first person unless external target mode is on, and the
--- radar is only drawn outside it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1303, ui/addons/ego_detailmonitor/menu_map.lua:5566
---@return boolean isFirstPerson True if in first-person mode.
function IsFirstPerson() end


--- Reports whether a gamepad is in use. No vanilla code calls it: the menus ask
--- `GetControllerInfo() == "gamepad"` instead, which distinguishes gamepad, joystick and mouse
--- in one call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean isGamepadActive True if a gamepad is active.
function IsGamepadActive() end


--- Reports whether an icon property has to be re-evaluated every frame.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- True when icon, color or glowfactor is a function; nil when the icon is empty or all
-- three are static. Internal to the helper.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param cell any The cell the property belongs to.
---@param iconproperty table The icon property.
---@return boolean|nil isfunctioncell
function isIconPropertyFunctionCell(cell, iconproperty) end


--- Checks if a specific piece of information is unlocked for the player.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:5476, ui/addons/ego_detailmonitorhelper/helper.lua:13032
---@param componentid any The component the information belongs to.
---@param infoString string The information key, e.g. "name", "storage_amounts".
---@return boolean isUnlocked True if the information is unlocked.
function IsInfoUnlockedForPlayer(componentid, infoString) end


--- Reports whether a widget takes input at all. `widget_fullscreen.lua` checks the table before
--- acting on a click inside it, so a click on a display-only table is simply dropped.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:3632
---@param elementID any The ID of the UI element.
---@return boolean isInteractive True if the element is interactive.
function IsInteractive(elementID) end


--- Reports whether an item is known to the player, addressed by category and ID - `factions`,
--- `researchables`, `timeline`, or a blueprint library type. It is what greys out the entries
--- the player has not discovered yet.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:666, ui/addons/ego_detailmonitor/menu_map.lua:13796
---@param category string The category of the item.
---@param itemID string The ID of the item.
---@return boolean isKnown True if the item is known.
function IsKnownItem(category, itemID) end


--- Reports whether the game accepts Lua typed in at runtime, which is off unless the game was
--- started for it. `ego_debug` sets its own enabled flag from it, so the debug input is simply
--- absent otherwise.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_debug/debug.lua:12
---@return boolean isEnabled True if debug input is enabled.
function IsLuaDebugInputEnabled() end


--- Reports whether a macro belongs to a class - `ship_l`, `ship_xl`, `object`. It works on the
--- macro name rather than on an existing object, which is how the encyclopedia and the ship
--- comparison classify things that are not in the game world at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 65 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:978, ui/addons/ego_detailmonitor/menu_map.lua:9375
---@param macroName string The name of the macro.
---@param className string The class name to check against.
---@return boolean isClass True if the macro belongs to the class.
function IsMacroClass(macroName, className) end


--- Reports whether something blocks the line of sight to a position - a real ray-cast, which is
--- why the core target system stores the answer and reuses it for the rest of the frame.
--- `useScreenPosition` says the position is a screen position rather than world space.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:3946
---@param position any The position to check.
---@param obstructedByOwnComponent? boolean Whether the player's own component counts as an obstruction.
---@param useScreenPosition? boolean Whether the position is a screen position rather than world space.
---@return boolean isObstructed True if the position is obstructed.
function IsObstructed(position, obstructedByOwnComponent, useScreenPosition) end


--- Reports whether the game can be saved as an online save right now. The map menu makes the
--- Convert Venture Save button active from it rather than hiding the button.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:24896
---@return boolean isPossible True if an online save is possible.
function IsOnlineSavePossible() end


--- Reports whether the player is in first person. No vanilla code calls it - `IsFirstPerson` is
--- what the UI uses, and the two look like the same question asked twice.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean isFirstPerson True if in first-person mode.
function IsPlayerFirstPerson() end


--- Reports whether two component references are the same object. Component IDs cannot be
--- compared with `==` across the conversions the UI does, so every menu that looks a component
--- up in a list it already holds goes through this.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 28 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:890, ui/addons/ego_detailmonitor/menu_map.lua:7343
---@param componentA any The first component.
---@param componentB any The second component.
---@return boolean areSame True if the components are the same.
function IsSameComponent(componentA, componentB) end


--- Reports whether two trade IDs are the same trade. Trade IDs cannot simply be compared - the
--- map menu walks its buy offers with this to find the one it already holds data for.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21765
---@param tradeA any The first trade.
---@param tradeB any The second trade.
---@return boolean areSame True if the trades are the same.
function IsSameTrade(tradeA, tradeB) end


--- Reports whether the game can be saved right now - the menus make a save button active from
--- it rather than hiding it, and `C.GetSaveInquiryText()` explains why not. Vanilla passes
--- true, false or nothing at all; what the argument selects is not identifiable from the call
--- sites.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_userquestion.lua:311, ui/addons/ego_gameoptions/gameoptions.lua:6241
---@param arg1? boolean Unidentified in 9.00 vanilla usage; true or false.
---@return boolean isPossible True if saving is possible.
function IsSavingPossible(arg1) end


--- Reports whether a widget can be selected. `widget_fullscreen.lua` walks a table row cell by
--- cell with it to find the first cell the player can actually land on.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:7690
---@param elementID any The ID of the UI element.
---@return boolean isSelectable True if the element is selectable.
function IsSelectable(elementID) end


--- Reports whether the softtarget is currently held fixed. The core target system will not
--- change the softtarget while it is true, whoever took the lock with `RequestSofttargetLock`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:2464
---@return boolean isLocked True if the soft target is locked.
function IsSofttargetLocked() end


--- Reports whether the game is running against Steam. Everything that would open the Steam
--- overlay is guarded with it, because the same UI runs on builds that have no Steam at all.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 10 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13242, ui/addons/ego_gameoptions/gameoptions.lua:3437
---@return boolean isEnabled True if Steamworks is enabled.
function IsSteamworksEnabled() end


--- Reports whether a table's column widths are percentages rather than pixels.
--- `widget_fullscreen.lua` needs to know before it can adjust them for a scrollbar it has just
--- deployed.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14366
---@param tableID any The ID of the table.
---@return boolean isPercentage True if column widths are percentages.
function IsTableColumnWidthPercentage(tableID) end


--- Reports whether a table row can be selected. `widget_fullscreen.lua` walks every row once
--- after building a table and remembers the unselectable ones, so keyboard navigation can skip
--- them without asking again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site (8.00 only), 2 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:13638
---@param tableID any The ID of the table.
---@param row number The row index.
---@return boolean isSelectable True if the row is selectable.
function IsTableRowSelectable(tableID, row) end


--- Reports whether a table's navigation wraps from the last row back to the first.
--- `widget_fullscreen.lua` reads it once while building the table element and caches it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/widget/lua/widget_fullscreen.lua:14485
---@param tableID any The ID of the table.
---@return boolean isWrapAround True if wrap-around is enabled.
function IsTableWrapAround(tableID) end


--- Reports whether a text property has to be re-evaluated every frame.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- True when text, color or glowfactor is a function; nil when there is no text or all
-- three are static. Internal to the helper.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param cell any The cell the property belongs to.
---@param textproperty table The text property.
---@return boolean|nil isfunctioncell
function isTextPropertyFunctionCell(cell, textproperty) end


--- Reports whether a widget is of a given kind - `"table"`, `"editbox"` and the rest. It is how
--- vanilla walks a frame's children and decides what each one is, since the children come back
--- as opaque IDs.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 79 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2347, ui/widget/lua/widget_fullscreen.lua:1701
---@param componentID any The ID of the component.
---@param typeName string The type name to check against.
---@return boolean isType True if the component is of the specified type.
function IsType(componentID, typeName) end


--- Reports whether a component ID still refers to something that exists. Anything the UI stored
--- earlier has to be checked with it before use - a logbook entry's component, a menu's
--- remembered object - because the object can be gone by the time the player clicks the row.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 40 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4357, ui/addons/ego_detailmonitor/menu_playerinfo.lua:853
---@param componentID any The ID of the component.
---@return boolean isValid True if the component is valid.
function IsValidComponent(componentID) end


--- Reports whether a trade ID still refers to a live trade. The map menu guards `GetTradeData`
--- with it, because a trade can be gone by the time the row that shows it is redrawn.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:1063
---@param tradeID any The ID of the trade.
---@return boolean isValid True if the trade is valid.
function IsValidTrade(tradeID) end


--- Reports whether a widget element still exists. Anything holding a frame or a widget across a
--- UI reload has to check it first - the debug log guards its own frame with it, because
--- working with a freed element is what causes the errors it is there to report.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 79 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1010, ui/addons/ego_detailmonitorhelper/helper.lua:1522
---@param elementID any The ID of the widget element.
---@return boolean isValid True if the element is valid.
function IsValidWidgetElement(elementID) end


--- Reports whether a ware is illegal, given who owns it and whose police laws apply. All three
--- arguments matter: the same ware is legal or not depending on the police faction of the space
--- it is in, which is why vanilla reads `policefaction` off the current zone first and colours
--- inventory rows from the answer.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:560, ui/addons/ego_detailmonitor/menu_map.lua:14122
---@param wareID string The ID of the ware.
---@param factionID string The ID of the faction owning the ware.
---@param policeFactionID? string The faction whose police laws are checked.
---@return boolean isIllegal True if the ware is illegal.
function IsWareIllegalTo(wareID, factionID, policeFactionID) end


--- Starts listening for raw input, so the next thing the player presses is reported instead of
--- acted on - which is how the controls page reads a new binding. Despite the parameter name
--- here, the only vanilla call passes `true`, not an action name.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:5262
---@param actionName string The name of the input action to listen for.
function ListenForInput(actionName) end


--- Loads a savegame by file name. The options menu does not call it inline: it queues the call
--- as a delayed one-time update callback a tenth of a second later, so the menu that triggered
--- it is gone before the load starts.
--- Global access to widget_fullscreen.widgetSystem.loadGame
-- Mapped from: widgetSystem.loadGame
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2963
---@param filename string -- The name of the save file to load.
function LoadGame(filename) end


--- Loads an input profile - a set of key bindings. `personal` says whether it is one of the
--- player's own profiles; the Defaults button loads `"inputmap"` with false, the shipped
--- default map.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8436
---@param profileName string The name of the input profile to load.
---@param personal? boolean Whether the profile is a personal (user) profile.
function LoadInputProfile(profileName, personal) end


--- Locks the presentation so nothing redraws it. Core HUD code pairs it with
--- `HidePresentation`: the element goes to its inactive slide, the presentation hides, and the
--- lock keeps it that way until something unlocks it again.
--- Global access to widget_fullscreen.widgetSystem.lockPresentation
-- Mapped from: widgetSystem.lockPresentation
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 20 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/compass.lua:170, ui/core/lua/debugline.lua:126
function LockPresentation() end


--- Publishes a name already present in `_G` to the addons Lua environment, so other files can
--- call it. `widget_fullscreen.lua:432` defines it as the one line
--- `__EGO_GLOBALS[objectname] = _G[objectname]` - it copies the value the name currently holds
--- into `__EGO_GLOBALS`, and `SetEGOGlobals` later replays that table into each new Lua
--- environment. So it takes the name only, and the name has to hold its value already:
--- `AddGlobalAccess` assigns `_G[funcname]` first and then calls this, and `helper.lua`
--- registers `Helper` the same way.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param objectname string The name of a global already present in `_G`.
function MakeGlobalAvailable(objectname) end


--- Sets the repair priority of a destructible component. No vanilla code calls it, and neither
--- is `RepairDestructibles`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param componentID any The ID of the component.
---@param priority number The repair priority.
function MakeRepairPriority(componentID, priority) end


--- Anark 4x4 transform matrix class.
--- Instantiate with Matrix:new(). The translation sits in _41, _42 and _43; methods
--- invert() and multiply(m). calculateGlobalTransform(element, matrix) fills one in.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla reference
-- Seen at: ui/core/lua/billboard.lua:51
Matrix = {}


--- Writes an Anark runtime memory report to the debug log.
--- A development aid. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function memoryReport() end


--- The list of registered menus.
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua
-- Created as "Menus = Menus or {}" and registered with MakeGlobalAvailable("Menus").
-- Every menu file inserts its own menu table here in its init; Helper then calls
-- Helper.registerMenu on each. A menu created after Helper must call registerMenu itself.
-- Environment: addons only
-- Versions: 8.00, 9.00
Menus = {}


--- Minimises a frame to a bar, optionally with a label. `RestoreFrame` brings it back, and the
--- view helper passes `View.hasPlayerControls()` to both so the restored state matches.
--- Global access to widget_fullscreen.widgetSystem.minimizeFrame
-- Mapped from: widgetSystem.minimizeFrame
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:261
---@param frame any -- The frame to minimize.
---@param text? string -- Optional text to display on the minimized frame.
---@param hasPlayerControls? boolean -- Whether the frame has player controls.
function MinimizeFrame(frame, text, hasPlayerControls) end


--- Starts a new game from a game start module - `NewGame("x4ep1_gamestart_hub")`. Every vanilla
--- call passes only the module name, so the parameter table and its count are optional; the
--- tutorial and scenario menus store their own context in user data first, because the UI is
--- torn down as the new game starts.
--- Global access to widget_fullscreen.widgetSystem.newGame
-- Mapped from: widgetSystem.newGame
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_help.lua:446, ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:617
---@overload fun(moduleName:string)
---@param moduleName string -- The name of the game start module (e.g., "startmenu", "x4ep1_gamestart_hub").
---@param params? table -- A table of `NewGameParameter` objects.
---@param numParams? integer -- The number of parameters.
function NewGame(moduleName, params, numParams) end


---
--- Registers a notification for when the active weapon group changes.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1108
---@param contract any The UI contract to notify.
function NotifyOnActiveWeaponGroupChanged(contract) end


---
--- Registers a notification for when an environment object changes.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:2281
---@param contract any The UI contract to notify.
function NotifyOnChangedEnvironmentObject(contract) end


--- Asks to be notified on a contract when a conversation ends. Two core files register it: the
--- first person crosshair, with `NotifyOnConversationStarted`, and the sub-channel bar, which
--- shows what is being said.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/firstperson_crosshair.lua:150, ui/core/lua/subchannelbar.lua:126
---@param contract any The UI contract to notify.
function NotifyOnConversationFinished(contract) end


--- Asks to be notified on a contract when a conversation starts, registered with
--- `NotifyOnConversationFinished` so both ends are covered.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/firstperson_crosshair.lua:149
---@param contract any The UI contract to notify.
function NotifyOnConversationStarted(contract) end


--- Asks to be notified on a contract when a cutscene is ready to play, registered with
--- `NotifyOnCutsceneStopped` so both ends are covered. Core code passes its own contract; an
--- addon menu passes `getElement("Scene.UIContract")`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/customgame.lua:5134, ui/core/lua/monitors.lua:784
---@param contract any The UI contract to notify.
function NotifyOnCutsceneReady(contract) end


--- Asks to be notified when a cutscene stops, on the element passed in - here always
--- `getElement("Scene.UIContract")`, because addon menus have no contract of their own. Every
--- caller sets its own flag alongside, so it registers only once.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:3352, ui/addons/ego_detailmonitor/menu_timeline.lua:430
---@param contract any The UI contract to notify.
function NotifyOnCutsceneStopped(contract) end


--- Asks to be notified on a UI contract when mail arrives. The monitor code registers it in a
--- block with the rest of the `NotifyOn*` family on one contract, which is how the HUD
--- subscribes to everything it reacts to.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:786
---@param contract any The UI contract to notify.
function NotifyOnIncomingMail(contract) end


--- Asks to be notified on a UI contract when a missile is incoming, one of the `NotifyOn*`
--- family the monitor code registers together on a single contract.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1109
---@param contract any The UI contract to notify.
function NotifyOnIncomingMissile(contract) end


---
--- Registers a notification for when wares are added to the inventory.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1103
---@param contract any The UI contract to notify.
function NotifyOnInventoryWaresAdded(contract) end


--- Asks to be notified on a UI contract when mail is read, registered in the same block as
--- `NotifyOnIncomingMail`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:787
---@param contract any The UI contract to notify.
function NotifyOnMailRead(contract) end


--- Asks to be notified on a contract when a missile lock begins, registered with
--- `NotifyOnMissileLockLost` so the crosshair can follow the lock to either end.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1110
---@param contract any The UI contract to notify.
function NotifyOnMissileLockInitiated(contract) end


--- Asks to be notified on a contract when a missile lock is lost, registered with
--- `NotifyOnMissileLockInitiated` so the crosshair can follow the lock both ways.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1111
---@param contract any The UI contract to notify.
function NotifyOnMissileLockLost(contract) end


--- Asks to be notified on a UI contract when mission information changes, one of the
--- `NotifyOn*` family the monitor code registers together on one contract.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:788
---@param contract any The UI contract to notify.
function NotifyOnMissionInfoUpdate(contract) end


--- Asks to be notified on a contract when the mission objective bar changes, one of the
--- `NotifyOn*` family the monitor code registers together on one contract.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:789
---@param contract any The UI contract to notify.
function NotifyOnMissionObjectiveBarUpdate(contract) end


--- Asks to be notified on a contract when a notification is released, one of the `NotifyOn*`
--- family the monitor code registers together on one contract.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:790
---@param contract any The UI contract to notify.
function NotifyOnNotificationFreed(contract) end


---
--- Registers a notification for when an online operation is updated.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param contract any The UI contract to notify.
function NotifyOnOnlineOperationUpdated(contract) end


---
--- Registers a notification for when the player activity changes.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:274, ui/core/lua/crosshair handling.lua:1112
---@param contract any The UI contract to notify.
function NotifyOnPlayerActivityChanged(contract) end


---
--- Registers a notification for when the player starts controlling a flight object.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1113
---@param contract any The UI contract to notify.
function NotifyOnPlayerFlightControlStarted(contract) end


---
--- Registers a notification for when the player stops controlling a flight object.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1114
---@param contract any The UI contract to notify.
function NotifyOnPlayerFlightControlStopped(contract) end


--- Asks to be notified on a contract when a scan is aborted. The crosshair registers it with
--- `NotifyOnScanStarted` and `NotifyOnScanFinished` on its own contract, so it can follow a
--- scan from start to either end.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1115
---@param contract any The UI contract to notify.
function NotifyOnScanAborted(contract) end


--- Asks to be notified on a contract when a scan completes, the counterpart of
--- `NotifyOnScanAborted`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1116
---@param contract any The UI contract to notify.
function NotifyOnScanFinished(contract) end


--- Asks to be notified on a contract when a scan begins - registered with the aborted and
--- finished notifications, which are the two ways it can end.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1117
---@param contract any The UI contract to notify.
function NotifyOnScanStarted(contract) end


--- Asks to be notified on a UI contract when a dialog starts. It is registered from two places
--- - the dialog menu, with `NotifyOnStopDialog`, and the sub-channel bar, which wants the same
--- event for the speech it shows.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/dialogmenu.lua:323, ui/core/lua/subchannelbar.lua:127
---@param contract any The UI contract to notify.
function NotifyOnStartDialog(contract) end


--- Asks to be notified on a UI contract when a dialog ends. The core dialog menu registers it
--- together with `NotifyOnStartDialog`, so it hears both ends of a conversation.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/dialogmenu.lua:324
---@param contract any The UI contract to notify.
function NotifyOnStopDialog(contract) end


--- Asks to be notified on a contract when a teleport completes - registered by the crosshair
--- and the monitors, both of which have to redraw for the new location.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1118, ui/core/lua/monitors.lua:792
---@param contract any The UI contract to notify.
function NotifyOnTeleportSucceeded(contract) end


--- Asks to be notified on a contract when the player switches weapon group - the crosshair
--- registers it, since that is what it draws.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:1119
---@param contract any The UI contract to notify.
function NotifyOnWeaponGroupChanged(contract) end


--- Tells the game that a target element has gone off screen - the counterpart of
--- `NotifyTargetElementShown`, which the core target system does send. No vanilla code calls
--- this half.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param elementID any The ID of the element that was hidden.
function NotifyTargetElementHidden(elementID) end


--- Tells the game that a target element is now on screen, addressed by its message ID. The core
--- target system sends it once per element and keeps its own flag so it cannot be sent twice.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:5172
---@param elementID any The ID of the element that was shown.
function NotifyTargetElementShown(elementID) end


--- Asks to be notified about voice output on a UI contract. The core sub-channel bar registers
--- it next to `NotifyOnConversationFinished` on the same contract, so it hears both the speech
--- and the end of the conversation.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/subchannelbar.lua:125
---@param contract any The UI contract to notify.
function NotifyVoiceOutput(contract) end


--- Monitor handler for the game being paused.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Suspends the auto-close
-- timer and stops monitor rendering while in ticker-only mode.
-- Environment: core only
-- Versions: 8.00, 9.00
function onGamePaused() end


--- Monitor handler for the game being unpaused.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Restores the auto-close
-- timer, shifts message start times by the paused duration and re-enables rendering.
-- Environment: core only
-- Versions: 8.00, 9.00
function onGameUnpaused() end


--- Aborts the running venture. No vanilla code calls it, and the declaration carries no
--- parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineAbortVenture() end


--- Accepts a pending online team invite. No vanilla code calls it, and the declaration carries
--- no parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineAcceptTeamInvite() end


--- Activates an online user item. No vanilla code calls it, and the declaration carries no
--- parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineActivateUserItem() end


--- Adds a user to the contact list, or to the blocked list when the second argument is true.
--- The same call serves both, which is why the contact UI passes its own block flag straight
--- through.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13397
---@param userID any The ID of the user.
---@param block boolean `true` to block the user, `false` to add as a contact.
function OnlineAddContact(userID, block) end


--- Reports whether the team name may be changed. No vanilla code calls it, and neither is
--- `OnlineChangeTeamName`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean # `true` if the team name can be changed, otherwise `false`.
function OnlineCanChangeTeamName() end


--- Reports whether the player is in a position to invite someone online. No vanilla code calls
--- it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean # `true` if a user can be invited, otherwise `false`.
function OnlineCanInviteUser() end


--- Reports whether venture asset access can be unlocked. No vanilla code calls it, though
--- `OnlineIsVentureAssetAccessUnlocked` reads the same state.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean # `true` if access can be unlocked, otherwise `false`.
function OnlineCanUnlockVentureAssetAccess() end


--- Renames the player's online team. No vanilla code calls it, and neither is
--- `OnlineCanChangeTeamName`, which would say whether it is allowed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param newName string The new name for the team.
function OnlineChangeTeamName(newName) end


--- Starts checking whether an online username is free and valid. It returns nothing -
--- `helper.lua` stores its own request instance and waits for the answer to arrive.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13390
---@param username string The username to check.
function OnlineCheckUsername(username) end


--- Clears the online logbook. No vanilla code calls it, and the declaration carries no
--- parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineClearLogbook() end


--- Clears the rewards out of the online logbook, once the player has seen them - the map menu
--- calls it as the reward context frame closes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:29663
function OnlineClearLogbookRewards() end


--- Converts Brane energy, in the Ventures economy. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineConvertBraneEnergy() end


--- Creates an online team with the given name. No vanilla code calls it, though the menus do
--- call the rest of the team family - `OnlineJoinTeam`, `OnlineLeaveTeam`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param teamName string The name of the team to create.
function OnlineCreateTeam(teamName) end


--- Declines a pending online team invite. No vanilla code calls it, and the declaration carries
--- no parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineDeclineTeamInvite() end


--- Looks a contact up by user ID and returns it, or nothing when the player has no such contact
--- - `helper.lua` tests for nil to tell a new contact from a known one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13418
---@param userID any The ID of the user to find.
---@return any # The contact object if found, otherwise `nil`.
function OnlineFindContact(userID) end


--- Returns the Brane energy conversion rate. No vanilla code calls it, and neither is
--- `OnlineConvertBraneEnergy`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return number # The conversion rate.
function OnlineGetBraneEnergyConversionRate() end


--- Returns the users of a chat group. The chat window caches the result per group and treats an
--- empty table as a group it could not read.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:220
---@param groupID string The ID of the chat group.
---@return table # A list of user objects in the group.
function OnlineGetChatGroupUsers(groupID) end


--- Returns the chat messages as a list. The chat window rebuilds its whole message list from it
--- whenever its own outdated flag is set, rather than being handed new messages one by one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:263
---@return table # A list of chat message objects.
function OnlineGetChatMessages() end


--- Returns the online coalitions as a table. No vanilla code calls it, though
--- `OnlineGetCurrentCoalition` and `OnlineJoinCoalition` are both there.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table of coalition objects.
function OnlineGetCoalitions() end


--- Returns the online contact list, or the blocked list when the third argument is true.
--- `pageSize` and `startIndex` page the result; vanilla passes zero for both, which asks for
--- all of them.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13138
---@param pageSize integer The number of contacts per page.
---@param startIndex integer The starting index for pagination.
---@param blocked boolean `true` to retrieve the blocked list, `false` for the contacts list.
---@return table # A table of contact objects.
function OnlineGetContacts(pageSize, startIndex, blocked) end


--- Returns the player's current online coalition as a table with an `isvalid` field, which
--- callers test before reading the rest.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites (8.00 only), 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18312
---@return table # The current coalition object.
function OnlineGetCurrentCoalition() end


--- Returns the running venture operation as a table with an `isvalid` field. `helper.lua` reads
--- it to build the time-left string shown on the map.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6428, ui/addons/ego_detailmonitorhelper/helper.lua:11349
---@return table # The current operation object.
function OnlineGetCurrentOperation() end


--- Returns the current Ventures season as a table. Vanilla reads it next to
--- `C.GetCurrentUTCDataTime()` to work out how much of the season is left.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18999, ui/addons/ego_detailmonitorhelper/helper.lua:11360
---@return table # The current season object.
function OnlineGetCurrentSeason() end


--- Returns the player's current online team. The result always comes back as a table with an
--- `isvalid` field, which every caller tests before touching the rest - there is no nil to
--- check for.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6429, ui/addons/ego_detailmonitorhelper/helper.lua:13494
---@return table # The current team object.
function OnlineGetCurrentTeam() end


--- Returns the language selected for online features, as a code. The options menu uses it to
--- preselect the dropdown that writes back through `OnlineSetUserLanguage`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7790
---@return string # The language code (e.g., "en").
function OnlineGetCurrentUserLanguage() end


--- Returns the rewards waiting in the online logbook, as a table. The map menu shows them in a
--- context frame of their own.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3405
---@return table # A table of reward objects.
function OnlineGetLogbookRewards() end


---
--- Gets the UI order for online missions.
--- No usage found in the workspace.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table representing the mission order.
function OnlineGetMissionUIOrder() end


--- Returns the patron information of a multiverse object - the team behind a ship that belongs
--- to another player's universe. The target monitor shows it once it knows the object is an
--- online one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:855
---@param component userdata The component to get information for.
---@return table|nil # A table with patron information, or nil if not found.
function OnlineGetMultiversePatronInfo(component) end


--- Returns how many contacts the player has, or how many blocked users when the argument is
--- true. `helper.lua` asks for the count first and pages the list itself with
--- `OnlineGetContacts`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13135
---@param blocked boolean `true` to count blocked users, `false` to count contacts.
---@return integer # The number of contacts or blocked users.
function OnlineGetNumContacts(blocked) end


--- Returns how many chat messages are unread. The message ticker reads it for its chat
--- notification and caps its own display at 100.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/monitors.lua:3238
---@return integer # The number of unread messages.
function OnlineGetNumUnreadChatMessages() end


--- Returns the online missions currently offered.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: unverified - no vanilla call site
---@return any missions
function OnlineGetOnlineMissions() end


--- Returns the friend list of the platform the game is running on - Steam, GOG - as a table.
--- `helper.lua` uses it to offer platform friends as online contacts.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13438
---@return table # A table of friend objects.
function OnlineGetPlatformFriendList() end


--- Returns the public profile of a team.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: unverified - no vanilla call site
---@return any teaminfo
function OnlineGetPublicTeamInfo() end


--- Returns the ladder rankings of a scenario. It reads what is already there:
--- `OnlineRequestScenarioRankings` starts the fetch, and this is called once that has reported
--- success.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:67, ui/addons/ego_detailmonitor/menu_scenario_selection.lua:56
---@param scenarioID any The ID of the scenario.
---@return table # A table of ranking data.
function OnlineGetScenarioRankings(scenarioID) end


--- Returns the success impact of an online operation. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any # The success impact data.
function OnlineGetSuccessImpact() end


--- Returns the online team's inventory. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table representing the team's inventory.
function OnlineGetTeamInventory() end


--- Returns the pending team invitations. No vanilla code calls it, and neither is
--- `OnlineRequestTeamInvitations` - the request-then-read pair are both unused.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table of team invitation objects.
function OnlineGetTeamInvitations() end


--- Returns the invitations the team has sent out. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table of open invitation objects.
function OnlineGetTeamOpenInvitations() end


--- Returns information about the team's ventures. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table of venture information.
function OnlineGetTeamVentureInfo() end


--- Returns the online inbox messages. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return table # A table of inbox messages.
function OnlineGetUserInbox() end


--- Returns a venture's success chance before bonuses are applied.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any chance
function OnlineGetVentureBaseSuccessChance() end


--- Returns the bonuses that modify a venture's outcome.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any bonuses
function OnlineGetVentureBonusValues() end


--- Returns how long a venture takes.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any duration
function OnlineGetVentureDuration() end


--- Returns the venture logbook entries.
--- No vanilla code calls it; the parameters and return shape are unverified.
--- OnlineClearLogbook and OnlineHasVentureLogbookReward act on the same data.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any logbook
function OnlineGetVentureLogbook() end


--- Returns the reward a venture pays out.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any amount
function OnlineGetVentureRewardAmount() end


--- Returns a venture's risk rating.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any risk
function OnlineGetVentureRisk() end


--- Returns the display order of the ventures.
--- No vanilla code calls it; the parameters and return shape are unverified.
--- OnlineGetMissionUIOrder is the equivalent for online missions.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any order
function OnlineGetVentureUIOrder() end


--- Returns the ware information attached to a venture.
--- No vanilla code calls it; the parameters and return shape are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any wareinfo
function OnlineGetVentureWareInfo() end


--- Invites a user to the player's team.
--- No vanilla code calls it; the parameters are unverified.
--- OnlineCanInviteUser reports whether inviting is currently allowed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineInviteUser() end


--- Reports whether venture asset access has been unlocked.
--- No vanilla code calls it; the parameters and return shape are unverified.
--- OnlineCanUnlockVentureAssetAccess and OnlineUnlockVentureAssetAccess are the pair.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return any unlocked
function OnlineIsVentureAssetAccessUnlocked() end


--- Joins a coalition.
--- No vanilla code calls it; the parameters are unverified.
--- OnlineGetCoalitions and OnlineGetCurrentCoalition read the same data.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineJoinCoalition() end


--- Joins an arbitrary open team.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineJoinRandomTeam() end


--- Joins a specific team.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: unverified - no vanilla call site
function OnlineJoinTeam() end


--- Leaves the player's current team.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineLeaveTeam() end


--- Reports a chat message for moderation.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineReportChat() end


--- Reports a shared ship design for moderation.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineReportShip() end


--- Reports a user for moderation.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineReportUser() end


--- Starts fetching the platform friend list. It returns nothing: the result is read afterwards
--- with `OnlineGetPlatformFriendList`, the same request-then-read shape the rest of the online
--- API uses.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13402
function OnlineRequestPlatformFriendList() end


--- Starts fetching the ladder rankings of a scenario in the chosen display mode. It returns
--- nothing - the menu sets its own requested flag, waits, and then reads the result with
--- `OnlineGetScenarioRankings`; the scenario list re-requests on a ten second timer.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:58, ui/addons/ego_detailmonitor/menu_scenario_selection.lua:218
---@param scenarioID any The ID of the scenario.
---@param displayMode? any The ladder display mode to request.
function OnlineRequestScenarioRankings(scenarioID, displayMode) end


--- Starts fetching the pending team invitations, to be read afterwards with
--- `OnlineGetTeamInvitations`. No vanilla code calls either half.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineRequestTeamInvitations() end


--- Sends a chat message. With a user ID it goes to that user, with nil to the current group -
--- the chat window passes whichever its command parsing produced.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:443
---@param text string The message text.
---@param userID string|nil The ID of the recipient user or nil for the current group.
function OnlineSendChatMessage(text, userID) end


--- Sets whether the player's online team is public. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param isPublic boolean Whether the team should be public.
function OnlineSetTeamPublic(isPublic) end


--- Sets the description text attached to a user-generated-content submission.
--- No vanilla code calls it; the parameters are unverified.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: unverified - no vanilla call site
function OnlineSetUGCSubmissionText() end


--- Sets the language for online features, by language ID. The options menu passes the dropdown
--- value unchanged.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9249
---@param languageID number The ID of the language to set.
function OnlineSetUserLanguage(languageID) end


--- Writes one venture configuration value by name - the counterpart of
--- `OnlineGetVentureConfig`, which reads the same keys. The options menu sets
--- `allow_update_once` from a checkbox.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 15 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3399
---@param configName string The name of the configuration value (e.g., "allow_validation", "disable_popup").
---@param value? any The value to set.
---@return any # The value of the configuration setting.
function OnlineSetVentureConfig(configName, value) end


--- Starts a venture, by venture ID. No vanilla code calls it - like most of the `Online*`
--- family it is engine plumbing the shipped menus never reach.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param ventureID string The ID of the venture to start.
function OnlineStartVenture(ventureID) end


--- Starts fetching the team's open invitations, to be read with `OnlineGetTeamOpenInvitations`.
--- No vanilla code calls either half.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineTeamRequestOpenInvitations() end


--- Unlocks access to venture assets. No vanilla code calls it, though
--- `OnlineIsVentureAssetAccessUnlocked` reads the same state.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineUnlockVentureAssetAccess() end


--- Uploads the player's inventory items to the online service. No vanilla code calls it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function OnlineUploadPlayerInventoryItems() end


--- Uploads the statistics of a finished scenario and returns a **string** result, not a
--- boolean: vanilla treats anything other than `"success"` or `"modified"` as a failure. It is
--- only called with an online session in hand.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:137
---@param scenarioID string The ID of the scenario.
---@return boolean # True if the upload was successful.
function OnlineUploadScenarioStats(scenarioID) end


--- Sets whether the player accepts online invitations. The current value comes back as the
--- **third** return of `OnlineGetUserName`, which the options menu negates and passes straight
--- in.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9233
---@param allow boolean True to allow invitations, false to disallow.
function OnlineUserAllowInvites(allow) end


--- Sets whether the player accepts private messages. The options menu passes `not
--- OnlineUserArePrivateMessagesAllowed()`, so the pair reads and flips one setting between
--- them.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9237
---@param allow boolean True to allow private messages, false to disallow.
function OnlineUserAllowPrivateMessages(allow) end


--- Reports whether the player accepts private messages, shown as a yes or no on the online
--- options page.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7770
---@return boolean # True if private messages are allowed, false otherwise.
function OnlineUserArePrivateMessagesAllowed() end


--- Monitor handler for a notification being released by the engine.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Closes the current state
-- when the freed notification is the one on display.
-- Environment: core only
-- Versions: 8.00, 9.00
---@param _ any Unused event sender.
---@param notificationID any The notification that was freed.
function onNotificationFreed(_, notificationID) end


--- Monitor handler asking the target monitor to refresh.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Refreshes only when the
-- component and connection match what is displayed; componentID 0 refreshes a notification.
-- Environment: core only
-- Versions: 8.00, 9.00
---@param _ any Unused event sender.
---@param componentID any The component to refresh, or 0 for the current notification.
---@param connectionname string The connection name, or an empty string for none.
function onRefreshTargetMonitor(_, componentID, connectionname) end


--- Monitor handler switching the HUD into or out of ticker-only mode.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment.
-- Environment: core only
-- Versions: 8.00, 9.00
---@param _ any Unused event sender.
---@param enabled boolean Whether ticker-only mode is on.
---@param showpermanently boolean Whether the ticker stays visible rather than fading.
function onTickerOnlyMode(_, enabled, showpermanently) end


--- The per-frame update callback registered with SetScript("onUpdate", ...).
-- Source: ui\addons\ego_detailmonitorhelper\helper.lua and other addon files
-- Not one function: every file that registers an onUpdate declares its own at file
-- scope, so whichever loaded last owns the global. Declare yours as a local and pass it
-- to SetScript instead of relying on the name.
-- Environment: addons only
-- Versions: 8.00, 9.00
function onUpdate() end


--- Opens a menu by name, with up to two parameters - `"TopLevelMenu"`, `"DockedMenu"`,
--- `"MapMenu"`. The second parameter is the menu's own argument list, whose shape each menu
--- defines: the map takes `{ x, y, ... }` and can be handed a whole submenu request in it. This
--- is the call that opens a vanilla menu from anywhere, including from a mod.
--- Global access to widget_fullscreen.widgetSystem.openMenu
-- Mapped from: widgetSystem.openMenu
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 3-4 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:344, ui/addons/ego_detailmonitor/menu_docked.lua:213
---@param menuName string -- The name of the menu to open (e.g., "TopLevelMenu", "DockedMenu", "MapMenu").
---@param param1? any -- An optional parameter for the menu.
---@param param2? any -- An optional second parameter for the menu.
---@param force? boolean -- If `true`, forces the menu to open.
function OpenMenu(menuName, param1, param2, force) end


--- Opens a Steam store page in the overlay. With an app ID it opens that page, with no argument
--- the game's own; every caller checks `IsSteamworksEnabled` first, and the GOG build takes a
--- different path entirely.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3438, ui/addons/ego_gameoptions/gameoptions.lua:10557
---@param appID? number The Steam AppID of the page to open.
function OpenSteamOverlayStorePage(appID) end


--- Opens a web page in the Steam overlay. No vanilla code calls it; `OpenSteamOverlayStorePage`
--- is the one the UI uses, and both are only safe behind `IsSteamworksEnabled`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param url string The URL to open.
function OpenSteamOverlayWebPage(url) end


--- Opens the Steam Workshop page of an extension. `personal` marks one of the player's own
--- items; the options menu passes both straight from the selected extension.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8193
---@param id? string The ID of the workshop item.
---@param personal? boolean Whether the item is personal.
function OpenWorkshop(id, personal) end


--- Pauses the game. Both parameters are optional: vanilla pauses with no arguments at all, and
--- passes `nil, true` to force a pause that the player cannot lift while a scenario is
--- finished. Unpausing has its own global, `Unpause`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 0-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:85, ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:119
---@param unpause? boolean If `true`, unpauses the game.
---@param force? boolean If `true`, forces the pause/unpause action.
function Pause(unpause, force) end


--- Pauses a scene element's timeline animation.
--- The counterpart of play. No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
function pause(element) end


--- Runs one of the actions offered for a message. The core target system checks
--- `hasPossibleActions` first and then performs action type 1 - the default action of that
--- target.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/core/lua/targetsystem.lua:4368
---@param messageID any The ID of the message associated with the action.
---@param actionType integer The type of action to perform (e.g., 1).
function PerformAction(messageID, actionType) end


--- Starts or resumes a scene element's timeline animation.
--- Called from ui\core\lua\write text.lua, which does goToTime(element, 0) then
--- play(element) to restart an animation from the beginning.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/write text.lua:85
---@param element any The scene element.
function play(element) end


--- Plays an ambient sound by name. No vanilla code calls it: menus use `PlaySound` for one-shot
--- cues and `StartPlayingSound` for a loop they intend to stop again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param soundName string The name of the sound to play.
function PlayAmbientSound(soundName) end


--- Plays the game credits. No vanilla code calls it, so what the parameter selects is
--- unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param option? any An optional parameter for the credits display.
function PlayCredits(option) end


--- Plays a UI sound by name. The name is one of the game's sound cues as a plain string:
--- `ui_positive_click`, `ui_negative_back`, `ui_crafting_success`,
--- `ui_menu_dlg_btn_select_core`. This is the most-called global in the whole UI.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 154 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:730, ui/addons/ego_detailmonitor/menu_crafting.lua:117
---@param soundName string The name of the sound to play (e.g., "ui_positive_select").
function PlaySound(soundName) end


--- Loads an icon so it can be drawn without a hitch later. The exit screen prepares all of its
--- screenshots this way before showing any of them, the same way `PrepareMesh` handles meshes.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/extro.lua:78
---@param iconName string The name of the icon to prepare.
function PrepareIcon(iconName) end


--- Loads a mesh so it is ready to be drawn without a hitch. Core HUD code walks its configured
--- mesh list and prepares every one of them while setting up.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/debugline.lua:111, ui/core/lua/promo.lua:161
---@param meshName string The name of the mesh to prepare.
function PrepareMesh(meshName) end


--- Loads a render target texture so it is ready before anything draws into it. The monitor code
--- prepares both radar targets up front, so switching radar integration mode mid-flight cannot
--- stall.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/monitors.lua:796, ui/widget/lua/widget_fullscreen.lua:8777
---@param renderTargetName string The name of the render target texture.
function PrepareRenderTarget(renderTargetName) end


--- Loads a texture so it can be drawn without a hitch later, the same way `PrepareIcon` and
--- `PrepareMesh` handle their kinds. Core HUD code walks its configured texture list while
--- setting up.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/debugline.lua:114, ui/core/lua/promo.lua:164
---@param textureName string The name of the texture to prepare.
function PrepareTexture(textureName) end


--- Closes the menu and continues the flow at another section, carrying the player's choice with
--- it. `Helper.closeMenuForSection` passes two arguments, and the variant that also carries the
--- section's base parameter passes three.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1799, ui/addons/ego_detailmonitorhelper/helper.lua:1805
---@param nextSection string
---@param choiceParam? any
---@param baseParam? any
function ProceedFromMenu(nextSection, choiceParam, baseParam) end


--- Global access to widget_fullscreen.widgetSystem.quitGame
-- Mapped from: widgetSystem.quitGame
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Quits the game, closing all related processes and returning to the desktop.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8125, ui/addons/ego_gameoptions/onlineupdate.lua:96
function QuitGame() end


--- Global access to widget_fullscreen.widgetSystem.quitModule
-- Mapped from: widgetSystem.quitModule
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Quits the current module or menu, returning to the previous state or the desktop.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8127
function QuitModule() end


--- Global access to widget_fullscreen.widgetSystem.raisePlayerInteractionEvent
-- Mapped from: widgetSystem.raisePlayerInteractionEvent
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Raises a player interaction event by ID, triggering associated scripts or actions.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:1221
---@param interactionID any -- The ID of the interaction to raise.
function RaisePlayerInteractionEvent(interactionID) end


--- Returns the Lua the player has typed into the debug input, or nothing when there is none.
--- `ego_debug` polls it from its own `onUpdate` and `loadstring`s whatever comes back - which
--- is why it only works when `IsLuaDebugInputEnabled` is true.
--- Global access to widget_fullscreen.widgetSystem.readLuaDebugInput
-- Mapped from: widgetSystem.readLuaDebugInput
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_debug/debug.lua:50
---@return string -- The user input string.
function ReadLuaDebugInput() end


--- Reads a text out of the game's text database, and is by a wide margin the most-called global
--- in the UI. It takes **two** arguments - the page and the entry within that page, as in
--- `ReadText(1001, 12109)` - mirroring the `<page id>` / `<t id>` structure of the game's
--- `t/*.xml` text files. `ego_detailmonitorhelper/helper.lua` replaces the engine's own version
--- at load with a wrapper that memoises the result under `page .. "-" .. line`, which makes it
--- the one vanilla override of an engine global.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7474 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:133, ui/addons/ego_detailmonitor/menu_crafting.lua:263
---@param pageID integer The ID of the text page.
---@param textID integer The ID of the text entry within that page.
---@return string # The text content.
function ReadText(pageID, textID) end


--- A test function for reading text.
--- No usage found in the workspace.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function ReadTextTest() end


--- Registers an init function to run when the game is loaded or the UI is reloaded.
-- Source: extension sn_mod_support_apis - ui\lua_loader.lua
-- Not a game global. Part of that extension's Lua Loader API; absent from vanilla X4.
---@param init function The function to call on load.
---@param module_name? string Module name to register the init under; defaults to an empty string.
function Register_OnLoad_Init(init, module_name) end


--- Registers the value that require(module_name) should return.
-- Source: extension sn_mod_support_apis - ui\lua_loader.lua
-- Not a game global. Part of that extension's Lua Loader API; absent from vanilla X4.
---@param module_name string The module name to answer for.
---@param response any The value require returns for that name.
function Register_Require_Response(module_name, response) end


--- Registers a module's require response and its on-load init function together.
-- Source: extension sn_mod_support_apis - ui\lua_loader.lua
-- Not a game global. Part of that extension's Lua Loader API; absent from vanilla X4.
---@param module_name string The module name to answer for.
---@param response? any The value require returns for that name.
---@param init? function Function to call when the game is loaded or the UI is reloaded.
function Register_Require_With_Init(module_name, response, init) end


--- Registers the key bindings of one menu of an addon, by addon name and menu name. Vanilla
--- calls it once per menu right after `Helper.setKeyBinding`, and a menu with several binding
--- sets calls it once for each.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 17 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:607, ui/addons/ego_detailmonitor/menu_followcamera.lua:78
---@param addonName string The name of the addon.
---@param bindingName? string The name of the binding.
function RegisterAddonBindings(addonName, bindingName) end


--- Subscribes a function to a named UI event, which the engine then calls whenever that event
--- fires. Vanilla registers menu callbacks this way - `announcementReceived`,
--- `conversationCancelled`, `debugLog`. Undo it with `UnregisterEvent`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param eventName string
---@param scriptFunction function
function RegisterEvent(eventName, scriptFunction) end


--- Makes an Anark element take part in mouse interaction, so the mouse-over and click events
--- registered on it actually fire. Core HUD code calls it right after its `registerForEvent`
--- calls for that element.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 58 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/compass.lua:178, ui/core/lua/crosshair handling.lua:2195
---@param element userdata
function RegisterMouseInteractions(element) end


--- Registers the current presentation with the widget system. Takes no arguments;
--- `widget_fullscreen.lua` calls it once while setting a presentation up.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:1653
function RegisterWidget() end


--- Frees a cutscene descriptor. Every vanilla caller nils its own reference immediately
--- afterwards, so the descriptor is never used again once released.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2339, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4416
---@param cutsceneDesc userdata
function ReleaseCutsceneDescriptor(cutsceneDesc) end


--- Frees a widget descriptor. A descriptor is only the recipe for a widget, so vanilla releases
--- it as soon as the widget is built - and, for anything it holds on to, on the way out of the
--- menu.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2623, ui/addons/ego_helptext/helptext.lua:527
---@param descriptor userdata
function ReleaseDescriptor(descriptor) end


--- Frees an interaction descriptor by id - the counterpart of `CreateInteractionDescriptor`.
--- Neither is called anywhere in vanilla, so the signature is unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param id integer
function ReleaseInteractionDescriptor(id) end


--- No vanilla code calls this, so nothing here confirms what it releases or what it takes. Its
--- neighbours in the `Release*` family each free a descriptor the engine handed out, and the
--- declaration carries no parameters.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function ReleaseListener() end


--- Releases the notification the target monitor is showing, by the id it was created with. Core
--- code clears its own description state in the same breath.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/monitors.lua:1884
---@param notificationID any
function ReleaseNotification(notificationID) end


--- Frees a view descriptor. The view helper calls it before dropping its own reference, so the
--- descriptor cannot outlive the view it was built for.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:33
---@param viewDescriptor userdata
function ReleaseViewDescriptor(viewDescriptor) end


--- Takes ammunition or deployables off a component. The only vanilla call is the ware exchange
--- of the map menu, which passes the ware as a macro name and the amount to remove.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 5 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4638
---@param component userdata
---@param ware string
---@param amount integer
---@param fromPlayer? boolean
---@param notify? boolean
function RemoveAmmo(component, ware, amount, fromPlayer, notify) end


--- Takes a ware out of a component's cargo hold. The only vanilla call is the ware exchange of
--- the map menu, next to the `RemoveAmmo` call that does the same for ammunition.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4608
---@param component userdata
---@param ware string
---@param amount integer
---@param fromPlayer? boolean
function RemoveCargo(component, ware, amount, fromPlayer) end


--- Removes the highlight overlay that `ShowHighlightOverlay` created under that id.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param id string
function RemoveHighlightOverlay(id) end


--- Removes wares from an inventory. Both vanilla calls are crafting consuming its resources,
--- and both pass `nil` as the container - which is how the player's own inventory is addressed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:113, ui/addons/ego_detailmonitor/menu_playerinfo.lua:742
---@param container? userdata
---@param ware string
---@param amount integer
function RemoveInventory(container, ware, amount) end


--- Deletes one logbook entry. The index is the entry's own `index` field as the logbook data
--- carries it, not its position in a filtered list.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4385
---@param index integer
function RemoveLogbookEntry(index) end


--- Removes one entry from a list-valued parameter of a queued order. The map menu empties such
--- a list by walking it backwards and removing the last index each time, because removing
--- shifts everything after it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3046
---@param controllable userdata
---@param orderIndex integer
---@param paramID string
---@param listIndex integer
function RemoveOrderListParam(controllable, orderIndex, paramID, listIndex) end


--- Detaches a handler that `SetScript` attached. Vanilla calls it in both shapes: with two
--- arguments for a handler on the presentation itself, and with three through
--- `Helper.removeMenuScript` for one attached to a widget.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@overload fun(handleType:string, scriptFunction:function)
---@overload fun(widget:userdata, handleType:string, scriptFunction:function)
---@param widget? userdata
---@param handleType string
---@param scriptFunction function
function RemoveScript(widget, handleType, scriptFunction) end


--- Clears the current softtarget. Takes no arguments - the core target system calls it while
--- resetting, alongside notifying that no mission position is connected any more.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1747
function RemoveSofttarget() end


--- Releases a softtarget lock taken with `RequestSofttargetLock`, and returns whether the
--- request was found. `requester` has to be the same name that took the lock.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:2377
---@param requester string
---@return boolean
function RemoveSofttargetLockRequest(requester) end


--- No vanilla code calls this, so nothing here confirms what it repairs or that it takes no
--- arguments.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function RepairDestructibles() end


--- Asks for the softtarget to be held fixed, and returns whether the lock was granted.
--- `requester` names the holder - the core target system passes `"softtargetManager"` - and the
--- same name has to be handed to `RemoveSofttargetLockRequest` to let it go again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:2367
---@param requester string
---@return boolean
function RequestSofttargetLock(requester) end


--- Resets every extension setting to its default. The options menu calls it behind the Defaults
--- button of the extensions page, then clears its own changed flag.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8133
function ResetAllExtensionSettings() end


--- Resets the display options to their defaults. The options menu calls it first in the row of
--- `Restore*Options` globals behind the Defaults button.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8430
function RestoreDisplayOptions() end


--- Restores a frame that `MinimizeFrame` shrank away. `hasPlayerControls` says whether the
--- player keeps flight control while the restored frame is up - the view helper passes
--- `View.hasPlayerControls()`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:265
---@param frame userdata
---@param hasPlayerControls boolean
function RestoreFrame(frame, hasPlayerControls) end


--- Resets the gameplay options to their defaults. The options menu does not call it directly:
--- it goes through a delayed one-time callback a tenth of a second later, so the menu that is
--- being rebuilt is out of the way first.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8248
function RestoreGameOptions() end


--- Resets the graphics options to their defaults, next to `RestoreDisplayOptions` behind the
--- Defaults button.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8431
function RestoreGraphicOptions() end


--- Resets the sound options to their defaults, in the row of `Restore*Options` globals behind
--- the Defaults button.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8432
function RestoreSoundOptions() end


--- Closes the menu and hands one parameter back to whatever opened it. Component IDs have to go
--- through `Helper.convertComponentIDs` first, which is what `Helper.closeMenuAndReturn` does.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1795
---@param returnParam? any
function ReturnFromMenu(returnParam) end


--- Anark Euler rotation class.
--- Instantiate with Rotation:new(). Fields x, y, z in radians; methods add(r) and
--- lookAt(vector). See ui\core\lua\billboard.lua.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla references
-- Seen at: ui/core/lua/billboard.lua:48
Rotation = {}


--- Rounds a total price the way the game rounds trade sums, and returns the rounded integer.
--- Vanilla puts every price through it before showing it or charging for it - trade fees, ship
--- configuration totals, an average of two ware prices.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 12 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4142, ui/addons/ego_detailmonitor/menu_ship_configuration.lua:7640
---@param price number
---@return integer
function RoundTotalTradePrice(price) end


--- Makes the fullscreen mode the player just picked permanent, from the confirm branch of the
--- countdown question - the same shape as `SaveResolutionOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8867
function SaveFullscreenOption() end


--- Writes a savegame. `filename` is the file to write, `name` the label the load menu shows for
--- it; the options menu builds the filename as `"save_" .. slot`. An online game is saved with
--- `SaveOnlineGame` instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9296
---@param filename string
---@param name string
function SaveGame(filename, name) end


--- Writes an input profile - a set of key bindings - to disk. Vanilla passes three arguments
--- when it saves over a profile that exists and four when the player has just named a new one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3-4 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3404, ui/addons/ego_gameoptions/gameoptions.lua:9153
---@param filename string
---@param id string
---@param customName string
---@param isNew? boolean
function SaveInputProfile(filename, id, customName, isNew) end


--- Persists the input mapping. The three tables are the three kinds of binding the options menu
--- keeps apart: actions (a press), states (held down) and ranges (an axis).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3143
---@param actions table
---@param states table
---@param ranges table
function SaveInputSettings(actions, states, ranges) end


--- Saves an online game - the Ventures counterpart of `SaveGame`. Takes no arguments: the
--- engine decides where an online save goes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3419, ui/addons/ego_detailmonitor/menu_userquestion.lua:101
function SaveOnlineGame() end


--- Makes the resolution the player just picked permanent. The options menu shows a countdown
--- question after a resolution change and calls this from the confirm branch; the cancel branch
--- reads the old value back with `GetResolutionOption(true)` instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8984
function SaveResolutionOption() end


--- Queues a reload of the whole UI. `helper.lua` calls it when a menu's view cannot be created,
--- immediately before raising the error that abandons the menu.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4266
function ScheduleReloadUI() end


--- No vanilla code calls this, so nothing here confirms what it does or that it takes no
--- arguments. By its name it picks the back option of the dialog `SelectDialogOption` selects a
--- button in.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SelectBackOption() end


--- Moves a table's selection to a column. Used together with `SelectRow` to put the cursor back
--- on a remembered cell after the table is rebuilt.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID string
---@param column integer
function SelectColumn(tableID, column) end


--- Activates a dialog button as if the player had clicked it. The core dialog menu plays the
--- selection sound, calls this, and then hides itself.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/dialogmenu.lua:746
---@param button userdata
function SelectDialogOption(button) end


--- Selects or deselects one data point of a graph widget, addressed by its record and data
--- index. It returns three values - `helper.lua` reads them as a result it ignores, an error
--- flag and the error text - although the declaration here documents none of them.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param graphID string
---@param recordIdx integer
---@param dataIdx integer
---@param selected boolean
function SelectGraphDataPoint(graphID, recordIdx, dataIdx, selected) end


--- Moves a table's selection to a row, as if the player had clicked it. Vanilla only ever
--- passes `tableID` and `row` - to restore a remembered selection after a table is rebuilt. The
--- remaining parameters come from the older function list and no vanilla call exercises them.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID string
---@param row integer
---@param modified? boolean
---@param input? any
---@param source? any
---@param settableinteractive? boolean
function SelectRow(tableID, row, modified, input, source, settableinteractive) end


--- The script object attached to the current scene element.
--- Only meaningful in ui/core/lua/*.lua element code, the files that define
--- "function self:onInitialize()"). self.element is the element the script is attached
--- to; the engine calls self:onInitialize, self:onActivate, self:onDeactivate and
--- self:onUpdate on it, and the script stores its own state as fields of self.
--- Inside a method defined with a colon the parameter shadows this global.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1578 vanilla references
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:3534, ui/core/lua/billboard.lua:36
self = {}


--- Picks the graphics adapter. The options menu passes the index of the dropdown entry the
--- player chose.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8518
---@param option integer
function SetAdapterOption(option) end


--- Sets the aim assist level. The options menu passes the dropdown index minus one, so the
--- engine's own scale starts at zero.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8199
---@param option number
function SetAimAssistOption(option) end


--- Toggles the autoroll flight option. Argument-less, like the other option toggles behind the
--- game settings checkboxes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8204
function SetAutorollOption() end


--- Toggles autosaving. The options menu refreshes itself afterwards, because the setting
--- changes what else the page shows.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8208
function SetAutosaveOption() end


--- Toggles the boost-as-toggle input option. Like the other argument-less `Set*Option` globals
--- it flips the current value rather than taking one: the checkbox reads `GetBoostToggleOption`
--- and its callback passes nothing.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8223
function SetBoostToggleOption() end


--- Recolours an existing button widget in place, from separate red, green, blue and alpha
--- values.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 5 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1486, ui/addons/ego_detailmonitorhelper/helper.lua:2655
---@param buttonID string
---@param r number
---@param g number
---@param b number
---@param a number
function SetButtonColor(buttonID, r, g, b, a) end


--- Replaces the label of an existing button widget in place, without rebuilding the table it
--- sits in.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 26 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1215, ui/addons/ego_detailmonitorhelper/helper.lua:4336
---@param buttonID string
---@param text string
function SetButtonText(buttonID, text) end


--- Toggles high quality screenshot capture. Argument-less, like the other graphics option
--- toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8537
function SetCaptureHQOption() end


--- Puts a prepared widget descriptor into one cell of a table, and returns whether it worked.
--- The descriptor is the caller's to release afterwards, which is what `helper.lua` does unless
--- told to keep it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 4 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2621
---@param tableID string
---@param descriptor userdata
---@param row integer
---@param column integer
---@return boolean
function SetCellContent(tableID, descriptor, row, column) end


--- Sets the character density graphics option. No vanilla code calls it, so nothing here
--- confirms whether it toggles the value like the other argument-less `Set*Option` globals or
--- takes one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetCharacterDensityOption() end


--- Toggles the collision avoidance assist. Argument-less, like the other flight assist toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8233
function SetCollisionAvoidanceAssistOption() end


--- Renames a component - a ship, a station or the player's empire. Every vanilla call comes
--- from an edit box being deactivated, so the name is whatever the player typed; the empire is
--- renamed by passing the player component itself.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:25037, ui/addons/ego_detailmonitor/menu_mapeditor.lua:971
---@param component userdata
---@param name string
function SetComponentName(component, name) end


--- Toggles whether the mouse pointer is confined to the game window. Argument-less, like the
--- other input option toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9121
function SetConfineMouseOption() end


--- Sets a manual stock limit for one ware at one container, overriding what the station would
--- keep. Vanilla clamps the value to at least 1.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:12502
---@param container userdata
---@param ware string
---@param limit integer
function SetContainerStockLimitOverride(container, ware, limit) end


--- Sets a manual price for one ware at one container, overriding the price the station would
--- compute. `isBuy` picks the buy or the sell side. `HasContainerWarePriceOverride` reports
--- whether one is in place, and the station configuration menu sets the global price factor to
--- -1 alongside it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:4684, ui/addons/ego_detailmonitor/menu_station_configuration.lua:1487
---@param container userdata
---@param ware string
---@param isBuy boolean
---@param price integer
function SetContainerWarePriceOverride(container, ware, isBuy, price) end


--- Toggles whether crash reports are sent. Argument-less, like the other option toggles the
--- privacy page calls.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9283
function SetCrashReportOption() end


--- Sets the controller deadzone from the slider value the options menu passes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9112
---@param value number
function SetDeadzoneOption(value) end


--- Sets the colour of an Anark material, red, green and blue only. Core HUD code always follows
--- it with `setAttribute(element, "opacity", a)`, because the alpha is an element attribute
--- rather than part of the material colour.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 125 vanilla call sites, 4 arguments
-- Seen at: ui/core/lua/compass.lua:481, ui/core/lua/crosshair handling.lua:2628
---@param material userdata
---@param r number
---@param g number
---@param b number
function SetDiffuseColor(material, r, g, b) end


--- Toggles the distortion graphics option. The quality preset path calls it right after
--- `SetGfxQualityOption(0)`, which is the custom quality level.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8563
function SetDistortionOption() end


--- Sets the effect distance on the engine's 0 to 1 scale - the options menu divides its slider
--- by 100 and rounds to two decimals - preceded by `SetGfxQualityOption(0)` to drop the preset
--- to Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8686
---@param distance number The effect distance.
function SetEffectDistanceOption(distance) end


--- Copies the registered globals into an environment table - the mechanism a separate Lua
--- environment uses to receive them, alongside `__EGO_GLOBALS`. No vanilla code calls it, but
--- its presence is what tells the addons Lua environment apart from the core one.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param env table The environment table to populate with globals.
function SetEGOGlobals(env) end


--- Writes one extension setting: the extension ID, whether it is a personal one, the setting
--- name and its value. The global settings are addressed with an empty ID -
--- `SetExtensionSettings("", false, "sync", value)` is how the options menu writes the global
--- sync flag.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 4 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3370
---@param id string The ID of the extension.
---@param personal boolean `true` if the setting is personal.
---@param settingName string The name of the setting to set.
---@param value any The value to set for the setting.
function SetExtensionSettings(id, personal, settingName, value) end


--- Sets the field of view. The options menu divides its slider by 90, so the engine's own value
--- is a factor around 1 rather than an angle in degrees.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8706
---@param value number The FOV value to set.
function SetFOVOption(value) end


--- Switches the presentation to one-to-one pixel mapping. The core target system warns in a
--- comment that this can change the resolution, so screen information has to be read back
--- **after** the call, not before.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/targetsystem.lua:940
function SetFullScreenOneToOne() end


--- Sets the fullscreen mode from the dropdown entry, passed unchanged - windowed, fullscreen or
--- borderless, depending on where the entry sits in the list.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8850
---@param setting integer The setting value (e.g., 0 for windowed, 1 for fullscreen).
function SetFullscreenOption(setting) end


--- Switches the presentation to full screen world space. The monitor code calls it once while
--- setting its render settings up.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/core/lua/monitors.lua:818
function SetFullScreenWorldSpace() end


--- Sets the gamepad mode from the dropdown index minus one - the same offset the other input
--- dropdowns use.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9094
---@param option integer The gamepad mode to set.
function SetGamepadModeOption(option) end


--- Sets the gamma correction. The options menu divides its 0-100 slider by 100, so the engine's
--- own range is 0 to 1.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8891
---@param value number The gamma value to set.
function SetGammaOption(value) end


--- Sets the graphics quality preset. Passing 0 selects Custom, which is why every individual
--- graphics setter calls `SetGfxQualityOption(0)` first: changing one detail drops the preset
--- out of Low, Medium or High.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8541
---@param option integer The graphics quality option to set.
function SetGfxQualityOption(option) end


--- Sets the glow quality level. The options menu passes the dropdown index minus one, and calls
--- `SetGfxQualityOption(0)` first - changing any single quality setting drops the preset to
--- Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8899
---@param option integer The glow option to set.
function SetGlowOption(option) end


--- Sets the height of a widget. No vanilla code calls it, and the declaration carries no
--- parameters, so what it would take is unverified - `SetWidth` next to it takes the widget and
--- a pixel width.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetHeight() end


--- Puts an icon into an Anark material or texture element. Colour and size are optional: core
--- HUD code passes `nil, nil, nil` to keep the icon's own colours, or a full white `255, 255,
--- 255` tint, and adds width and height only where the icon has to be scaled to a panel.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 44 vanilla call sites, 6-8 arguments
-- Seen at: ui/core/lua/crosshair handling.lua:988, ui/core/lua/crosshair handling.lua:2226
---@param material userdata The material to set the icon for.
---@param iconID string The ID of the icon to set.
---@param r? number Optional red color value.
---@param g? number Optional green color value.
---@param b? number Optional blue color value.
---@param useTextureColor? boolean Optional flag to use the texture color.
---@param width? number Optional width for the icon.
---@param height? number Optional height for the icon.
function SetIcon(material, iconID, r, g, b, useTextureColor, width, height) end


--- Inverts one axis of a control range, by range ID and parameter name. Vanilla passes two
--- arguments, so the value is optional and the call toggles the setting - the same shape as the
--- argument-less option toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9103
---@param uiRangeID number The ID of the UI range.
---@param parameterName string The name of the parameter to set.
---@param value? boolean The value to set (true/false).
function SetInversionSetting(uiRangeID, parameterName, value) end


--- Assigns a joystick to a slot, by slot number and device GUID. The options menu refreshes
--- afterwards, because the other slots' choices change with it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9227
---@param slot integer The slot number to set.
---@param guid string The GUID of the joystick.
function SetJoysticksOption(slot, guid) end


--- Toggles the legacy shader path. No vanilla code calls it, though `GetLegacyShadersOption` is
--- read - so the option is shown but set somewhere else.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetLegacyShadersOption() end


--- Sets the level of detail on the engine's 0 to 1 scale - the options menu divides its slider
--- by 100 - preceded by `SetGfxQualityOption(0)` to drop the preset to Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8930
---@param value number The LOD value to set.
function SetLODOption(value) end


--- Writes a line into the Lua debug output. The debug menu uses it to report a failed
--- `loadstring` of what the player typed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debug/debug.lua:55
---@param message string The debug message to set.
function SetLuaDebugOutput(message) end


--- Sets the main mission target message. No vanilla code calls it, and the declaration carries
--- no parameters.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetMainMissiontargetMessage() end


--- Sets a station's maximum budget. It is always set together with `SetMinBudget`, and vanilla
--- always makes the maximum one and a half times the minimum - the manager may spend down to
--- the minimum and hold up to the maximum.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:17772, ui/addons/ego_detailmonitor/menu_playerinfo.lua:963
---@param station userdata The station to set the budget for.
---@param budget integer The budget amount.
function SetMaxBudget(station, budget) end


--- Sets the menu position. No vanilla code calls it, and the declaration carries no parameters,
--- so nothing here says what it would take.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetMenuPosition() end


--- Sets a station's minimum budget, the amount its manager keeps back. Always set with
--- `SetMaxBudget`, which vanilla puts at one and a half times this value.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:17773, ui/addons/ego_detailmonitor/menu_playerinfo.lua:964
---@param station userdata The station to set the budget for.
---@param budget integer The budget amount.
function SetMinBudget(station, budget) end


--- Replaces the mouse cursor with a named one for as long as the override lasts - `crossarrows`
--- while a station module is being dragged, `default` to put the normal pointer back. The map
--- menu pairs it with its own `removeMouseCursorOverride`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param cursorIcon? string The icon to use as the cursor.
function SetMouseCursorOverride(cursorIcon) end


--- Toggles whether mouse look is a toggle or a hold. Argument-less, like the other input option
--- toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8278
function SetMouseLookToggleOption() end


--- Overrides the mouse-over handling of a widget. Both vanilla calls pass `nil` as the
--- override, which clears it - the map does this when it stops driving its own mouse-over text
--- - so what a non-nil override does is not confirmed here.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param widgetID string The ID of the widget.
---@param override boolean `true` to enable override, `false` to disable.
---@param forceHide? boolean `true` to force hide, `false` to show normally.
function SetMouseOverOverride(widgetID, override, forceHide) end


--- Puts the mouse into its sleeping state. No vanilla code calls it, and the declaration
--- carries no parameters.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetMouseSleeping() end


--- Writes one value onto an NPC's blackboard, where Mission Director code can read it. The key
--- is the MD variable name including its `$` - the trader inventory menu sets `$TradeDone` to
--- true when a trade completes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_trader_inventory.lua:538
---@param entity userdata The NPC entity to set the blackboard for.
---@param key string The key of the value to set.
---@param value any The value to set.
function SetNPCBlackboard(entity, key, value) end


--- Sets NPC skill levels. No vanilla code calls it, and the declaration carries no parameters,
--- so nothing here says what it would take.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetNPCSkill() end


--- Sets one parameter of a queued order. `orderIndex` is the position in the queue, or the
--- string `"default"` or `"planneddefault"` for the default order slots; `paramID` is the
--- parameter's 1-based position, and `listIndex` addresses one entry of a list-valued parameter
--- or is `nil` for a plain one. Component values have to go through `ConvertStringToLuaID`
--- first.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 90 vanilla call sites, 5 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:2975, ui/addons/ego_detailmonitor/menu_ship_configuration.lua:1761
---@param controllable userdata The controllable object (e.g., ship).
---@param orderIndex integer|"default"|"planneddefault" The order to modify: queue index, or the default/planned-default slot.
---@param paramID integer The 1-based index of the parameter to set.
---@param listIndex? integer Optional index for list parameters.
---@param value any The value to set for the parameter.
function SetOrderParam(controllable, orderIndex, paramID, listIndex, value) end


--- Toggles whether crash reports carry the player's user ID. Argument-less, like the other
--- privacy toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9287
function SetPersonalizedCrashReportsOption() end


--- Replaces the mouse pointer over one element with a named pointer, for as long as the
--- override stands - `UnsetPointerOverride` takes it off again. Core code sets it on the
--- elements it has just registered for mouse interaction.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/monitors.lua:2297, ui/core/lua/targetsystem.lua:4249
---@param element userdata The UI element to override the pointer for.
---@param pointerID string The ID of the pointer to set.
function SetPointerOverride(element, pointerID) end


--- Moves a presentation element to one of the fixed screen positions, by number and element ID.
--- The monitor code uses it to park the plain message ticker at position 3.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/monitors.lua:1325
---@param position integer The position to set.
---@param id string The ID of the presentation element.
function SetPresentationPosition(position, id) end


--- Marks one message as the priority mission target, by position ID and message ID, so the HUD
--- gives it the guidance treatment. Both are optional: the core target system calls it with the
--- current target's pair, and with nothing when there is no priority target left.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/targetsystem.lua:2004
---@param posID? any Optional position ID.
---@param messageID? any Optional message ID.
function SetPriorityMissionTargetMessage(posID, messageID) end


--- Sets the radar quality level. The dropdown index minus one, preceded by
--- `SetGfxQualityOption(0)` to drop the preset to Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8960
---@param option integer The radar option to set.
function SetRadarOption(option) end


--- Turns the noise overlay of a render target on or off. Vanilla switches it off once the
--- cutscene that was rendering into that target has stopped.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param renderTargetID string The ID of the render target.
---@param active boolean `true` to activate noise, `false` to deactivate.
function SetRenderTargetNoise(renderTargetID, active) end


--- Sets the pixel size of a render target, addressed by its texture string rather than by its
--- widget ID. `widget_fullscreen.lua` scales the noise overlay to match in the same breath.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:13951
---@param textureString string The texture string of the render target.
---@param width number The width to set.
---@param height number The height to set.
function SetRenderTargetSize(textureString, width, height) end


--- Sets the resolution to a width and a height. The options menu pulls both out of the
--- `"width:height"` string of the dropdown entry, and the change only becomes permanent when
--- `SaveResolutionOption` confirms it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8967
---@param width number The width of the resolution.
---@param height number The height of the resolution.
function SetResolutionOption(width, height) end


--- Sets the controller rumble strength. The options menu divides its 0-100 slider by 100, so
--- the engine's range is 0 to 1.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8353
---@param value number The rumble value to set.
function SetRumbleOption(value) end


--- Attaches a handler to a widget, or to the presentation itself. With two arguments it is
--- global - `SetScript("onHotkey", menu.onHotkey)`, `SetScript("onUpdate", onUpdate)` - and
--- with three the first is the widget the handler belongs to. `RemoveScript` takes it off
--- again, and menu code normally goes through `Helper.setMenuScript`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@overload fun(handleType:string, scriptFunction:function)
---@overload fun(widget:userdata, handleType:string, scriptFunction:function)
---@param widget? userdata Optional widget to set the script for.
---@param handleType string The type of handle (e.g., "event", "hotkey").
---@param scriptFunction function The script function to set.
function SetScript(widget, handleType, scriptFunction) end


--- Sets the multi-selection of a table: `rows` is the list of selected row indexes, `curRow`
--- the one the cursor sits on. The selection and the current row are separate things, which is
--- why vanilla falls back to `Helper.currentTableRow` when it has no row of its own to pass.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID string The ID of the table.
---@param rows table A table of row indices to select.
---@param curRow integer The current row index.
function SetSelectedRows(tableID, rows, curRow) end


--- Sets the sensitivity of one control range, by range ID and configuration name. The options
--- menu divides its 0-100 slider by 100 and rounds to two decimals, so the engine's own range
--- is 0 to 1.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9166
---@param rangeID string The ID of the range to set.
---@param configName string The name of the configuration to set.
---@param value number The value to set.
function SetSensitivitySetting(rangeID, configName, value) end


--- Sets the shader quality level from the dropdown index minus one, preceded by
--- `SetGfxQualityOption(0)` to drop the preset to Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9005
---@param option integer The shader quality option to set.
function SetShaderQualityOption(option) end


--- Sets the shadow quality level, preceded by `SetGfxQualityOption(0)` to drop the preset to
--- Custom. Unlike its neighbours it takes the dropdown index unchanged, not the index minus
--- one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9013
---@param option integer The shadow option to set.
function SetShadowOption(option) end


--- Sets the value a slider cell shows. The third argument raises or lowers the slider's maximum
--- at the same time, which is what lets a slider whose range depends on other choices follow
--- them; vanilla passes two arguments when only the value moves.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param sliderCellID string The ID of the slider cell.
---@param value number The value to set.
---@param newMaxSelect? number Optional new maximum select value.
function SetSliderCellValue(sliderCellID, value, newMaxSelect) end


--- Toggles soft shadows, preceded by `SetGfxQualityOption(0)` to drop the graphics preset to
--- Custom. Argument-less, like the other toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9019
function SetSoftShadowsOption() end


--- Sets the softtarget and returns whether it worked. The core target system passes a **message
--- ID**, not a component - the ID of the target element it is connecting - a boolean for
--- instant interaction or first person mode, and true to force the set, so the parameter names
--- this declaration carries do not match how vanilla calls it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:1316
---@param componentid userdata The ID of the component.
---@param connectionname? string Optional connection name.
---@param forceSet? boolean Optional flag to force the set action.
---@return boolean, boolean
function SetSofttarget(componentid, connectionname, forceSet) end


--- Toggles sound output as a whole. Argument-less, like the other option toggles; the options
--- menu refreshes afterwards because the rest of the sound page depends on it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9338
function SetSoundOption() end


--- Sets the ambient occlusion quality level. The dropdown index minus one, preceded by
--- `SetGfxQualityOption(0)` to drop the preset to Custom.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9026
---@param option integer The SSAO option to set.
function SetSSAOOption(option) end


--- Sets a statistics value. No vanilla code calls it, and the declaration carries no
--- parameters, so nothing here says which stat or which value it would take. `IncStatValue` is
--- the one the UI does use.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetStatValue() end


--- Toggles the steering control mode messages. Argument-less, like the other game option
--- toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8237
function SetSteeringNoteOption() end


--- Toggles whether the player's ship stops while a menu is open. Argument-less, like the other
--- game option toggles.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8379
function SetStopShipInMenuOption() end


--- Sets the subtitle mode from the dropdown entry the player chose, passed unchanged.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8385
---@param option any
function SetSubtitleOption(option) end


--- Sets the background colour of one table cell, addressed by table, row and cell index, from
--- separate red, green, blue and alpha values. `helper.lua` reaches for it when a cell's
--- background colour is a function that has just returned something new.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 7 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:4283
---@param tableID number The ID of the table.
---@param rowIndex number The index of the row.
---@param cellIndex number The index of the cell.
---@param r number The red color value.
---@param g number The green color value.
---@param b number The blue color value.
---@param a number The alpha color value.
function SetTableCellColor(tableID, rowIndex, cellIndex, r, g, b, a) end


--- Sets the text of a text widget or table cell. The widget comes **first** and the string
--- second - `SetText(private.fpsDebugLogText, " ")` - and the first argument is the widget ID
--- a call such as `GetCellContent` or `GetCellText` returns, not the widget object. Vanilla
--- records one gotcha in a comment of its own at `ego_debuglog/debuglog.lua:1274`: passing an
--- empty string does not clear the text, so it passes a single space instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:1276, ui/addons/ego_detailmonitorhelper/helper.lua:2646
---@param widgetID any The ID of the text widget or table cell.
---@param text string The text to set.
function SetText(widgetID, text) end


--- Sets the colour of a text widget from separate red, green, blue and alpha values.
--- `Helper.updateCellText` uses it to recolour a cell's text in place, after `GetCellText` has
--- handed it the widget.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 5 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:2648
---@param elementID number The ID of the text element.
---@param r number The red color value.
---@param g number The green color value.
---@param b number The blue color value.
---@param a number The alpha color value.
function SetTextColor(elementID, r, g, b, a) end


--- Writes one left/right text row of the target monitor.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. A row whose text is live is
-- queued for per-frame update instead of being written once.
-- Environment: core only
-- Versions: 8.00, 9.00
---@param lefttext table { element, textdata } for the left half.
---@param righttext table { element, textdata } for the right half.
---@param component any The component the row describes.
---@param connection any The connection the row describes.
---@param isoverlay boolean Whether the row is drawn in the ticker overlay.
function setTextLine(lefttext, righttext, component, connection, isoverlay) end


--- Switches an Anark material element between drawing its texture and drawing a flat colour.
--- The core target system sets it on the normal and selected materials of an element together,
--- so both states behave the same way.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/targetsystem.lua:2993
---@param element number The ID of the element.
---@param useColor boolean `true` to use the color, `false` to use the texture.
function SetTextureColorMode(element, useColor) end


--- Scrolls a table so a given row is the first one visible. No vanilla code calls it, but the
--- declaration reports the failure shape the widget API uses elsewhere - nil, an error code and
--- an error message.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param tableID number The ID of the table.
---@param row number The index of the row to set as the top row.
---@return nil, number, string @`nil, errorcode, errormessage`
function SetTopRow(tableID, row) end


--- Sets the traffic density. No vanilla code calls it, and the declaration carries no
--- parameters, so whether it toggles or takes a value is unverified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function SetTrafficDensityOption() end


--- Turns UI safe mode on or off - the mode that loads the UI without extensions. The options
--- menu queues it as a delayed one-time callback and passes `not GetUISafeModeOption()`, so the
--- option toggles itself after the menu is out of the way.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3380
---@param enable boolean `true` to enable safe mode, `false` to disable.
function SetUISafeModeOption(enable) end


--- Writes a value into an Anark data table.
--- Part of the data-port API around AKDataPort. No vanilla code calls it; unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param table any The data table, as returned by getTable.
---@param row number Row index.
---@param column any Column name or index.
---@param value any The value to store.
function setValue(table, row, column, value) end


--- Puts a ship into virtual cargo mode, where the trade dialogue can show a cargo state that
--- has not happened yet. Vanilla passes two arguments to switch it off and three to switch it
--- on, so `tradeCount` is optional: it is the number of trade computer orders to account for,
--- or -1 for all of them.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:2027, ui/addons/ego_detailmonitor/menu_map.lua:21335
---@param componentID number The ID of the component.
---@param enable boolean `true` to enable virtual cargo mode, `false` to disable.
---@param tradeCount? number The number of trade computer orders to account for, or -1 for all of them. Omitted when disabling.
function SetVirtualCargoMode(componentID, enable, tradeCount) end


--- Puts a highlight overlay up under an id, to be taken down again with
--- `RemoveHighlightOverlay`. Vanilla passes only the id, so the style this declaration names is
--- optional.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param id string The ID of the highlight overlay.
---@param style? string The style of the highlight overlay.
function ShowHighlightOverlay(id, style) end


--- Raises a Mission Director signal on an object: the object, the signal name, and up to two
--- parameters. This is how a menu talks back to MD - `"docked_player_trade_added"`,
--- `"npc_mission_delivery"`, `"accept"` on a mission offer actor. Vanilla passes two, three or
--- four arguments, so the parameters are optional, and any component among them goes through
--- `ConvertStringToLuaID` first.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 15 vanilla call sites, 2-4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3656, ui/addons/ego_detailmonitor/menu_map.lua:4155
---@param objectID any The ID of the object to signal.
---@param param string The parameter to send with the signal (commonly SignalID)
---@param param2? any Optional second signal parameter (commonly a luaID).
---@param param3? any Optional third signal parameter.
function SignalObject(objectID, param, param2, param3) end


--- Starts the autopilot towards a target. No vanilla code calls it, and neither is
--- `StopAutoPilot`; the menus drive the autopilot through the player activity instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param targetID any The ID of the autopilot target.
function StartAutoPilot(targetID) end


--- Starts a conversation with an actor from inside a menu. The parameters have to go through
--- `Helper.convertComponentIDs` first, and `helper.lua` wraps the call in a result function so
--- it runs as the menu closes rather than while it is still up.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1828
---@param conversationName string The name of the conversation to start.
---@param actorID any The ID of the actor to converse with.
---@param conversationParam? any Conversation parameters, component IDs already converted.
function StartConversationFromMenu(conversationName, actorID, conversationParam) end


--- Starts a cutscene from a descriptor built by `CreateCutsceneDescriptor`, rendering into the
--- given render target texture, and returns a handle for `StopCutscene`. Every vanilla call
--- passes two arguments, so the cinematic-mode flag is optional.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 15 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2390, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4475
---@param descriptor table The cutscene descriptor.
---@param renderTarget? any The render target texture to play the cutscene into.
---@param interruptCinematicMode? boolean Whether starting the cutscene interrupts cinematic mode.
---@return any cutsceneHandle The handle for the started cutscene.
function StartCutscene(descriptor, renderTarget, interruptCinematicMode) end


--- Starts a sound and returns a handle for it, for a sound meant to keep playing - the map
--- menu's ambience. Stop it again with `StopPlayingSound` and that handle; a one-shot cue uses
--- `PlaySound` instead, which returns nothing.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6108
---@param soundName string The name of the sound to play.
---@return any soundHandle The handle for the playing sound.
function StartPlayingSound(soundName) end


--- Starts a sub-conversation from inside a menu - `StartConversationFromMenu` with the
--- enclosing conversation's base parameter carried along. Both parameter sets have to go
--- through `Helper.convertComponentIDs`, and the call runs as the menu closes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 4 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1815
---@param conversationName string The name of the sub-conversation to start.
---@param actorID? any The actor to converse with.
---@param conversationParam? any Conversation parameters, component IDs already converted.
---@param baseParam? any Base conversation parameters, component IDs already converted.
function StartSubConversationFromMenu(conversationName, actorID, conversationParam, baseParam) end


--- Stops the autopilot. No vanilla code calls it, and neither is `StartAutoPilot` called; the
--- menus stop it through the player activity instead, with `C.StopPlayerActivity`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function StopAutoPilot() end


--- Stops a running cutscene by the handle `StartCutscene` returned. Vanilla nils its own handle
--- straight afterwards and releases the descriptor with `ReleaseCutsceneDescriptor`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2335, ui/addons/ego_detailmonitor/menu_playerinfo.lua:4412
---@param cutsceneID number The ID of the cutscene to stop.
function StopCutscene(cutsceneID) end


--- Stops a looping sound by the handle `StartPlayingSound` returned. Vanilla keeps the handle
--- on the menu (`menu.sound_ambient`) and nils it after stopping.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 14 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:2206, ui/addons/ego_detailmonitor/menu_mapeditor.lua:1429
---@param soundHandle number The handle of the sound to stop.
function StopPlayingSound(soundHandle) end


--- Switch to a different interactive object.
---
--- This function is used to change the current interactive object, typically in response to user input.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:5480
---@return number newWidgetID # The ID of the new interactive widget.
function SwitchInteractiveObject() end


--- Tells the game that the target monitor's interaction has gone. No vanilla code calls it, nor
--- its counterpart `TargetMonitorInteractionShown`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function TargetMonitorInteractionHidden() end


--- Hide the interaction for the target monitor by interaction ID.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:1770
---@param interactionID any The ID of the interaction to hide.
function TargetMonitorInteractionHidden2(interactionID) end


--- Tells the game that the target monitor's interaction is up. No vanilla code calls it, nor
--- its counterpart `TargetMonitorInteractionHidden`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
function TargetMonitorInteractionShown() end


--- Tells the game that a target monitor interaction is on screen, with its ID, its text and
--- whether it is a notification - the version the monitor code actually calls, unlike the
--- argument-less `TargetMonitorInteractionShown`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/monitors.lua:2770
---@param interactionID any The ID of the interaction to show.
---@param interactionText string The text of the interaction.
---@param isNotification boolean Whether the interaction is a notification.
function TargetMonitorInteractionShown2(interactionID, interactionText, isNotification) end


--- Toggles one trade restriction for a faction. No vanilla code calls it, and neither is
--- `ToggleFactionTradeWareOverride` next to it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param factionID string The ID of the faction.
---@param restrictionID string The ID of the trade restriction to toggle.
function ToggleFactionTradeRestriction(factionID, restrictionID) end


--- Toggles a per-ware trade override for a faction. No vanilla code calls it, and neither is
--- `ToggleFactionTradeRestriction` next to it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param factionID string The ID of the faction.
---@param wareID string The ID of the ware to toggle the override for.
function ToggleFactionTradeWareOverride(factionID, wareID) end


--- Returns a readable string for any Lua value, tables included. `ego_debug/debug.lua:20`
--- defines it at file scope on purpose - vanilla's own comment says it is global "so it can be
--- used in all addons for debugging" - and that is what leaks it into the addons Lua
--- environment. A string comes back quoted through `%q`; a table is expanded into
--- `[key] = value` pairs for as many levels as `recursiondepth` allows, recursing with one less
--- depth and one more `DebugConfig.reprIndentStep` of indent per level; anything else comes back
--- as `tostring`. Both trailing parameters default, so vanilla calls it with one, two or three
--- arguments.
-- Source: ui\addons\ego_debug\debug.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param value any The value to represent.
---@param recursiondepth? integer How many table levels to expand. Defaults to `DebugConfig.reprRecursionDepth`.
---@param indent? string Indent prefix for the nested lines. Defaults to the empty string.
---@return string repr The string representation of the value.
function ToReprString(value, recursiondepth, indent) end


---
--- Returns a string containing a traceback of the current execution stack.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 10 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:3544, ui/core/lua/compass.lua:61
---@return string # The stack traceback.
function TraceBack() end


--- Transfers an inventory from a specified container to the player.
---
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_trader_inventory.lua:505
---@param wareID any The ware to transfer.
---@param amount number The amount to transfer.
---@param container any The source container.
function TransferInventoryToPlayer(wareID, amount, container) end


--- Transfers a specified amount of money from a source component to the player.
---
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 10 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3853, ui/addons/ego_detailmonitor/menu_map.lua:17780
---@param amount number The amount of money to transfer.
---@param sourceComponent any The source component to transfer money from.
---@param reason? string Transaction category, e.g. "sellship".
function TransferMoneyToPlayer(amount, sourceComponent, reason) end


--- Moves wares out of the player's inventory into a container. The amount is positive: the
--- trader menu negates its own signed amount before passing it, since the sign is what told it
--- which direction the trade went.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_trader_inventory.lua:507
---@param wareID any The ware to transfer.
---@param amount number The amount to transfer (negative in vanilla usage).
---@param container any The destination container.
function TransferPlayerInventoryTo(wareID, amount, container) end


--- Transfers a specified amount of money from the player to a destination component.
---
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3498, ui/addons/ego_detailmonitor/menu_playerinfo.lua:977
---@param amount number The amount of money to transfer.
---@param destinationComponent userdata The destination component to transfer money to.
function TransferPlayerMoneyTo(amount, destinationComponent) end


--- Truncates a text string to fit within a given width, using a specified font and font size.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 58 vanilla call sites, 4-6 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1374, ui/addons/ego_detailmonitor/menu_help.lua:416
---@param text string The text to truncate.
---@param font string The font name to use for width calculation.
---@param fontsize number The font size to use for width calculation.
---@param width number The maximum width the text should occupy.
---@param arg5? any Unidentified in 9.00 vanilla usage; a boolean.
---@param arg6? any Unidentified in 9.00 vanilla usage; a height.
---@return string # The truncated text.
function TruncateText(text, font, fontsize, width, arg5, arg6) end


--- Uninstalls a DLC through Steam, by its app ID. The extensions page calls it on an entry that
--- is installed, and installs it the other way round.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:13535
---@param dlcID string The ID of the DLC to uninstall.
function UninstallSteamDLC(dlcID) end


--- Unpauses the game. Every vanilla caller passes nothing and guards the call with its own
--- `menu.paused` flag, so the parameter the declaration carries is unexercised.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:75, ui/addons/ego_detailmonitor/menu_ship_configuration.lua:916
---@param arg1? boolean Unidentified in 9.00 vanilla usage; true.
function Unpause(arg1) end


--- Unregisters all key bindings associated with a specific addon.
---
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:299, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:278
---@param addonName string The name of the addon whose bindings should be unregistered.
---@param bindingName? string A single binding to unregister; omit to unregister all of the addon's bindings.
function UnregisterAddonBindings(addonName, bindingName) end


--- Removes a callback registered with `RegisterEvent`, by the same event name and function.
--- Menus unregister every event they registered in their cleanup - passing the same function
--- reference, not a copy.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param eventName string The name of the event.
---@param scriptFunction function The callback function to unregister.
function UnregisterEvent(eventName, scriptFunction) end


--- Takes an element out of mouse interaction again, the counterpart of
--- `RegisterMouseInteractions`. Core code unregisters element by element as a panel goes away.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/crosshair handling.lua:2205, ui/core/lua/monitors.lua:1826
---@param element? any The element whose mouse interactions are unregistered.
function UnregisterMouseInteractions(element) end


--- Clears the pointer override on an element. The core target system walks every pick element
--- of a target and clears them one at a time when the target is dropped.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:4382
---@param element? any The element whose pointer override is removed.
function UnsetPointerOverride(element) end


--- Resumes a conversation that was suspended while a menu was up. `helper.lua` queues it as a
--- one-time update callback rather than calling it inline, because what follows it has to
--- happen after the conversation is running again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:1941
function UnsuspendConversation() end


--- Rebuilds one frame from its descriptor and returns the new frame, without tearing the whole
--- view down. The nine flags after the descriptor are the same ones `CreateView` and
--- `CloseFrame` take, because updating a frame re-evaluates what stays on screen around it. The
--- view helper is the only vanilla caller.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 10 arguments
-- Seen at: ui/addons/ego_viewhelper/viewhelper.lua:63
---@param frameDesc any The frame descriptor to update.
---@param suppressDisplayErrors? boolean Whether display errors are suppressed.
---@param hasPlayerControls? boolean Whether the player has control.
---@param useMiniWidgetSystem? boolean Whether to use the mini widget system.
---@param startAnimation? boolean Whether to start the frame animation.
---@param keepHUDVisible? boolean Whether to keep the HUD visible.
---@param keepCrosshairVisible? boolean Whether to keep the crosshair visible.
---@param showTickerPermanently? boolean Whether to show the ticker permanently.
---@param blurBackground? boolean Whether to blur the background.
---@param usePanelMode? boolean Whether to use panel mode.
function UpdateFrame(frameDesc, suppressDisplayErrors, hasPlayerControls, useMiniWidgetSystem, startAnimation, keepHUDVisible, keepCrosshairVisible, showTickerPermanently, blurBackground, usePanelMode) end


--- Refreshes the target monitor's "Press <key>" interaction hint.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Does nothing unless
-- config.displayPressHint is set.
-- Environment: core only
-- Versions: 8.00, 9.00
function updateInteractiveText() end


--- Recomputes the screen extents of the radar and the message ticker.
-- Source: ui\core\lua\monitors.lua
-- Core Lua environment only - not reachable from the addons Lua environment. Chooses between the separate
-- radar and the radar drawn inside the ticker, and pushes the result to SetMonitorExtents.
-- Environment: core only
-- Versions: 8.00, 9.00
function updateRadarExtents() end


--- Anark 3-component vector class.
--- Instantiate with Vector:new(). Fields x, y, z; methods set(x, y, z), setVector(v),
--- subtract(v) and transform(matrix). See ui\core\lua\billboard.lua.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla references
-- Seen at: ui/core/lua/billboard.lua:46
Vector = {}


--- The view helper, which owns the frames of the currently displayed view.
-- Source: ui\addons\ego_viewhelper\viewhelper.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@class View
---@field currentFrames number Frames rendered since the view was displayed.
---@field maxFrames number Frame budget before the view is considered settled.
---@field menus table The menus taking part in the view.
---@field frames table The frames of the view.
---@field viewDescriptor any The descriptor the view was created from.
---@field displayView function Displays the view.
---@field updateMenu function Updates one participating menu.
---@field closeFrames function Closes the view's frames.
---@field hideView function Hides the view.
View = {}


--- Returns the player's numeric relation to a faction, as shown in the UI.
--- Pair it with C.GetUIRelationName for the localised name and colour of the same value.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1264, ui/addons/ego_detailmonitor/menu_docked.lua:426
---@param id any The faction ID.
---@return number relation Roughly -30 to +30; at or below -25 the faction is hostile.
function GetUIRelation(id) end

--- Returns the time in seconds since the UI was started.
--- The scene-graph clock, unaffected by game pause; it is what the target monitor and
--- the chat window time their fades and timeouts against.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 310 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:165, ui/addons/ego_detailmonitor/menu_diplomacy.lua:544
---@return number seconds
function getElapsedTime() end


--------------------------------------------------------------------------------
-- Engine globals missed by the generator.
-- Signatures verified against vanilla call sites in extracted 9.00.
--------------------------------------------------------------------------------

--- Scene element API (Anark scene graph) ---

--- Looks up a scene element by name, optionally relative to a parent element.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 892 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:31, ui/addons/ego_detailmonitor/menu_diplomacy.lua:297
---@param name string Element name or dotted path, e.g. "Scene.UIContract".
---@param parent? any Parent element to search within; searches the scene root when omitted.
---@return any element
function getElement(name, parent) end


--- Sets one attribute of an Anark scene element - the core HUD's basic verb. The attribute is a
--- path, so a vector is written one component at a time (`"scale.x"`, `"rotation.y"`), and text
--- is written as `"textstring"`. `getAttribute` reads the same paths back. It exists in the
--- addons Lua environment too, but there is nothing there to use it on.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1030 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/billboard.lua:207, ui/core/lua/compass.lua:192
---@param element any The scene element.
---@param attribute string Attribute path, e.g. "position.x", "opacity", "scale.x".
---@param value any The value to assign.
function setAttribute(element, attribute, value) end


--- Reads one attribute of an Anark scene element, by the same path `setAttribute` writes -
--- `"scale.y"`, `"pivot.x"`, `"billboardType"`. Core HUD code reads a value, adjusts it and
--- writes it back; a nil answer is how it detects an element reference that never resolved.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 90 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/billboard.lua:42, ui/core/lua/compass.lua:380
---@param element any The scene element.
---@param attribute string Attribute path, e.g. "position.z".
---@return any value
function getAttribute(element, attribute) end


--- Clones an Anark scene element under a new name and returns the copy. It is how core HUD code
--- builds a repeated element: one master in the presentation, then a clone per item -
--- `"button2"`, `"missilelockclone3"` - each named so it can be found again.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 48 vanilla call sites, 1-2 arguments
-- Seen at: ui/core/lua/compass.lua:164, ui/core/lua/loading.lua:204
---@param master any The element to clone.
---@param name? string Name for the clone.
---@return any element
function clone(master, name) end


--- Switches an Anark element to a named slide - the core HUD's way of showing and hiding
--- things. `"active"` and `"inactive"` are the two every vanilla element has, and an element
--- goes to its inactive slide before the presentation hides.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 398 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/compass.lua:345, ui/core/lua/crosshair handling.lua:1664
---@param element any The scene element.
---@param slide string The slide name, e.g. "active".
function goToSlide(element, slide) end


--- Moves an Anark element's timeline to a given time, which is how the core HUD drives every
--- bar and gauge: the element is authored as an animation from empty to full, and the fill is a
--- position on it. Vanilla guards the call with its own remembered value, so an unchanged bar
--- is not re-driven every frame.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 24 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/crosshair handling.lua:2499, ui/core/lua/loading.lua:515
---@param element any The scene element.
---@param time number The target time.
function goToTime(element, time) end


--- Returns which slide an Anark element is on, as an index and a name. Core code reads the name
--- to test what state an element is in - the loading screen checks it rather than tracking the
--- state itself.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/loading.lua:369
---@param element any The scene element.
---@return any index
---@return string slide
function getCurrentSlide(element) end


--- Registers a callback for a named Anark event on an element. Almost every vanilla call passes
--- `getElement("Scene.UIContract")` as the element - the UI contract is where the game raises
--- its events - with names like `inputModeChanged`, `chatMessageReceived` and `gameplanchange`.
--- It is the Anark counterpart of `RegisterEvent`, which needs no element.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 480 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:31, ui/addons/ego_detailmonitor/menu_diplomacy.lua:651
---@param event string The event name, e.g. "inputModeChanged".
---@param element any The element raising the event, commonly getElement("Scene.UIContract").
---@param callback function? The handler to invoke.
function registerForEvent(event, element, callback) end


--- Removes a callback registered with `registerForEvent`, by the same event, element and
--- function. Every menu that registers on the UI contract unregisters in its cleanup - passing
--- `getElement("Scene.UIContract")` again, since the element is part of the identity.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 18 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:297, ui/addons/ego_detailmonitor/menu_docked.lua:248
---@param event string The event name.
---@param element any The element raising the event.
---@param callback function The handler to remove.
function unregisterForEvent(event, element, callback) end


--- Registers a callback fired when an element attribute changes.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/counteract rotation.lua:39, ui/core/lua/propagate attribute.lua:53
---@param element any The scene element.
---@param attribute string The attribute to watch.
---@param callback function The handler to invoke.
function registerForChange(element, attribute, callback) end


--- Removes an attribute watch added with `registerForChange`, by the same element, attribute
--- and function. Anark behaviours undo their watches in `self:onDeactivate()`, one call per
--- attribute they registered.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/counteract rotation.lua:44, ui/core/lua/propagate attribute.lua:59
---@param element any The scene element.
---@param attribute string The watched attribute.
---@param callback function The handler to remove.
function unregisterForChange(element, attribute, callback) end


--- Writes an element's global transform into a matrix you pass in - it fills the matrix rather
--- than returning one. `billboard.lua` uses it on the render camera and then reads the
--- translation out of `_41`, `_42`, `_43` to find where the camera actually is.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/billboard.lua:107
---@param element any The scene element.
---@param matrix any The matrix to populate.
function calculateGlobalTransform(element, matrix) end


--- Returns the screen width and height in pixels. This is the real screen, not the widget
--- system's drawing area - `GetWidgetSystemSize` is that - and core code scales its layout
--- against it: `1080 / height` is how the crosshair works out its own factor.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 16 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:802, ui/addons/ego_gameoptions/gameoptions.lua:6677
---@return number width
---@return number height
function getScreenInfo() end


--- Widget system exports (AddGlobalAccess in widget_fullscreen.lua) ---

--- Puts up the input bar along the bottom of the screen, from a height and two lists of input
--- descriptors, left and right. New in 9.00. `helper.lua` follows it with
--- `Helper.getWidgetSystemSizes`, because the bar takes room away from the widget system.
--- `UpdateInputBar` changes its contents, `RemoveInputBar` takes it down.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
---@param height number Bar height.
---@param inputsLeft table Input descriptors shown on the left.
---@param inputsRight table Input descriptors shown on the right.
function CreateInputBar(height, inputsLeft, inputsRight) end


--- Replaces the contents of the input bar that `CreateInputBar` put up, without rebuilding it.
--- New in 9.00. `helper.lua` uses it when the bar already exists and creates one otherwise.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
---@param inputsLeft table Input descriptors shown on the left.
---@param inputsRight table Input descriptors shown on the right.
function UpdateInputBar(inputsLeft, inputsRight) end


--- Removes the input bar that `CreateInputBar` put up. New in 9.00. `helper.lua` follows it
--- with `Helper.getWidgetSystemSizes`, because dropping the bar changes how much room the
--- widget system has.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
function RemoveInputBar() end


--- Returns the widget system dimensions and scaled border/scrollbar sizes.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
---@return table sizes width, height, table_borderSize, tableRowGroups_borderSize, scrollBar_width, scrollBar_sliderWidth, scrollBar_borderSize
function GetWidgetSystemSizes() end


--- Computes the width usable by table columns after borders and scroll bar.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param width number Total available width.
---@param offsetX number Horizontal offset of the table.
---@param numColumns? integer Column count, defaults to 1.
---@param hasScrollBar? boolean Whether a scroll bar is reserved.
---@return number usableWidth
function GetUsableTableWidth(width, offsetX, numColumns, hasScrollBar) end


--- Registered but **never actually created**: `widget_fullscreen.lua` publishes it with
--- `AddGlobalAccess("IsFullscreenWidgetSystem", widgetSystem.isFullscreenMode)`, and
--- `widgetSystem.isFullscreenMode` is defined nowhere in that file. The registration therefore
--- stores nil, so the name exists in neither version. A vanilla bug: calling it fails.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: neither - declared here, but in no measured Lua environment
-- Versions: none - present in neither version
---@return boolean
function IsFullscreenWidgetSystem() end


--- Sets the width of a text widget in pixels, which is what makes its text wrap at that width.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2 arguments
-- Seen at: ui/widget/lua/widget_fullscreen.lua:13044
---@param widgetID any The boxtext or fontstring widget ID.
---@param width number The width in pixels.
function SetWidth(widgetID, width) end


--- Game API ---

--- Creates an order on a controllable and appends it to its queue.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 32 vanilla call sites, 6-10 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:3467, ui/addons/ego_detailmonitor/menu_map.lua:3487
---@param controllable any The controllable object.
---@param orderDefinition string The order definition ID, e.g. "Attack".
---@param params table|boolean The order parameters, or false when the order takes none.
---@param default? boolean Whether the order becomes the default order.
---@param plannedDefault? boolean Whether the order becomes the planned default order.
---@param priority? boolean Whether the order is queued as a priority order.
---@param arg7? any Unidentified in 9.00 vanilla usage; passed the same value as the caller's "immediate", or nil.
---@param arg8? any Unidentified in 9.00 vanilla usage; always nil.
---@param arg9? any Unidentified in 9.00 vanilla usage; passed "immediate" or nil.
---@param arg10? any Unidentified in 9.00 vanilla usage; always true.
---@return integer orderIndex
function CreateOrder(controllable, orderDefinition, params, default, plannedDefault, priority, arg7, arg8, arg9, arg10) end


--- Returns unit storage data for an object, optionally filtered by unit type.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:16180, ui/addons/ego_detailmonitor/menu_map.lua:22295
---@param objectID any The object to query.
---@param unitType? string Unit type filter, e.g. "transport".
---@return table data Includes a capacity field.
function GetUnitStorageData(objectID, unitType) end


--- Returns the transport unit macros a ship macro can carry. The map uses only the length - a
--- ship with an empty list cannot transport units and is dropped from the list being offered.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:30321
---@param macro string The ship macro name.
---@return table macros
function GetTransportUnitMacros(macro) end


--- Returns whether UI safe mode is on - the mode that loads the UI without extensions. The
--- options menu combines it with `C.GetModifiedBasegameUIFilesExtensions()` to decide whether
--- to warn that base game UI files are being replaced.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:444
---@return boolean
function GetUISafeModeOption() end


--- Sets the volume of one sound category. The category is a string, and the value runs 0 to 1 -
--- the options menu divides its 0-100 slider by 100 and rounds to two decimals.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9333
---@param sfxType string The sound category.
---@param value number Volume in the 0-1 range.
function SetVolumeOption(sfxType, value) end


--- Projects a UI element position onto the screen and returns its x, y, z and whether it is on
--- screen. The two sizes are the space to reserve around it, which is what makes the on-screen
--- test account for the element's extent rather than a bare point.
--- `GetUIElementRectangleScreenPosition` is the version that returns a rectangle.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:3643
---@param posID any The element position ID.
---@param sizeX number Reservation width.
---@param sizeY number Reservation height.
---@return number x
---@return number y
---@return number z
---@return boolean onScreen
function GetUIElementScreenPosition(posID, sizeX, sizeY) end


--- Projects a UI element position onto the screen as a **rectangle**: x, y, z, whether it is on
--- screen, and the rectangle's width and height. The minimum size and maximum scale bound how
--- large it may be drawn, and the core target system asks for the rectangle first, because
--- whether a target is off screen depends on the extent rather than the centre point.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:3445
---@param posID any The element position ID.
---@param minSize number Minimum rectangle size.
---@param maxScale? number Maximum rectangle scale.
---@return number x
---@return number y
---@return number z
---@return boolean onScreen
---@return number width
---@return number height
function GetUIElementRectangleScreenPosition(posID, minSize, maxScale) end


--- Requests notification when an object becomes known to the player.
-- Environment: addons + core
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6105
---@param element any The contract element, commonly getElement("Scene.UIContract").
function NotifyOnSetKnownToPlayer(element) end


--- Returns the target parameters accepted by a diplomatic action.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:450
---@param actionID any The diplomatic action ID.
---@return table parameters
function GetDiplomaticActionTargetParameters(actionID) end


--- Returns the permitted values for a diplomacy operation parameter.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:2250
---@param operationID integer The operation ID.
---@return table values
function GetDiplomaticActionOperationParamValues(operationID) end


--- Starts a diplomatic operation - an action ID, the agent who carries it out, its parameters,
--- and optionally a ware to offer as a gift - and returns a handle for the started operation,
--- which the diplomacy menu keeps to follow it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 4 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:464
---@param actionID any The diplomatic action ID.
---@param agentID any The agent carrying out the operation.
---@param parameters table The operation parameters.
---@param giftWare? any Optional gift ware.
function StartDiplomacyActionOperation(actionID, agentID, parameters, giftWare) end


--- Returns the venture outcomes waiting to be shown, as a table. The map menu treats an empty
--- table as nothing to report, with `next(outcomes) ~= nil`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:18326
---@return table outcomes
function GetVentureOutcomes() end


--- The hook the game's unit tests call to report that a test ran - `ui/core/lua/unittests.lua`
--- calls `TestCallback("test1")`. **It is never defined**: no vanilla file assigns it and
--- it exists in neither version, so calling `unittests.lua` outside a test harness would
--- fail on a nil value.
-- Environment: neither - declared here, but in no measured Lua environment
-- Versions: none - present in neither version
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/unittests.lua:28
---@param name string The callback name.
function TestCallback(name) end


--- Online / Ventures API ---

--- Reports whether an online session is established. It is the gate in front of everything
--- online: menu entries appear behind it, ladder requests are only made with it, and the
--- venture pages are hidden without it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 25 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:24874, ui/addons/ego_detailmonitor/menu_playerinfo.lua:370
---@return boolean
function OnlineHasSession() end


--- Reports whether this game is registered for online play. Only asked once there is a session
--- - `OnlineHasSession` is the question that comes first.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:11968
---@return boolean
function OnlineIsGameRegistered() end


--- Reports whether the game is running as an online game. `Helper.isOnlineGame` is nothing but
--- a wrapper around it, and that is what menu code uses.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:11197
---@return boolean
function OnlineIsOnlineModeActive() end


--- Reports whether a session token from an earlier run is still stored - what the login page
--- uses to tick its Remember Me box for the player.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:11975
---@return boolean
function OnlineHasPreviousSessionToken() end


--- Reports whether the player is in a valid venture team. It gates the whole team-facing part
--- of the UI - the connection status on the map, and the chat notification element in the
--- ticker.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:10172, ui/core/lua/monitors.lua:1695
---@return boolean
function OnlineIsCurrentTeamValid() end


--- Reports whether a venture logbook reward is waiting to be claimed.
--- `Helper.hasVentureRewards` is a one-line wrapper around it, and that is what menu code uses.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:11209
---@return boolean
function OnlineHasVentureLogbookReward() end


--- Returns whether the online service considers this game version incompatible, and how. The
--- options menu branches on it before offering anything that would need the service.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6041, ui/addons/ego_gameoptions/onlineupdate.lua:145
---@return any state
function OnlineGetVersionIncompatibilityState() end


--- Returns the logged-in online user as two values, the display name and the user ID. Most
--- callers only want the second: comparing the user ID against a ladder ranking or a contact
--- entry is how the UI finds the player's own row.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:255, ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:408
---@return string name
function OnlineGetUserName() end


--- Returns one value of the venture configuration the service publishes, by key -
--- `allow_validation`, `disable_popup`, `allow_update`. The options menu branches on several of
--- them to decide which venture context menu to show.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:450
---@param key string The configuration key, e.g. "allow_update".
---@return any value
function OnlineGetVentureConfig(key) end


--- Returns the online items the user owns, keyed by ware. Vanilla merges them with the normal
--- inventory, so venture items show up alongside what the player is carrying. It is one of the
--- few globals a mod is known to override - both UIX and `sn_mod_support_apis` wrap it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 12 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:6517, ui/addons/ego_detailmonitor/menu_playerinfo.lua:1623
---@return table items
function OnlineGetUserItems() end


--- Returns how many of one ware the online user owns. The station configuration menu subtracts
--- what is already placed to decide whether another limited module may still be added.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_station_configuration.lua:2072
---@param ware string The ware ID.
---@return integer amount
function OnlineGetUserItemAmount(ware) end


--- Logs in to the online service and returns whether the attempt started. `remember` stores the
--- session token for the next start; the options menu clears its own attempt flag when the call
--- returns false.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3296
---@param username string The user name.
---@param remember boolean Whether to store the session token.
function OnlineLogIn(username, remember) end


--- Logs out of the online service. The options menu clears the privacy policy flag and its own
--- registration state around the call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3342
function OnlineLogOut() end


--- Sets whether the player's forum name may be shown against their online activity. The options
--- menu passes the result of a comparison, `option == "forumname"`, so the dropdown's other
--- entry means anonymous.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:9268
---@param allow boolean Whether attribution is allowed.
function OnlineUserAllowForumAttribution(allow) end


--- Starts refreshing the contact list from the service. New in 9.00. The map menu calls it as
--- the venture contact list opens, so the team IDs shown are current rather than whatever was
--- last fetched.
-- Environment: addons only
-- Versions: 9.00 only - new in 9.00, absent from 8.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:2557
function OnlineRequestContactList() end


--- Mutes or unmutes an online contact, by user ID. The context menu of the contact list calls
--- it and closes itself afterwards.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13627
---@param userID any The contact user ID.
---@param mute boolean Whether to mute.
function OnlineMuteContact(userID, mute) end


--- Removes a contact from the player's online contact list, by user ID. The interact menu's
--- Remove Contact entry calls it and then closes the context menu.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13632
---@param userID any The contact user ID.
function OnlineRemoveContact(userID) end


--- Imports a platform friend list as online contacts. It takes the list itself, which the
--- caller has already fetched with `OnlineGetPlatformFriendList`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13661
---@param friends table The platform friend list.
function OnlineImportPlatformFriends(friends) end

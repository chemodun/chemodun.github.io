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


--- Credits or debits a **container's** account by `amount`, and returns the amount moved. A
--- negative amount takes it back. No vanilla code calls it - the menus move money with
--- `TransferPlayerMoneyTo` and `TransferMoneyToPlayer`, which name a counterparty.
---
--- **It creates money rather than transferring it.** Across a +1000 / -1000 pair on the player
--- HQ the station account went 330795062 -> 330796062 -> 330795062 while the player purse stayed
--- at 23844772840 at all three readings. Nothing is debited on the other side, which makes this
--- a cheat-grade call, not a trade primitive.
---
--- **The player is not a container.** `C.GetPlayerID()` resolves to class `player`,
--- `IsComponentClass(player, "container")` is `false`, and both `AddMoney(player, ...)` and
--- `GetAccountData(player, "money")` answer `Component '...' is not of class container`. The
--- player's own money is a separate mechanism, reached through `GetPlayerMoney` and
--- `TransferMoneyToPlayer`. An entity is refused the same way, so a pilot or a station manager
--- is not the argument either.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - nine rungs over a station, a ship, a derived entity and the player, each a
-- +1000 / -1000 pair with the account read back either side; arity stated by the engine in words.
-- 9.00 repeated the station and the ship: the container's account moves by the amount, the player
-- purse does not move at any of the three readings, and the player is refused as not a container
---@param containerID any The container whose account to change, as a 64-bit component ID.
---@param amount number The amount to add. Negative takes it away.
---@return number transferred The amount actually moved. Nothing is returned when the call is refused.
function AddMoney(containerID, amount) end


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


--- Adds units to a defensible - `amount` of `unitMacro`, the drone and police ships its unit
--- storage holds - or removes that many when `amount` is negative. Arity 4, returns nothing. MD's
--- `<add_units>` and `<remove_units>` (`common.xsd:20866`) are the same operation from the script
--- side, and their attributes name these arguments one for one.
---
--- Argument 1 must be a **defensible** - the engine says so itself, answering
--- `Invalid argument #1 <defensible> (got cdata, expected component ID)` to anything else, the
--- player person included.
---
--- **Argument 2 is a macro, never a category.** The MD action takes either a `macro` or a
--- `category` plus `mk`; the Lua form has only the macro half, and `"transport"` is refused with
--- the same `Cannot find XML file component macro '...' in index 'index\macros'` a nonsense
--- string gets. A bad macro therefore names itself rather than failing silently.
---
--- **It clamps at `units.maxcount` and fills partially rather than refusing.** Asked for 500 with
--- 87 free, it added 87 and stopped; vanilla's hand-computed `maxcount - count` at
--- `story_paranid.xml:2885` is belt and braces rather than necessity.
---
--- **`unavailable` puts the added units in the unavailable pool**, which `C.GetNumUnavailableUnits`
--- reads back and MD states as `units.count - availableunits.count`. A negative `amount` removes
--- from whichever pool the flag names, so the call undoes itself in each pool separately.
---
--- **A non-unit macro is accepted as well and lands in its own storage** - a missile, torpedo or
--- mine goes to missile or deployable storage, never to unit storage - **but how much is added
--- still depends on the unit storage's free space.** At `units.free` 0 the call adds nothing
--- whatever the macro is, so the free-space check gates the whole call before anything is routed.
--- `C.IsUnitMacroCompatible` does not predict either behaviour: it answered false for all three
--- consumable macros the engine then accepted.
---
--- The units it adds are ships - `libraries/loadoutrules.xml` declares every `<unit>` macro as a
--- `ship_*` macro. **Marines are not units and cannot be added from Lua at all**; mines and
--- satellites are `<deployable>`, a separate enum reached through ammo storage.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - three ships, both storages read back per macro either side of every call;
-- the amount, the unavailable flag, the consumable path and the fill-to-maxcount clamp are 9.00
-- measurements, where 8.00 only carried them
---@param defensibleID any The defensible whose unit storage is written. Not any component.
---@param unitMacro string A unit macro name. A category name is refused; another macro type is accepted and routed to its own storage.
---@param amount number How many to add; a negative amount removes. Clamped to the unit storage's free space.
---@param unavailable boolean Whether the units are added to, or removed from, the unavailable pool.
function AddUnits(defensibleID, unitMacro, amount, unavailable) end


-- Adjusts a multi-line string, likely for formatting or word wrapping.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6285
---@param text string -- The string to adjust.
---@return string -- The adjusted string.
function AdjustMultilineString(text) end

--- Tells a controllable's subordinates that their operational range setting has changed. The
--- name is past tense and it is exact: this **notifies, it does not set**. It raises the object
--- signal `range_setting_updated` on every subordinate of argument 1 and carries no value with
--- it, so the range itself has to be in place before the call.
---
--- The setting lives on the commander's control entity as the blackboard variable
--- `$config_subordinate_range`, and **nothing in vanilla ever writes it** - twelve read sites in
--- 9.00, no writer, in neither MD nor Lua. It is a modder's hook, and this function is the
--- paired doorbell for it. A range is a **sector, cluster or zone**, or one of the keywords
--- `'cluster'`, `'sector'`, `'zone'` (`aiscripts/order.mining.routine.xml:534-560`) - never a
--- number.
---
--- **Measured, 8.00.** The subordinates are signalled and the object in argument 1 is not; a
--- controllable with no subordinates is a silent no-op rather than an error; the raise is
--- **synchronous**, so a listener has run before the call returns. `param2` is **always null**,
--- measured with `$config_subordinate_range` deliberately seeded on the commander entity. So for
--- vanilla's two listeners - `order.mining.routine.xml:99` and `order.trade.routine.xml:127`,
--- both `if @event.param2 then event.param2 else …commanderentity.$config_subordinate_range` -
--- a signal raised from Lua can only ever take the **else** branch. The `if` half is there for
--- MD raisers, which do supply a param2.
---
--- **Calling this on a live mining or trade subordinate sets its `$range` to null** whenever the
--- commander entity's variable is unset, which is its shipped state. That is recoverable rather
--- than destructive - the order's Ranges block logs `range is null. attempting to recover.` and
--- falls back to `jobmainsector`, then `sector` - but set the variable first.
---
--- Argument 2 must be class `entity` and is otherwise **inert**: a subordinate's control entity
--- and the player entity both produce the same signalled set and the same null payload.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - witnessed with an MD group listener, against a positive control; the
-- subordinates-but-not-the-commander asymmetry reproduced on both versions
---@param controllable any The controllable whose subordinates are signalled.
---@param entity any A control entity. Mandatory, and not read.
function AIRangeUpdated(controllable, entity) end


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


--- Raises the object signal `update config` on a defence NPC entity. **That is the whole
--- effect**, measured: the signal goes out on every call, carries no `param2` or `param3`, and
--- reaches the entity passed in and nothing else - not its `assignedcontrolled`, which was in
--- the same listening group and never fired.
---
--- **No vanilla script listens for `update config`**, so the only consumer is a mod's own
--- `event_object_signalled` cue. A station's defence manager, `fight.attack.object.station.xml`,
--- does listen on itself - for `'reset'`, which this call never raises.
---
--- **Argument 1 is checked for the class `entity` and nothing narrower.** `GetComponentData(obj,
--- "defencenpc")` is the documented source and its `computer` entity is accepted; so is an
--- unrelated `npc`, silently. A controllable is refused with `Component '<name>' is not of class
--- entity` and a `C.GetPlayerID` cdata with `Invalid argument #1 <defencenpc> (got cdata,
--- expected component ID)` - the engine's own parameter name. Both refusals print while `pcall`
--- returns OK.
---
--- **Takes one argument, not two.** The raise is unaffected by the NPC blackboard variable
--- `$config_attackenemies` that `helper.lua` reads to pick the displayed command text: calls with
--- it absent and set to `true` were identical.
--- Note `GetControlEntity` is the same entity as `defencenpc` on a station but the pilot on a
--- ship, so it is not a substitute for the lookup.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a player station and a capital ship, an MD group listener with no param
-- filter as the witness; 'update config' raised on the defence entity on both versions
---@param defencenpcID any The defence NPC entity to signal. Any entity is accepted; a controllable is not.
function AttackEnemySettingChanged(defencenpcID) end


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
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param eventName string -- The name of the event to trigger.
---@param argument1 any -- An argument to pass to the event scripts.
function CallEventScripts(eventName, argument1) end


--- Runs the handlers registered for a hotkey action. No vanilla code calls it: the engine is
--- what raises hotkeys, and menu code registers into it with `SetScript("onHotkey", ...)`.
-- Global access to widget_fullscreen.callHotkeyScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param action string -- The hotkey action that was triggered.
function CallHotkeyScripts(action) end


--- Runs the handlers registered for tab scrolling, in a direction. `widget_fullscreen.lua`
--- calls it from its own left and right handlers, and menu code registers into it with
--- `Helper.setTabScrollCallback`.
-- Global access to widget_fullscreen.callTabScrollScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param direction string -- The direction of the scroll ("left" or "right").
function CallTabScrollScripts(direction) end


-- Global access to widget_fullscreen.callUpdateScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Calls all registered update scripts, typically on each frame.
-- Environment: addons only
-- Versions: 8.00, 9.00
function CallUpdateScripts() end


-- Global access to widget_fullscreen.callWidgetEventScripts
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Dispatches an event to a specific widget's registered event handlers.
-- Environment: addons only
-- Versions: 8.00, 9.00
---@param widgetID table -- The widget to which the event is sent.
---@param eventName string -- The name of the event (e.g., "onClick", "onTextChanged").
---@param ... any -- Arguments to pass to the widget's event handler.
function CallWidgetEventScripts(widgetID, eventName, ...) end


--- Answers whether **this kind of thing can command that kind of thing**. The argument order is
--- proved by reversal rather than inferred: the same station and ship gave `false` as
--- (station, ship) and `true` as (ship, station), and only the declared reading fits both, since
--- a ship can be subordinate to a station and a station can be subordinate to nothing. Vanilla
--- agrees twice - `libraries/assignments.xml` gives `defence`, `mining`, `trade` and
--- `supplyfleet` a `<station>` element beside `<ship>`, and the MD analogue
--- `canuseassignment.{$assignment}.{$controllable}` is a property *on the subordinate* taking
--- the commander as its parameter.
---
--- **It is a class-level compatibility test, not an assignability test, and a mod must not gate
--- a UI action on it alone.** It ignores ownership - a scavenger-owned Manticore returned `true`
--- against a player Erlking - and it ignores identity, returning `true` for a ship paired with
--- itself. It looks at neither faction relations, distance nor current assignment. The MD
--- `canuseassignment` takes an actual `$assignment` and is the stricter question.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - four pairs including the same two objects in both orders, arity 2; five
-- more pairs in both orders on 9.00 against one reference ship, where every station answered
-- `false` as the subordinate and `true` as the commander, and ship against ship was `true` both
-- ways
---@param subordinateID any The controllable that would be subordinate.
---@param commanderID any The controllable that would command it.
---@return boolean canBeSubordinate True when the two classes are compatible - not that the assignment is allowed.
function CanBeSubordinateOf(subordinateID, commanderID) end


--- Cancels the running player conversation. No vanilla code calls it; the menus end a
--- conversation by closing themselves, and `UnsuspendConversation` is what they do call around
--- one.
---
--- **It reports whether there was anything to cancel.** Every call measured was made with no
--- conversation running and returned `false`, with the engine writing
--- `[ConversationManager::CancelConversation] There is no conversation` beside it. The positive
--- case has not been measured, so that `true` means "cancelled" is the reading the engine's own
--- line implies rather than one taken.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions with no conversation running: `false` and
-- the same engine line either side. No argument is required; the positive case is unmeasured.
---@return boolean cancelled `false` when there was no conversation to cancel.
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


--- Clears a ship's queued trades: every entry of the queue `GetTradeShipData` reports, which is
--- the only view of it Lua has. Returns nothing. No vanilla code calls it; the map menu removes
--- trades one at a time instead.
---
--- **The queue is empty by the next line.** Measured on a player L trader carrying two queued
--- trades, the count read 0 immediately after the call - so a caller can clear and re-read in the
--- same frame. The community reference warns the clear is not instantaneous, especially with a
--- trade already in progress; that is untested rather than contradicted here, since a trade the
--- ship has already begun is not the same thing as the queue behind it.
---
--- Only a ship has been tested. The community reference types the argument `containerID`, which
--- would take a station as well, and nothing here confirms or denies that.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - read back through GetTradeShipData, before and twice after; 9.00 repeated
-- it on a second L trader with two trades queued and read 0 on both reads after the call
---@param shipID any The ship whose trade queue should be cleared.
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


--- Reports whether the first route is **strictly shorter** than the second. Takes four plain
--- numbers, not two routes: the gate transitions and jumps of one route, then of the other,
--- which is exactly the pair `FindJumpRoute` returns for each. No game object is involved.
---
--- The comparison is strict. **Equal routes return `false`**, so this is a `<` and not a
--- `<=`, and it cannot be used to test two routes for being the same - which is what this row
--- claimed until it was measured, because every call ever made compared a route with its own
--- reverse and `false` was the only answer it could give.
---
--- **A jump counts for less than a gate transition.** One jump against one gate returns
--- `true`, one gate against one jump returns `false`, and the same asymmetry holds at two of
--- each - so the two halves are not simply added together. An empty route beats any non-empty
--- one, and two empty routes return `false` like any other tie.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a ten-case truth table over literal numbers, both orders of every pair,
-- every case answering the same either side
---@param numgates number Gate transitions of the first route.
---@param numjumps number Jumps of the first route.
---@param othernumgates number Gate transitions of the second route.
---@param othernumjumps number Jumps of the second route.
---@return boolean shorter True when the first route is strictly shorter than the second.
function CompareJumpRoute(numgates, numjumps, othernumgates, othernumjumps) end


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


--- Formats a time in seconds into a string, using the format specifiers below. The default
--- format is `%T`, which takes the time format from the TextDB and shows days only past one
--- day. Vanilla calls it 63 times and never passes more than two arguments, so `separators`
--- and `precision` are marked optional: their names and meanings are documented, but whether
--- the engine accepts them is unverified here.
---
--- Specifiers: `%s` all seconds, `%S` seconds 00-59, `%m` all minutes, `%M` minutes 00-59,
--- `%h` all hours, `%H` hours 00-23, `%d` all days, `%T` the TextDB time format, `%%` a literal
--- percent sign. `%s`, `%S` and `%T` also take a precision override written as `%.#`, with `#`
--- from 1 to 9 - `%.3T`, for example.
---
--- `separators` turns on thousand separators and applies only to `%s`, `%m`, `%h` and `%d`.
--- `precision` is the number of fractional digits for `%s`, `%S` and `%T`, defaulting to 0; -1
--- selects automatic display and cannot be combined with separators. A `%.#` in the format
--- string overrides it.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 63 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1524, ui/addons/ego_detailmonitor/menu_docked.lua:1343
---@param time number The time in seconds to format.
---@param format? string A format string, e.g. `"%h:%M:%S"` or `"%T"`. Defaults to `"%T"`.
---@param separators? boolean Use thousand separators.
---@param precision? integer Fractional digits, or -1 for automatic.
---@return string -- The formatted time string.
function ConvertTimeString(time, format, separators, precision) end


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
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7660
---@param descriptor table -- A descriptor table containing properties for the edge (e.g., source and target nodes).
---@return table widget -- The created flowchart edge widget.
function CreateFlowchartEdge(descriptor) end


--- Builds one node of a flowchart and returns its descriptor. As with the other widget
--- constructors, the single descriptor table carries everything, and `helper.lua` assembles it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:7379
---@param descriptor table -- A descriptor table containing properties for the node (e.g., text, position, size, content).
---@return table widget -- The created flowchart node widget.
function CreateFlowchartNode(descriptor) end


-- Creates a font string descriptor for use in other UI elements.
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
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:6598
---@param properties table -- A table of properties for the graph (e.g., { height, scaling, data }).
---@return table widget -- The created graph widget.
function CreateGraph(properties) end


--- Builds an icon widget and returns its descriptor. `helper.lua`, the only vanilla caller,
--- passes a single descriptor table that already carries the icon and its properties together.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:5741
---@param icon string -- The ID or name of the icon texture to display.
---@param properties? table -- A table of properties for the icon (e.g., { width, height, color, mouseOverText }).
---@return table widget -- The created icon widget.
function CreateIcon(icon, properties) end


--- Builds a **legacy** interaction descriptor and returns it as **userdata**. Deprecated since
--- 3.00 Beta 6 in favour of `CreateInteractionDescriptor2`, and the deprecation is not cosmetic:
--- the descriptor *type* changed, and **nothing in 8.00 consumes the old one**. Measured -
--- `RaisePlayerInteractionEvent`, `TargetMonitorInteractionShown2` and
--- `TargetMonitorInteractionHidden2` each refuse the userdata (`invalid arguments`, `invalid
--- parameters`), and the only call that accepts it is `ReleaseInteractionDescriptor`. The
--- function still allocates; what it allocates cannot be used for anything. Vanilla says the
--- same in prose at `ui/addons/ego_targetmonitor/targetmonitor.lua:1037` - the
--- `interactionDescriptor` field was **dropped** rather than preserved.
---
--- Both arguments are mandatory: the name alone answers `Invalid number of arguments (1,
--- expected 2)`. Argument 2 is **not validated** - a component id, a `ConvertStringToLuaID`
--- userdata and a plain table were all accepted, each returning its own descriptor.
-- Source: Game Engine
-- Environment: addons only
-- Versions: none - present in both, but deprecated in 3.00 Beta 6
-- Usage: confirmed - in-game probe, no vanilla call site
-- Deprecated: 3.00 Beta 6 - superseded by `CreateInteractionDescriptor2`; the descriptor type
-- changed with it, so nothing in the current pipeline accepts what this one returns
-- Probed: 8.00, 9.00 - created, then refused by every consumer in the current pipeline, on both
-- versions
---@param interaction string The interaction name, e.g. "object interaction".
---@param payload any That interaction's payload. Mandatory, unvalidated.
---@return userdata descriptor A legacy descriptor no current call accepts.
function CreateInteractionDescriptor(interaction, payload) end


--- Creates a player interaction and returns its **id as a small integer**, not a descriptor
--- object - measured, and the counterpart cdef says the same: `void
--- ReleaseInteractionDescriptor(int32_t id)`, `ui/core/lua/monitors.lua:103`. Ids are handed out
--- in ascending order through a session and the engine calls them **notifications** internally:
--- a raise against a freed one answers `Cannot find notification with ID 'N'`.
---
--- Argument 1 is a name, and vanilla's own four - `"object interaction"`, `"platform
--- interaction"`, `"missionoffer interaction"` and `"encyclopedia interaction"` - are just the
--- names its four MD handlers listen for (`md/conversations.xml:1789-1830`). **The vocabulary is
--- open**: a name nothing listens for is created and raised without complaint, which is how a mod
--- adds its own interaction without touching a vanilla handler.
---
--- Argument 2 is that handler's **payload**, not necessarily a component: three of vanilla's four
--- pass a component or a mission id and the encyclopedia one passes a `{ library, component }`
--- table. It reaches MD as `event.param2`, **unresolved** - a component id arrives as a plain
--- number that MD has to turn back into an object with `component.{...}`.
---
--- The id is consumed by `RaisePlayerInteractionEvent`, `TargetMonitorInteractionShown2` and
--- `TargetMonitorInteractionHidden2`, and freed with `C.ReleaseInteractionDescriptor`.
-- Source: Game Engine
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:1046
---@param interaction string The interaction name the MD handler listens for.
---@param component any The payload handed to that handler as event.param2.
---@return integer interactionID
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
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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


--- Reports whether a text entry exists, and hands back the text when it does - one call answers
--- both questions. It takes a page and a line exactly like `ReadText`: the engine rejects the
--- single-argument form in words, `Invalid number of arguments (1, expected 2)`, which is the
--- most explicit the arity oracle has ever been. A missing page or line returns `nil`, silently,
--- and `if ExistsText(page, line) then` is therefore correct Lua - an entry holding an empty
--- string is still truthy.
---
--- **This is the only way to detect missing text.** `ReadText` never fails and never complains:
--- asked for text that does not exist it returns the placeholder string `"=ReadText1001-999999="`,
--- so the alternative to this call is pattern-matching that shape.
---
--- Ids are coerced from strings and bounded at 32 bits - `(-1, -1)` draws
--- `ReadTextHelper(): pageid (-1, -1) exceeds 32-bit` and returns **no value at all**, where an
--- in-range miss returns one `nil`. Both read as `nil` at the call site; `select("#", ...)`
--- separates "called it wrong" from "not there". The complaint is a log line, not a Lua error,
--- so `pcall` reports success either way.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - seven calls, arity stated by the engine in words; every shared rung
-- answered the same either side
---@param page integer|string The text page id. Strings are coerced - `("1001", "2954")` works.
---@param line integer|string The text line id within that page.
---@return string? text The text when it exists, `nil` when it does not.
function ExistsText(page, line) end


--- Returns how far apart two sectors are, as **two** numbers: gate transitions first, then
--- jumps. Takes the two sectors as 64-bit component IDs and nothing else - the engine answers
--- any other count with `Invalid number of arguments (n, expected 2)`, so the `maxJumps` this
--- row used to declare does not exist.
---
--- The hop count was measured as a ladder over sector pairs: 0 for a sector against itself,
--- then 1, 2, 3, 4, 6 and 7, symmetric in both directions at every step. The second return has
--- been 0 in all 19 samples taken, so what separates a jump from a gate transition is not yet
--- measured. **0 gate transitions is also what a sector returns against itself**, so a caller
--- cannot read 0 as "no route" without testing for that case first.
---
--- A rejected call - wrong arity, or a `UniverseID` cdata where a component ID belongs -
--- returns nothing at all rather than 0, and the engine writes the reason to the log.
---
--- That mod also shows how it fails: given a destroyed component it is reached with 0 and logs
--- `FindJumpRoute(): Component 0 does not exist any more`. Guard the sectors with
--- `IsValidComponent` before calling, which the Distance Tool does not.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site; also read against kuertee_ui_extensions
-- Seen at: kuertee_ui_extensions ui/addons/ego_detailmonitor/menu_map.xpl:34321
-- Probed: 8.00, 9.00 - a hop ladder of sector pairs in both directions plus a sector against
-- itself, the ladder repeated over five 9.00 clicks; arity and the parameter name `fromsector`
-- are the engine's own words on 8.00, where a cdata argument was passed
---@param startSector any The sector to start from, as a 64-bit component ID.
---@param endSector any The sector to reach, as a 64-bit component ID.
---@return number numgates The gate transitions between the two sectors.
---@return number numjumps The jumps needed. 0 in every sample measured so far.
function FindJumpRoute(startSector, endSector) end


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


---@meta
---@class ExtensionSetting
---@field enabled boolean Whether the extension is enabled.
---@field sync boolean Whether the extension is synced.

--- Returns the per-extension settings, keyed by the `index` of the matching `GetExtensionList`
--- entry rather than by extension id. Key 0 is not an extension: it holds the global sync
--- setting, which `gameoptions.lua:3365` reads on its own. Either field can be absent, and
--- vanilla treats a missing one as "use the extension's own default" - `enabledbydefault` or
--- `syncbydefault` - so every read is guarded twice, for the entry and for the field. The
--- options menu refetches the whole table after each change rather than editing it in place.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2979
---@return table<integer, ExtensionSetting>
function GetAllExtensionSettings() end


--- Returns every statistics ID the game keeps, as a flat array of id strings. The player
--- information menu walks it to build the statistics page; everything behind an ID, the raw
--- value included, comes from `GetStatData`.
---
--- The IDs are the `id` attributes of `libraries/stats.xml`, and the set is exactly that file:
--- it declares 126 statistics of which two are commented out, and the measured return is
--- **124 strings**, so the engine keeps nothing the file does not declare. That file is
--- byte-identical in 8.00 and 9.00 and no extension ships a copy. It is also the only
--- existence test there is: `GetStatData` answers an unknown ID with no return values at all
--- rather than with `exists = false`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:2525
-- Probed: 8.00, 9.00 - 124 ids on both versions, matching libraries/stats.xml exactly
---@return string[] statIDs Every statistics ID, as declared in libraries/stats.xml.
function GetAllStatIDs() end


---@meta
---@class WeaponEntry
---@field component any The weapon component id.
---@field macro string The weapon macro name.
---@field name string The weapon's displayed name.
---@field range number Bullet range.
---@field dps number Hull and shield damage per second.

---@meta
---@class MissileEntry
---@field macro string The missile macro name.
---@field name string The missile's displayed name.
---@field speed number Missile range.
---@field damage number Explosion damage.
---@field amount number Number carried.

---@meta
---@class WeaponData
---@field weapons WeaponEntry[] The primary weapons.
---@field missiles MissileEntry[] The missiles.

--- Returns the primary weapons and missiles of a destructible, in two separate arrays. The
--- target monitor reads it for the weapon systems block, next to the check that weapon
--- information is unlocked for the player at all; it counts both arrays and shows nothing
--- when they are empty, so both are always present and may be empty tables.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:1199
---@param component any The destructible to inspect.
---@return WeaponData
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


---@meta
---@class BonusContentEntry
---@field appid integer The Steam app id of the bonus content.
---@field name string The displayed name.
---@field owned boolean Whether the player owns it.
---@field installed boolean Whether it is currently installed.
---@field optional boolean Whether it can be installed and uninstalled at will.
---@field changed boolean Its installation state has already been changed and cannot be changed again this session.
---@field description? string Documented; vanilla does not read it.
---@field path? string Path to the content. Documented; vanilla does not read it.

--- Returns the bonus content entries as a list. The options menu only asks for it when
--- `IsSteamworksEnabled` is true, and walks the result to build the page: it shows the page at
--- all only if some entry is `owned`, then renders each entry's status from `installed`, and
--- offers Install or Uninstall only where `optional` is set and `changed` is not - the engine
--- allows one change per entry per session.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:10474
---@return BonusContentEntry[]
function GetBonusContentData() end


--- Returns whether boost is set to toggle rather than to hold, and pairs with
--- `SetBoostToggleOption`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2045
---@return boolean
function GetBoostToggleOption() end


--- Returns properties of a container's budget, one value per key asked and in that order. It is
--- a variadic property getter of the same family as `GetComponentData`, `GetMacroData`,
--- `GetStatData` and `GetWareData`, not a table getter: called bare it returns nothing at all,
--- because nothing was asked for.
---
--- Two keys exist, `"min"` and `"max"`. A wrong key is answered
--- `Invalid argument N, got unknown key 'X'` - the engine names the key it rejected, numbers the
--- argument 1-based including the container, puts `nil` in that slot and **still returns the good
--- keys beside it**. So a bad key costs nothing and identifies itself, which makes the whole
--- `Get*Data` family enumerable by trial.
---
--- The budget is a different source from the container's own account. A player factory reading
--- `money=2000000` with `minmoney` and `maxmoney` both `nil` through `GetAccountData` answered
--- `min=2000000, max=3000000` here while being its own account holder, so
--- `scriptproperties.xml`'s "has a budget or is its own account holder" is not an exclusive or,
--- and a budget needs no precondition beyond class `container`.
---
--- **`min` is not an independent floor: it is two thirds of `max`, rounded.** Every container
--- that answered a non-zero pair fits exactly - 2000000 / 3000000 on that factory, 263914287 /
--- 395871430 on a player HQ and 1362311345 / 2043467017 on a player shipyard. What `max` itself
--- tracks is unmeasured. A container can also have no budget at all: a player wharf and every
--- ship tried answered `0` to both keys rather than refusing the call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a player factory, bare, with each key alone and with all three together;
-- the same four shapes on 9.00 over four ships and four stations, `responsibility` refused by
-- name as an unknown key every time, and the `min` = 2/3 `max` relation measured on the three
-- containers that answered a non-zero pair
---@param container any The container to ask about.
---@param ... string Property names, `"min"` or `"max"`.
---@return ... number One value per requested property, in order.
function GetBudgetData(container, ...) end


--- Returns the build anchor of a component, or nothing when it has none. The target monitor
--- asks for it once it knows the component is a container, to show what is being built there.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_targetmonitor/targetmonitor.lua:869
---@param component any
---@return any
function GetBuildAnchor(component) end


--- Returns the build duration of the component's own macro, in seconds. It is a **constant from
--- the ware table, not remaining build time**: every measured figure is the exact
--- `<production time>` of that component's ware in `wares.xml`, and a *finished* Asgard still
--- answered its 516. A station *module* is a ware like any other - the three ship fabrication bays
--- answered 731, 1298 and 954, the production times of `module_gen_build_l_01`,
--- `module_gen_build_dockarea_m_01` and `module_gen_build_xl_01`. A component whose ware carries
--- no production entry, a station or a sector, answers `0`, and so does a station with a
--- construction plan pending.
---
--- Arity is 3 and the engine insists on it - one argument is answered
--- `Invalid number of arguments (1, expected 3)` - but arguments 2 and 3 are inert. A wharf,
--- given a macro from its own `GetBuilderMacros` and that macro's real
--- `GetBuildProductionMethod`, still answered `0`. The `(containerid, order)` this row used to
--- declare was borrowed from the FFI function of the same name, which is a different function.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - six ships of four races on 8.00; on 9.00 five more ships, three station
-- build modules and a production module, every figure matching its ware's `default` production
-- time in that version's own wares.xml to the second, the finished Asgard answering its 516 again,
-- and 0 for a sector, a station and a wharf alike
---@param component any The component to ask about.
---@param unused1 any Inert, but the call needs three arguments.
---@param unused2 any Inert, but the call needs three arguments.
---@return number seconds The macro's `<production time>`, or 0 if its ware has none.
function GetBuildDuration(component, unused1, unused2) end


---@meta
---@class BuilderMacro
---@field macro string The macro name.
---@field name string The macro's displayed name.

--- Returns the macros a container or build module can build, as a list of macro and name pairs.
--- It is **per build module**, and a station is the union of its bays: one shipyard's three
--- fabrication bays returned 107 (S/M), 29 (L) and 5 (XL) entries, and the station itself
--- returned the aggregate, its first entry matching the S/M bay's. A build module is class
--- `module`, not `container`, so a guard written for containers silently skips the target this
--- call is really about.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a shipyard and each of its three bays, arity 1; on 9.00 a shipyard and a
-- wharf, 107 entries each, and empty on every other target tried
---@param containerID any The container or build module to ask about.
---@return BuilderMacro[]
function GetBuilderMacros(containerID) end


--- Returns the production method a builder would use for a macro, as a string shaped
--- `<macro without its _macro suffix>.<method>` - `"ship_arg_m_bomber_01_a.default"`. Argument 1
--- is the builder, either the station or one of its build modules; argument 2 is a macro from
--- that builder's `GetBuilderMacros`.
---
--- The method belongs to the **macro's own build recipe, not to the builder's race**: a Terran
--- ATF Asgard built at an Argon shipyard still returned `.default`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a shipyard and its three bays, four macros, arity 2; the three bays again
-- on 9.00, each answering with the macro it is building
---@param containerID any The container or build module that would build it.
---@param macro string A macro the builder can build, from `GetBuilderMacros`.
---@return string method The production method, `<macro>.<method>`.
function GetBuildProductionMethod(containerID, macro) end


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


--- Returns the density of characters on station platforms - the value `SetCharacterDensityOption`
--- writes and MD reads as `player.chardensity`. No vanilla code calls either half.
---
--- Reads the persisted setting, not save state: it matches `<chardensity>` in `config.xml` and
--- survives a reload. Returns the stored 32-bit float widened to a Lua number, so a value that
--- is not exactly representable comes back approximate - `0.8` reads as `0.80000001192093`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - the read-back witness for SetCharacterDensityOption across four values, on
-- both versions
---@return number density Characters on platforms. 0 to 1 by convention; the setter does not clamp.
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


---@meta
---@class CollectableWare
---@field ware string The ware id.
---@field amount number The amount held.

---@meta
---@class CollectableData
---@field type string `"ammo"`, `"wares"` or `"shieldrestore"` - which other fields are present.
---@field macro? string Ammo macro name. Ammo only.
---@field name? string Ammo name. Ammo only.
---@field icon? string Ammo icon. Ammo only.
---@field amount? number Ammo amount. Ammo only.
---@field wares? CollectableWare[] The wares held. Wares only.
---@field money? number Credits held. Wares only.
---@field isdroppedcontainer? boolean Whether this is a dropped container rather than loose materials. Wares only.
---@field restoretype? string `"duration"`, `"hp"` or `"percent"`. Shield restore only.
---@field value? number The restore value, meaning set by `restoretype`. Shield restore only.

--- Returns what a collectable holds. `type` selects which of three disjoint field sets is
--- filled in, and the target monitor branches on it exactly that way: `ammo` gives `name` and
--- `amount`, `wares` gives the `wares` array plus `money` and `isdroppedcontainer`, and
--- `shieldrestore` gives `restoretype` with the `value` it scales. `value` is a floating point
--- number, not an integer. `targetmonitor.lua:1221` reads `isdroppedcontainer` to choose
--- between the "cannot collect container" and "cannot collect materials" warnings.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:20221, ui/addons/ego_targetmonitor/targetmonitor.lua:689
---@param component any The collectable to inspect.
---@return CollectableData
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


--- Returns the **pilot character of the direct commander**, class `npc` - not the commanding
--- ship, which is what `GetCommander` returns, and not the top of the chain. One hop per call:
--- a Katana returns the pilot of its Tokyo, that Tokyo returns the pilot of its Syn, and the
--- Syn leads the fleet and returns nothing. To reach the fleet leader, resolve the npc back to
--- its ship and call again until the result is empty.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - one three-ship fleet, every returned handle's class resolved; four 9.00
-- ships, two answering with an npc handle and two with nil
---@param controllableid any The controllable whose commander to ask about.
---@return any commanderNPC The direct commander's pilot, class `npc`; nothing at the top of the chain.
function GetCommanderEntity(controllableid) end


--- Reads named properties off a component, and is the workhorse of the whole UI. Every argument
--- after the component is a property name, and it returns one value per name, in the order
--- asked: `GetComponentData(id, "isshipyard", "iswharf", "istradestation")` returns three
--- booleans. Vanilla asks for anything from one property to fifteen at a time, and one call for
--- several is cheaper than several calls for one.
---
--- The 193 keys below are the ones 9.00 vanilla actually passes, in order of how often it asks
--- for them. It is not necessarily the whole set the engine accepts, but every one of them is
--- confirmed in use, which no published list of keys is:
---
--- `isplayerowned`, `name`, `macro`, `assignedpilot`, `classid`, `isdeployable`, `owner`,
--- `money`, `primarypurpose`, `idcode`, `isdocked`, `hullpercent`, `sector`, `shiptype`, `icon`,
--- `cargo`, `productionmoney`, `shiptrader`, `isonlineobject`, `realclassid`, `sectorid`,
--- `ishacked`, `assignedaipilot`, `ismissiontarget`, `pilot`, `subordinategroup`, `buildstorage`,
--- `isdock`, `isenemy`, `isfunctional`, `ownername`, `size`, `postname`, `skills`, `ismodule`,
--- `tradenpc`, `aicommand`, `aicommandparam`, `isactive`, `aicommandaction`,
--- `aicommandactionparam`, `aicommandstack`, `ishostile`, `isshipyard`, `poststring`,
--- `basestation`, `buildingprocessor`, `description`, `destinationsector`, `entrygate`,
--- `fleetname`, `isdocking`, `isfemale`, `ismissingresources`, `iswharf`, `missilecapacity`,
--- `policefaction`, `products`, `shieldpercent`, `uirelation`, `wantedmoney`, `allresources`,
--- `assignment`, `boardingresistance`, `countermeasurecapacity`, `issuperhighway`,
--- `issupplyship`, `istugweapon`, `canequipships`, `combinedskill`, `destination`,
--- `hasterraforming`, `hull`, `hullmax`, `isally`, `isfleetlead`, `ispausedmanually`,
--- `isreallyenemy`, `isshowroommodule`, `isunit`, `maxradarrange`, `ownericon`, `systemid`,
--- `tradesubscription`, `wares`, `zoneid`, `aipilot`, `canbuildships`, `caninitiatecomm`,
--- `clusterid`, `hasanymod`, `hasshipdockingbays`, `hasturret`, `isequipmentdock`, `islocked`,
--- `paintmodlocked`, `prestigename`, `recyclingwares`, `shiptypename`, `sourcesector`,
--- `sunlight`, `tradewares`, `typename`, `typestring`, `cansupplyships`, `cluster`,
--- `containsthewave`, `defencenpc`, `deployablecapacity`, `docksizes`, `hiringdiscounts`,
--- `individualtrainee`, `isattachedaslimpet`, `iscovered`, `isdatavault`, `isdefencestation`,
--- `isdockingenabled`, `isinternallystored`, `isknown`, `islandmark`, `isorphaned`,
--- `isradarvisible`, `isreallyplayerowned`, `issellable`, `istradestation`, `iswreck`,
--- `modulesets`, `numdockingbays`, `occupationname`, `populationworkforcefactor`,
--- `pureresources`, `shieldmax`, `shipstoragecapacity`, `agenticon`, `aicommandactionraw`,
--- `assigneddock`, `assignmentname`, `availableproducts`, `basename`, `blacklistgroup`,
--- `boardingstrength`, `buildcomponents`, `canbeclaimed`, `canhavetradeoffers`, `container`,
--- `currentyield`, `datavaultunlockstate`, `discounts`, `engineer`, `formation`,
--- `hasavailablemarines`, `haswaveprotectionmodule`, `height`, `image`, `intermediatewares`,
--- `isbusy`, `iscapturable`, `isdefendingfromboardingoperation`, `isdockedinternally`,
--- `isfriend`, `isinliveview`, `isinnormalspace`, `ismasstraffic`, `ismissionactor`,
--- `isnpcassignmentrestricted`, `isstorageallowed`, `length`, `makerraceid`, `moddingdiscounts`,
--- `npcfacecutscenekey`, `numlocks`, `numlockslots`, `numtrips`, `ownershortname`, `parent`,
--- `rawdescription`, `rawname`, `recyclingcomponents`, `repairdiscounts`, `resourcebuffer`,
--- `resourcedetectionrange`, `revealpercent`, `rolename`, `roomtype`, `scrapbuffer`, `shield`,
--- `tradercommissions`, `traderdiscounts`, `typeicon`, `venturetransactionid`, `ventureuserid`,
--- `width`, `workforcebonus`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 832 vanilla call sites, 2-16 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:488, ui/addons/ego_detailmonitor/menu_crafting.lua:228
---@param component any
---@param ... string One or more property names.
---@return ... any One value per name, in the order asked.
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


--- Returns the ships in a space, whoever owns them. No vanilla code calls it - the menus want
--- the owner filter and use `GetContainedShipsByOwner` or `GetContainedObjectsByOwner`.
--- Argument 1 is a **space**, a sector or a zone, the family `GetGates`, `HasShipyard` and
--- `HasWharf` also belong to; omitting it resolves universe-wide and hands back every ship in
--- the game, 9,595 on one save and 13,814 on an older one.
---
--- `showOnMap` is a filter that is **off** by default, matching `GetGates`: `true` narrows the
--- result to what the player's map actually shows, and `false` is identical to omitting it. In
--- an unexplored sector the bare call returned 149 ships and `true` returned 0. **The
--- unfiltered call leaks undiscovered objects** - 149 ships with their owners named, in a
--- sector the player has never visited - so any mod that puts this in front of the player must
--- pass `true`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - both arguments measured in-game, the class named by the engine on 8.00;
-- both forms again over eight 9.00 clicks
---@param space? any The sector or zone whose ships to list. Omitted, it covers the whole universe.
---@param showOnMap? boolean True to return only ships shown on the player's map. Defaults to off.
---@return table ships Array of ship components.
function GetContainedShips(space, showOnMap) end


--- Returns the ships of one owner, as a list. `space` really is optional, and dropping it makes
--- the call **galaxy-wide** rather than dropping the owner filter: `("player")` returned 1,411
--- ships where `("player", Ore Belt)` returned 12, and a bare `GetContainedShips()` returned
--- 9,595 over the same save, so the faction form is a filtered subset of the same universe.
--- Argument 2 is a **space**, a sector or a zone - a ship in that slot draws
--- "is not of class space" from the engine and the call still reports success with an empty
--- table, so the result is only readable against the log line above it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - both forms measured in-game, the class named by the engine on 8.00; both
-- again over eight 9.00 clicks, with and without the space argument
---@param owner string The faction id, e.g. `"player"`.
---@param space? any The sector or zone to limit the search to. Omitted, it covers the whole galaxy.
---@return table ships Array of ship components.
function GetContainedShipsByOwner(owner, space) end


--- Returns the spaces belonging to one owner, as an array of component handles. No vanilla code
--- calls it.
---
--- The count is per savegame, not a constant: `GetContainedSpacesByOwner("player")` answered 0,
--- 323 and 334 entries on three different saves. **The engine reports a minimum, not a fixed
--- count** - a bare call answers `Invalid number of arguments (0, expected >= 1)` - so there is
--- at least one further parameter, presumably the `space` its sibling `GetContainedShipsByOwner`
--- takes to limit the search. Only the one-argument form has been called.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - the one-argument form on three savegames and again on 9.00, arity minimum
-- stated by the engine in words on 8.00; any further parameter is unmeasured
---@param owner string The faction id, e.g. `"player"`.
---@return table spaces Array of space components.
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


--- Returns which input device the player is currently using, and the joystick input angle.
--- The mode is one of `mouseSteering`, `mouseCursor`, `gamepad`, `touch` or `joystick`. Menus
--- branch on it to show the right button prompts and to decide whether an input bar is needed
--- at all; every vanilla call site uses the mode alone and discards the angle.
---
--- The angle is only meaningful in `touch`, `joystick` and `gamepad` mode. It is -1 while the
--- stick sits in its safe area, and otherwise an angle in radians from 0 to 2π, with 0 pointing
--- upwards and rotation running clockwise.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:20560, ui/addons/ego_detailmonitor/menu_scenario_selection.lua:326
---@return string mode, number? angle
function GetControllerInfo() end


--- Reads a row of `libraries/posts.xml` by its `id`, in the same shape as
--- `GetComponentData`: the key, then one property name per return value. The twin of
--- `GetEntityTypeData`, down to the closed property set and the two traps below.
---
--- `controlPost` is the **db key string** - `playerpilot`, `aipilot`, `defence`, `manager`,
--- `engineer`, `shadyguy`, `shiptrader`, `tradeagent`, `tradecomputer`, `trainee_individual` -
--- never a component and never a person. No game object is involved.
---
--- **Only `name` and `icon` exist.** Every other column of the xml row - `femalename`,
--- `description`, `type`, `tag`, `control`, `task`, even `id` - is refused with
--- `Invalid argument 2, got unknown key '<name>'` and a `nil`. `control` and `task` in
--- particular are not readable from Lua; MD reads them off the person instead.
---
--- `icon` returns the **active** variant of the icon group the row names, from
--- `libraries/icons.xml` - never the group name itself, and never a predictable suffix:
--- `defence` names group `defenceofficer` and reads back as `defenseofficer_active`, the
--- spelling changing with it. Always use the returned string as-is.
---
--- Measured on 8.00: `playerpilot` and `aipilot` both -> `Captain`, `pilot_active`;
--- `defence` -> `Defence Coordinator`, `defenseofficer_active`; `manager` -> `Manager`,
--- `manager_active`; `engineer` -> `Engineer`, `engineer_active`; `shiptrader` ->
--- `Ship Trader`, `shipdealer_active`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - six post ids answered for "name" and "icon"; every other column of the row
-- was refused by name, and a person returns nothing. The six ids answer identically on both
-- versions, value for value, over seven shared rungs
---@param controlPost string An id from libraries/posts.xml.
---@param ... string One or more of "name", "icon". At least one, or nothing is returned.
---@return ... any One value per name, in the order asked.
function GetControlPostData(controlPost, ...) end


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


--- Returns one option of the running dialog, by index. The core dialog menu walks the indexes
--- and treats an empty text as an inactive button.
---
--- Five values come back, in this order: the text, whether the option is selectable, whether it
--- is immediate, its shortcut key and its mouse-over text. `dialogmenu.lua:850` takes all five
--- and uses each of them - the mouse-over text reaches `GetTextNumLines` at line 953, so the
--- fifth value really is the text and not something internal.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/dialogmenu.lua:850
---@param index integer
---@return string text, boolean selectable, boolean immediate, string shortcutKey, string mouseOverText
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


--- Returns the efficiency upgrades of a destructible. Argument 1 is measured - arity 1, and the
--- engine accepts a station, a ship and a station module alike without complaint - but **the
--- return shape is not**: every call so far has given an empty array, including one to a genuine
--- production module derived through `GetProductionModules` rather than clicked.
---
--- The engine knows the concept: `scriptproperties.xml` gives datatype `object` an
--- `efficiencyupgrades.<state>.list`, whose elements are typed `destructible` rather than the
--- strings the community library declares. But no vanilla MD script, AI script or UI file reads
--- that family, and the two siblings the library documents beside this one, `GetAllUpgrades` and
--- `GetNotUpgradesByClass`, are in neither 8.00 nor 9.00. So this is the last survivor of a
--- family X4 does not use, and an always-empty array is plausible - but an empty array is not a
--- measured return, so what a populated one holds is still unknown.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
-- Probed: 8.00, 9.00 - arity 1; empty on every target tried, a production module included, and
-- empty again on every 9.00 target, none of which was a production module
---@param destructible any The destructible to ask about.
---@return table upgrades Empty in every measured case; the element type is unmeasured.
function GetEfficiencyUpgrades(destructible) end


--- Returns the type name of a scene element.
--- No vanilla code calls it; signature unverified.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param element any The scene element.
---@return string type
function getElementType(element) end


--- Reads a row of `libraries/entitytypes.xml` by its `id`. Takes the same shape as
--- `GetComponentData`: the key, then one property name per return value, in the order asked.
--- A call with no property name returns nothing at all, which is what made this name look
--- unusable for so long.
---
--- `entityType` is the **db key string** - `officer`, `trader`, `factionrepresentative`,
--- `shadyguy`, `crowd`, `agent` - not a component and not a person. No game object is
--- involved, so it can be called from any menu at any time.
---
--- `name` comes back resolved through text page 20208 and is the **male form**; the row's
--- `femalename` is a separate field. For a person's own gendered title use
--- `GetComponentData(npc, "typename")` instead, which is what vanilla does.
---
--- **Only `name` and `icon` exist.** Every other column of the xml row - `femalename`,
--- `description`, `platformpriority`, even `id` - is refused with
--- `Invalid argument 2, got unknown key '<name>'` and a `nil`.
---
--- `icon` returns the **active** variant of the icon group the row names, from
--- `libraries/icons.xml` - never the group name itself, and never a predictable suffix; the
--- sibling `GetControlPostData` has a group whose active variant is spelled differently again.
--- Always use the returned string as-is.
--- Measured on 8.00: `officer` -> `Crewman`, `pilot_active`; `trader` -> `Trader`,
--- `trader_active`; `factionrepresentative` -> `Faction Representative`,
--- `factionrepresentative_active`; `shadyguy` -> `Black Marketeer`, `shadyguy_active`;
--- `crowd` -> `Individual`, `pilot_active`; `agent` -> `Agent`, `factionrepresentative_active`.
---
--- **The two failure modes do not look alike, and neither is catchable.** A bad *property*
--- complains by name and returns `nil`. A bad *key* - including the right key in the wrong
--- case, `"Officer"` - returns **nothing at all**, silently, exactly as a call with no property
--- name does. So a caller cannot tell an unknown key from its own mistake by the return value;
--- validate the key before calling. Keys are case sensitive.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - all six entity type ids answered for "name" and "icon"; every other column
-- of the row was refused by name; a person plus each of ten property names returned nothing, so
-- argument 1 is the key, never a component. The six ids answer identically on both versions,
-- value for value, over nine shared rungs
---@param entityType string An id from libraries/entitytypes.xml.
---@param ... string One or more property names. At least one, or nothing is returned.
---@return ... any One value per name, in the order asked.
function GetEntityTypeData(entityType, ...) end


--- Returns an error message by ID. No vanilla code calls it; the UI reports its own errors
--- through `DebugError` instead.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@param messageID any
---@return string
function GetError(messageID) end


--- Returns the severity of a logged error, as a number. The scale runs 0 to 5 and the debug
--- log turns it into the prefix each line gets: 0 is plain info and does not even trigger the
--- error callback, 1 is master info, 2 is an error, 3 an optional assertion, 4 an assertion and
--- 5 a panic. `debuglog.lua:928` skips everything at 0 and raises its popup only for 2, 3 and 4.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_debuglog/debuglog.lua:809
---@param messageID number The ID of the error message.
---@return number severity 0 info, 1 master info, 2 error, 3 optional assertion, 4 assertion, 5 panic.
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


---@meta
---@class ExtensionDependency
---@field id string The dependency's extension id.
---@field name string The dependency's name.
---@field version string The required version.

---@meta
---@class ExtensionEntry
---@field id string The extension id.
---@field index integer The extension index - the key into `GetAllExtensionSettings`.
---@field name string The extension name.
---@field version string The extension version.
---@field date string The extension date.
---@field enabled boolean Whether it is currently enabled.
---@field enabledbydefault boolean Its default enabled state, used where the settings table has no entry.
---@field sync boolean Whether it is synced.
---@field syncbydefault boolean Its default sync state.
---@field personal boolean Whether it is a personal extension.
---@field isworkshop boolean Whether it came from the Workshop.
---@field egosoftextension boolean Whether Egosoft published it.
---@field error? any The extension's error id, if any.
---@field errortext? string The extension's error text, if any.
---@field warning? any A Workshop update warning, if any.
---@field warningtext? string The Workshop update warning text, if any.
---@field desc? string The extension description. Documented; vanilla does not read it.
---@field author? string The extension author. Documented; vanilla does not read it.
---@field location? string The extension location. Documented; vanilla does not read it.
---@field dependencies? ExtensionDependency[] Documented; vanilla does not read it.

--- Returns the installed extensions as a list. The options menu walks it to build the
--- extensions page and to decide whether to show a warning icon at all: an entry that is both
--- `error` and `enabled` turns the icon red, any `warning` turns it yellow.
---
--- `index`, not `id`, is what keys the table `GetAllExtensionSettings` returns; `id` is what
--- `SetExtensionSettings` and `OpenWorkshop` take. Where the settings table has no entry for an
--- extension, vanilla falls back to `enabledbydefault` and `syncbydefault`, so those two are
--- the authority on an untouched extension rather than `enabled` and `sync`.
---
--- `enabledbydefault`, `syncbydefault` and `egosoftextension` are not in the community
--- reference - the last of the three is how the options menu recognises a third-party mod
--- before warning that the save will be marked as modified.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_mapeditor.lua:1012, ui/addons/ego_gameoptions/gameoptions.lua:5899
---@return ExtensionEntry[] extensions
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


--- Returns the gates of a space, as a flat array of gate components. Argument 1 is a space - a
--- sector or a zone - matching the family `GetContainedShips`, `HasShipyard` and `HasWharf` belong
--- to; a station in that slot gives "is not of class space".
---
--- `showOnMap` is a filter that is **off** by default. Passing `true` narrows the result to the
--- gates already revealed on the player's map; omitting it, or passing `false`, returns every gate
--- the sector has. `false` is not an inversion - it is identical to omitting the argument. Measured
--- on 8.00 in a sector holding one unrevealed gate: 5 bare, 4 with `true`, 5 with `false`, the
--- filtered list a subset of the full one. A genuinely unexplored sector gave 3 bare and 0 with
--- `true`, so the flag filters rather than failing in unknown space.
---
--- **The unfiltered call leaks undiscovered objects** - that unexplored sector handed over its
--- gates, named, to a player who has never been there. Any mod that shows this result to the
--- player must pass `true`; this is the one place where the default is the wrong choice for UI
--- work.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - both arguments and the return shape measured in-game, all three call
-- shapes repeated over eight 9.00 clicks
---@param space any The sector or zone whose gates to list.
---@param showOnMap? boolean True to return only gates revealed on the player's map. Defaults to off.
---@return table gates Array of gate components.
function GetGates(space, showOnMap) end


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


---@meta
---@class LicenceEntry
---@field id string The licence id.
---@field type string The licence type - 21 distinct values on the player, from `shiptrade` to `ceremonyfriend`, `tradesubscription`, `innercore_access` and `hyperion_access`.
---@field name string The licence's displayed name.
---@field icon string The licence icon.
---@field price number The licence price. Zero on all but a handful - 21 of the player's 231 - where it runs from 1 to 20,000,000.
---@field minrelation number The minimum relation required to hold it. Exactly four values measured: 20, 10, -10, -30.
---@field faction string The faction that **issued** the licence, never the holder passed in.
---@field precursor? string The licence required before this one. Present on 140 of the player's 231 entries, so it is common rather than rare.

--- Returns the licences a faction **holds**. The argument is the holder and each entry's
--- `faction` field is the **issuer**; the two are never the same, measured over 238 entries on
--- one run and corroborated on six factions - the player held 231 from 21 issuers, teladi 7
--- from ministry, hatikvah and scaleplate, antigone 10 mostly from argon. The player's 231 is a
--- real subset of vanilla's 360 defined issuer/type pairs, not the whole catalogue.
---
--- **The argument is not validated.** A nonexistent faction string returns an empty table with
--- no engine complaint, and so does a component handed in by mistake - the binding ignores a
--- wrong type rather than rejecting it. An empty result therefore cannot distinguish "holds
--- nothing" from "no such faction" from "wrong argument entirely".
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - six holders, whole-array field histograms, arity 1; on 9.00 the player's
-- 232 licences, each an eight-field record, with an empty array for a bogus faction string and
-- for a component alike
---@param faction string The faction id that holds the licences, e.g. `"player"`.
---@return LicenceEntry[] licences Empty when the faction holds none - and equally when the argument is wrong.
function GetHeldLicences(faction) end


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


---@meta
---@class HoloMapColor
---@field r integer Red, 0-255.
---@field g integer Green, 0-255.
---@field b integer Blue, 0-255.
---@field a integer Alpha, 0-100 - not 0-255.

--- Returns the whole holomap colour set in one call - twenty-two colours, from production and
--- build through the alert levels to gates and highways, as defined in `parameters.xml`.
--- `Helper.getHoloMapColors` names them into a table, and that wrapper is what menu code uses.
---
--- Each colour is a table of `r`, `g` and `b` in 0-255 with `a` in **0-100**, not 0-255;
--- `Helper.convertColorToText` scales the alpha by `* 255 / 100` before packing the four into
--- the escape sequence, which is the arithmetic that proves the range.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitorhelper/helper.lua:13070
---@return HoloMapColor productionColor
---@return HoloMapColor buildColor
---@return HoloMapColor storageColor
---@return HoloMapColor radarColor
---@return HoloMapColor droneDockColor
---@return HoloMapColor efficiencyColor
---@return HoloMapColor defenceColor
---@return HoloMapColor playerColor
---@return HoloMapColor friendColor
---@return HoloMapColor enemyColor
---@return HoloMapColor missionColor
---@return HoloMapColor currentPlayerShipColor
---@return HoloMapColor visitorColor
---@return HoloMapColor lowAlertColor
---@return HoloMapColor mediumAlertColor
---@return HoloMapColor highAlertColor
---@return HoloMapColor gateColor
---@return HoloMapColor highwayGateColor
---@return HoloMapColor missileColor
---@return HoloMapColor superhighwayColor
---@return HoloMapColor highwayColor
---@return HoloMapColor hostileColor
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


---@meta
---@class InputBinding
---@field [1] integer The input source.
---@field [2] integer The input code.
---@field [3] integer The input signum.

--- Returns the action bindings - the inputs that fire on a press - keyed by integer action id,
--- each holding a list of the inputs bound to it. Called with no argument for the player's
--- current map and with true for the default one, next to `GetInputStateMap` and
--- `GetInputRangeMap`; the options menu keeps both sets to show what has been rebound.
---
--- Each binding is a three-element array, not a record: source, code and signum in that order.
--- `gameoptions.lua` reads `input[1]` to decide whether a binding is keyboard or mouse, and
--- nudges `input[2]` by one when shifting a mouse axis. An unbound action maps to an empty
--- table rather than being absent, which is what clearing a binding writes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table<integer, InputBinding[]> actions
function GetInputActionMap(default) end


---@meta
---@class InputProfile
---@field id any The profile id.
---@field name string The profile's displayed name.
---@field filename string The profile's file name.
---@field personal boolean Whether the file sits in the personal folder - a user profile rather than a shipped one.
---@field mouseprofile boolean Whether it is a mouse profile; the load page groups these separately.
---@field version? any The profile version. Documented; vanilla does not read it.
---@field customname? string The profile's custom name. Documented; vanilla does not read it.

--- Returns the input profiles - the shipped ones and the player's own - as one list. The
--- controls page splits them by `personal`: a personal profile is a user profile and is indexed
--- by `filename`, while the rest are offered for loading and are split again by `mouseprofile`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:12558
---@return InputProfile[] inputProfiles
function GetInputProfiles() end


--- Returns the range bindings - the axis inputs - keyed by integer range id, each holding a
--- list of `InputBinding` entries in the same source, code, signum form the action map uses.
--- Called with no argument for the player's current map and with true for the default one,
--- which the options menu keeps side by side to show what has been changed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table<integer, InputBinding[]> ranges
function GetInputRangeMap(default) end


--- Returns the state bindings - the inputs that act while held - keyed by integer state id,
--- each holding a list of `InputBinding` entries in the same source, code, signum form the
--- action map uses. Called with no argument for the current map and with true for the default
--- one, alongside `GetInputActionMap` and `GetInputRangeMap`; `SaveInputSettings` takes all
--- three back together.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4844, ui/addons/ego_gameoptions/gameoptions.lua:4938
---@param default? boolean If true, gets the default map.
---@return table<integer, InputBinding[]> states
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


---@meta
---@class InventoryWare
---@field name string The ware's displayed name.
---@field amount number The amount held.
---@field price number The ware's price.

--- Returns the wares an entity holds, keyed by ware id. There is no array part, so vanilla
--- walks it with `pairs` and tests it for emptiness with `next(...)` - the interact menu decides
--- whether to offer a trade at all that way. The entity is usually an NPC rather than a ship:
--- the map passes a pilot, the player info menu the HQ defence NPC.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 10 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:4112, ui/addons/ego_detailmonitor/menu_map.lua:6516
---@param entityID any The entity whose inventory to read.
---@return table<string, InventoryWare> inventory
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


---@meta
---@class JoystickSlot
---@field name string The device name.
---@field guid string The device guid, empty for an unoccupied slot.
---@field xinput boolean Whether the device is an XInput controller rather than a plain joystick.

--- Returns the joystick slot assignments, keyed by slot number. The controls page reads it next
--- to `GetMappedJoysticks`, which lists the devices actually mapped, and writes back one slot at
--- a time with `SetJoysticksOption`.
---
--- Slots can be empty, so vanilla walks the table with `pairs` rather than `ipairs` and skips
--- any entry whose `guid` is the empty string. `gameoptions.lua:12503` reads `xinput` to
--- choose between the controller and the joystick icon.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:4926
---@return table<integer, JoystickSlot> joysticks
function GetJoysticksOption() end


--- Gets the legacy shaders option. (No usage found in provided files)
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
---@return boolean legacyShadersEnabled True if legacy shaders are enabled.
function GetLegacyShadersOption() end


---@meta
---@class LibraryItem
---@field id string The item id - what `GetLibraryEntry` takes as its second argument.
---@field name string The item's displayed name.
---@field icon string The item icon.
---@field parent? string The item's parent, where the library is a tree.

---@meta
---@class LibraryItemFaction : LibraryItem
---@field relation number The player's relation to the faction.

--- Returns a whole data library as a list - `factions`, `stationtypes` and the rest of the
--- libraries the encyclopedia is built from. Each item carries only enough to list it; the
--- detail behind an item comes from `GetLibraryEntry` with the same library name and the item's
--- `id`. `GetLibrarySize` gives the entry count without reading the entries.
---
--- The item shape barely varies by library: `parent` appears only where the library is a tree,
--- and `relation` only on `factions`, which is why the diplomacy and player info menus bind the
--- result to a variable named `relations`. Passing `"factions"` as a literal gets
--- `LibraryItemFaction` back, which has `relation`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 16 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1188, ui/addons/ego_detailmonitor/menu_docked.lua:627
---@overload fun(libraryName: "factions"): LibraryItemFaction[]
---@param libraryName string The name of the library to retrieve, e.g. `"factions"` or `"stationtypes"`.
---@return LibraryItem[] library
function GetLibrary(libraryName) end


---@meta
---@class LibraryEntryBase
---@field name string The entry name.
---@field description string The entry description.
---@field icon string The entry icon.
---@field video? string The entry video.
---@field image? string The entry image.
---@field component? any The component the entry describes, where it has one.
---@field precursor? any The entry this one is built from.

---@meta
---@class LibraryEntryFaction : LibraryEntryBase
---@field factionid? string The faction id.
---@field primaryfactions? table The factions of a race. `races` only.
---@field primaryrace? string The faction's primary race.
---@field influencename? string The faction influence name.
---@field influencedescription? string The faction influence description.
---@field canclaim? boolean Whether the player can claim it.
---@field illegalwares? table Wares illegal to this faction.

---@meta
---@class LibraryEntryLicence : LibraryEntryBase
---@field price? number The licence price.
---@field minrelation? number The minimum relation required.
---@field issellable? boolean Whether the licence can be bought.

---@meta
---@class LibraryEntryShip : LibraryEntryBase
---@field hull? number Hull strength.
---@field shield? number Shield strength.
---@field mass? number Mass.
---@field speed? number Top speed.
---@field jumpdrive? boolean Whether the ship has a jumpdrive.
---@field radarrange? number Radar range.
---@field shiptypename? string The ship type name.
---@field storagecapacity? number Storage capacity.
---@field storagetags? any Storage tags.
---@field storagenames? any Storage names.
---@field shipstoragecapacity? number Ship storage capacity.
---@field unitcapacity? number Unit capacity.
---@field missilecapacity? number Missile capacity.
---@field docks_m? number M dock count.
---@field docks_s? number S dock count.

---@meta
---@class LibraryEntryModule : LibraryEntryBase
---@field hull? number Hull strength.
---@field products? table The products of a production module.
---@field resources? table The resources a production module consumes.
---@field productions? table Productions.
---@field storagecapacity? number Storage capacity.
---@field workforcecapacity? number Workforce capacity.
---@field maxworkforce? number Maximum workforce.
---@field radarrange? number Radar range. `moduletypes_radar` only.
---@field docks_m? number M dock count. Dock modules only.
---@field docks_s? number S dock count. Dock modules only.

---@meta
---@class LibraryEntryEngine : LibraryEntryBase
---@field thrust_forward? number Forward thrust.
---@field thrust_reverse? number Reverse thrust.
---@field thrust_vertical? number Vertical thrust.
---@field thrust_horizontal? number Horizontal thrust.
---@field thrust_pitch? number Pitch thrust.
---@field thrust_yaw? number Yaw thrust.
---@field drag_yaw? number Yaw drag.
---@field inertia_yaw? number Yaw inertia.
---@field yawspeed? number Yaw speed.
---@field pitchspeed? number Pitch speed.
---@field verticalstrafespeed? number Vertical strafe speed.
---@field horizontalstrafespeed? number Horizontal strafe speed.
---@field boost_thrustfactor? number Boost thrust factor.
---@field boost_chargetime? number Boost charge time.
---@field boost_rechargetime? number Boost recharge time.
---@field boost_maxduration? number Boost maximum duration.
---@field boost_accfactor? number Boost acceleration factor.
---@field travel_thrustfactor? number Travel drive thrust factor.
---@field travel_chargetime? number Travel drive charge time.
---@field travel_attacktime? number Travel drive attack time.

---@meta
---@class LibraryEntryWeapon : LibraryEntryBase
---@field range? number Weapon range.
---@field maxrange? number Maximum range.
---@field dps? number Damage per second.
---@field sustaineddps? number Sustained damage per second.
---@field hullonlydps? number DPS against hull only.
---@field hullshielddps? number DPS against hull through shields.
---@field hullnoshielddps? number DPS against unshielded hull.
---@field hullonlydpshot? number Damage per shot against hull only.
---@field hullshielddpshot? number Damage per shot against hull through shields.
---@field hullnoshielddpshot? number Damage per shot against unshielded hull.
---@field shieldonlydpshot? number Damage per shot against shields only.
---@field hullonlyareadpshot? number Area damage per shot against hull only.
---@field hullshieldareadpshot? number Area damage per shot against hull through shields.
---@field hullnoshieldareadpshot? number Area damage per shot against unshielded hull.
---@field shieldonlyareadpshot? number Area damage per shot against shields only.
---@field hullonlyareadamage? number Area damage against hull only.
---@field hullshieldareadamage? number Area damage against hull through shields.
---@field hullnoshieldareadamage? number Area damage against unshielded hull.
---@field explosiondamage? number Explosion damage.
---@field hullexplosiondamage? number Explosion damage to hull.
---@field shieldexplosiondamage? number Explosion damage to shields.
---@field bulletspeed? number Bullet speed.
---@field reloadrate? number Reload rate.
---@field chargetime? number Charge time.
---@field coolingrate? number Cooling rate.
---@field initialheat? number Heat per shot.
---@field maxheatrate? number Maximum heat rate.
---@field isbeamweapon? boolean Whether it is a beam weapon.
---@field isrepairweapon? boolean Whether it is a repair weapon.
---@field islongrange? boolean Whether it is long range.
---@field miningmultiplier? number Mining damage multiplier.
---@field surfaceelementmultiplier? number Surface element damage multiplier.
---@field shielddisruption? number Shield disruption.

---@meta
---@class LibraryEntryTurret : LibraryEntryWeapon
---@field rotation? number Turret rotation speed.
---@field maxyawangle? number Maximum yaw angle.
---@field maxpitchangle? number Maximum pitch angle.
---@field istracking? boolean Whether it tracks its target.
---@field isfriendfoe? boolean Whether it uses friend-foe identification.

---@meta
---@class LibraryEntryMissile : LibraryEntryBase
---@field speed? number Missile speed.
---@field acceleration? number Missile acceleration.
---@field damage? number Missile damage.
---@field explosiondamage? number Explosion damage.
---@field hullexplosiondamage? number Explosion damage to hull.
---@field shieldexplosiondamage? number Explosion damage to shields.
---@field range? number Missile range.
---@field maxlockrange? number Maximum lock range.
---@field locktime? number Missile lock time.
---@field proximityrange? number Proximity fuse range.
---@field guided? boolean Whether the missile is guided.
---@field istracking? boolean Whether it tracks its target.
---@field countermeasureresilience? number Resilience to countermeasures.

---@meta
---@class LibraryEntryShield : LibraryEntryBase
---@field hull? number Shield generator hull.
---@field shield? number Shield strength.
---@field recharge? number Shield recharge rate.
---@field rechargedelay? number Shield recharge delay.
---@field chargetime? number Charge time.

---@meta
---@class LibraryEntryWare : LibraryEntryBase
---@field avgprice? number Ware average price.
---@field volume? number Ware volume.
---@field transporttype? string Ware transport type.
---@field methods? table Ware production methods.
---@field illegalto? table Factions the ware is illegal to.
---@field issellable? boolean Whether the ware can be sold.
---@field isscanner? boolean Whether it is a scanner. Satellites and probes.
---@field scanlevel? number Scanner level. Satellites and probes.
---@field resourcedetectionrange? number Resource detection range. Probes.

---@meta
---@class LibraryEntry
---@field name string The entry name.
---@field description string The entry description.
---@field icon string The entry icon.
---@field video? string The entry video.
---@field image? string The entry image. Documented; the encyclopedia does not read it.
---@field component? any The component the entry describes, where it has one.
---@field race? string NPC race. Documented; the encyclopedia does not read it.
---@field faction? string NPC faction. Documented; the encyclopedia does not read it.
---@field factionid? string The faction id.
---@field primaryfactions? table The factions of a race.
---@field primaryrace? string A faction primary race. Documented; the encyclopedia does not read it.
---@field influencename? string The faction influence name.
---@field influencedescription? string The faction influence description.
---@field canclaim? boolean Whether the player can claim it.
---@field minrelation? number Minimum relation required.
---@field hull? number Hull strength.
---@field shield? number Shield strength.
---@field mass? number Mass.
---@field speed? number Top speed.
---@field jumpdrive? boolean Whether the object has a jumpdrive. Documented; the encyclopedia does not read it.
---@field storagecapacity? number Storage capacity.
---@field storagetags? any Storage tags. Documented; the encyclopedia does not read it.
---@field storagenames? any Storage names.
---@field shipstoragecapacity? number Ship storage capacity.
---@field unitcapacity? number Unit capacity.
---@field missilecapacity? number Missile capacity.
---@field workforcecapacity? number Workforce capacity.
---@field maxworkforce? number Maximum workforce.
---@field radarrange? number Radar range.
---@field docks_m? number M dock count.
---@field docks_s? number S dock count.
---@field shiptypename? string The ship type name.
---@field precursor? any The entry this one is built from.
---@field products? table The products of a production module.
---@field resources? table The resources a production module consumes.
---@field productions? table Productions. Documented; the encyclopedia does not read it.
---@field weapons? table Weapons. Documented; the encyclopedia does not read it.
---@field upgrades? table Upgrades. Documented; the encyclopedia does not read it.
---@field thrust_forward? number Forward thrust.
---@field thrust_reverse? number Reverse thrust.
---@field thrust_vertical? number Vertical thrust.
---@field thrust_horizontal? number Horizontal thrust.
---@field thrust_pitch? number Pitch thrust.
---@field thrust_yaw? number Yaw thrust.
---@field drag_yaw? number Yaw drag.
---@field inertia_yaw? number Yaw inertia.
---@field yawspeed? number Yaw speed.
---@field pitchspeed? number Pitch speed.
---@field verticalstrafespeed? number Vertical strafe speed.
---@field horizontalstrafespeed? number Horizontal strafe speed.
---@field boost_thrustfactor? number Boost thrust factor.
---@field boost_chargetime? number Boost charge time.
---@field boost_rechargetime? number Boost recharge time.
---@field boost_maxduration? number Boost maximum duration.
---@field boost_accfactor? number Boost acceleration factor.
---@field travel_thrustfactor? number Travel drive thrust factor.
---@field travel_chargetime? number Travel drive charge time.
---@field travel_attacktime? number Travel drive attack time.
---@field acceleration? number Missile acceleration. Documented; the encyclopedia does not read it.
---@field range? number Weapon or turret range.
---@field maxrange? number Maximum range.
---@field maxlockrange? number Maximum lock range.
---@field dps? number Damage per second.
---@field sustaineddps? number Sustained damage per second.
---@field hullonlydps? number DPS against hull only.
---@field hullshielddps? number DPS against hull through shields.
---@field hullnoshielddps? number DPS against unshielded hull.
---@field hullonlydpshot? number Damage per shot against hull only.
---@field hullshielddpshot? number Damage per shot against hull through shields.
---@field hullnoshielddpshot? number Damage per shot against unshielded hull.
---@field shieldonlydpshot? number Damage per shot against shields only.
---@field hullonlyareadpshot? number Area damage per shot against hull only.
---@field hullshieldareadpshot? number Area damage per shot against hull through shields.
---@field hullnoshieldareadpshot? number Area damage per shot against unshielded hull.
---@field shieldonlyareadpshot? number Area damage per shot against shields only.
---@field hullonlyareadamage? number Area damage against hull only.
---@field hullshieldareadamage? number Area damage against hull through shields.
---@field hullnoshieldareadamage? number Area damage against unshielded hull.
---@field damage? number Explosion damage. Documented; the encyclopedia reads the split values instead.
---@field explosiondamage? number Explosion damage.
---@field hullexplosiondamage? number Explosion damage to hull.
---@field shieldexplosiondamage? number Explosion damage to shields.
---@field bulletspeed? number Bullet speed.
---@field reloadrate? number Reload rate.
---@field chargetime? number Charge time.
---@field coolingrate? number Cooling rate.
---@field initialheat? number Heat per shot.
---@field maxheatrate? number Maximum heat rate.
---@field isbeamweapon? boolean Whether it is a beam weapon.
---@field isrepairweapon? boolean Whether it is a repair weapon.
---@field islongrange? boolean Whether it is long range.
---@field isscanner? boolean Whether it is a scanner.
---@field scanlevel? number Scanner level.
---@field miningmultiplier? number Mining damage multiplier.
---@field surfaceelementmultiplier? number Surface element damage multiplier.
---@field shielddisruption? number Shield disruption.
---@field rotation? number Turret rotation speed.
---@field maxyawangle? number Maximum yaw angle.
---@field maxpitchangle? number Maximum pitch angle.
---@field istracking? boolean Whether it tracks its target.
---@field isfriendfoe? boolean Whether it uses friend-foe identification.
---@field guided? boolean Whether the missile is guided.
---@field countermeasureresilience? number Resilience to countermeasures.
---@field locktime? number Missile lock time.
---@field proximityrange? number Proximity fuse range.
---@field recharge? number Shield recharge rate.
---@field rechargedelay? number Shield recharge delay.
---@field avgprice? number Ware average price. Documented; the encyclopedia does not read it.
---@field volume? number Ware volume. Documented; the encyclopedia does not read it.
---@field transporttype? string Ware transport type. Documented; the encyclopedia does not read it.
---@field methods? table Ware production methods. Documented; the encyclopedia does not read it.
---@field illegalto? table Factions the ware is illegal to.
---@field illegalwares? table Wares illegal to this faction.
---@field issellable? boolean Whether the ware can be sold.

--- Returns one entry of a data library, by library name and entry ID. The library name is often
--- not a constant: the map asks `GetMacroData(macro, "infolibrary")` which library a macro
--- belongs to and passes the answer straight in.
---
--- **The field set depends on the library.** Only `name`, `description` and `icon` are common to
--- all of them, so passing the library name as a string literal gets a narrow class back -
--- `LibraryEntryShip`, `LibraryEntryEngine`, `LibraryEntryWeapon` and so on - via the overloads
--- below. Passing a variable, which is what vanilla mostly does, falls back to `LibraryEntry`:
--- the union of every field, all optional, because nothing at that point says which library it is.
---
--- The split follows `menu_encyclopedia.lua`, which branches on `menu.library` before reading
--- fields - `weapons_lasers` and `weapons_missilelaunchers` at line 3383, `weapons_turrets` at
--- 3518, `missiletypes` at 3647, `shieldgentypes` at 2231, `enginetypes` at 2207, `licences` and
--- `factions` at 2196. Library names come from that file's own category config at line 483.
---
--- X4 returns considerably more per entry than any published list: the damage figures alone are
--- nine separate hull-and-shield permutations rather than one `dps`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 34 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1568, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:776
---@overload fun(libraryName: "factions"|"races", entryID: any): LibraryEntryFaction
---@overload fun(libraryName: "licences", entryID: any): LibraryEntryLicence
---@overload fun(libraryName: "ship_xl"|"ship_l"|"ship_m"|"ship_s"|"shiptypes_xl"|"shiptypes_l"|"shiptypes_m"|"shiptypes_s"|"shiptypes_xs", entryID: any): LibraryEntryShip
---@overload fun(libraryName: "stationtypes"|"moduletypes_production"|"moduletypes_build"|"moduletypes_storage"|"moduletypes_habitation"|"moduletypes_welfare"|"moduletypes_defence"|"moduletypes_dock"|"moduletypes_processing"|"moduletypes_other"|"moduletypes_radar"|"moduletypes_venture", entryID: any): LibraryEntryModule
---@overload fun(libraryName: "enginetypes"|"thrustertypes", entryID: any): LibraryEntryEngine
---@overload fun(libraryName: "weapons_turrets"|"weapons_missileturrets", entryID: any): LibraryEntryTurret
---@overload fun(libraryName: "weapons_lasers"|"weapons_missilelaunchers"|"bombs"|"mines"|"lasertowers", entryID: any): LibraryEntryWeapon
---@overload fun(libraryName: "missiletypes", entryID: any): LibraryEntryMissile
---@overload fun(libraryName: "shieldgentypes", entryID: any): LibraryEntryShield
---@overload fun(libraryName: "wares"|"inventory_wares"|"software"|"paintmods"|"satellites"|"navbeacons"|"resourceprobes"|"countermeasures", entryID: any): LibraryEntryWare
---@param libraryName string The name of the library.
---@param entryID any The ID of the entry to retrieve.
---@return LibraryEntry entry The union of every library's fields; pass a literal library name for a narrow type.
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
---
--- **It is the other half of `GetTargetMonitorDetails`.** That call returns the display template
--- with `$token$` placeholders in its `text` rows; `placeholder` is one of those tokens without
--- the dollars, and this resolves it against a component into the string to substitute.
--- `targetmonitor.lua:1052` dispatches on the name - `"targetmonitorstate"`, `"unitsstored"`,
--- `"containerheader"`, `"unlockheader"` and the rest.
---
--- `GetLiveData("hullpercent", ship, "")` -> `"100"`. **The return is a string**, whatever the
--- token measures. Passing `nil` for `placeholder` returns nothing at all and logs
--- `targetmonitor.lua(1243): GetComponentData(): Invalid argument #2 (got nil, expected string)`
--- from inside the function.
-- Source: ui\addons\ego_targetmonitor\targetmonitor.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Probed: 8.00, 9.00 - resolved against a ship, paired with the GetTargetMonitorDetails template
-- that carries the token, and the nil-placeholder failure reproduced on 8.00; a string on all
-- eight 9.00 targets
---@param placeholder string The template token to resolve, without the `$` delimiters, e.g. `"hullpercent"`.
---@param component any The component to read it from.
---@param templateConnectionName string The name of the template connection. Must be a string; `""` is accepted.
---@return string data The resolved text to substitute for the token.
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


---@meta
---@class LogbookEntry
---@field title string The entry's headline, drawn in bold.
---@field text string The entry body; may be the empty string, which vanilla skips rather than drawing.
---@field time number The entry timestamp, in game time.
---@field category any The entry's category.
---@field money number Credits gained or lost, 0 where the entry is not financial.
---@field bonus number Bonus credits, 0 where there are none.
---@field entityname string The entity the entry concerns; may be the empty string.
---@field factionname string The faction the entry concerns; may be the empty string.
---@field highlighted boolean Whether the entry is drawn in the highlight colour.
---@field interaction? string The interaction type, if the entry can be jumped to.
---@field interactiontext? string A format string for the jump button's mouse-over text, taking the component name.
---@field interactioncomponent? any The component the interaction targets; test it with `IsValidComponent` first.

--- Returns a page of logbook entries: `numQuery` of them starting at `startIndex`, limited to
--- one category. It can return nothing, so all three call sites fall back with `or {}`, and all
--- three page the log rather than asking for all of it - the query limit is a config value.
---
--- `menu_playerinfo.lua:2946` reads `title`, `text`, `time`, `money`, `bonus`, `entityname`,
--- `factionname`, `highlighted`, `interaction`, `interactiontext` and `interactioncomponent`.
--- An entry is only jumpable when `interaction` is set **and** `IsValidComponent` accepts its
--- `interactioncomponent`; vanilla checks both before drawing the button.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:16808, ui/addons/ego_detailmonitor/menu_playerinfo.lua:2855
---@param startIndex number The starting index for retrieval.
---@param numQuery number The number of entries to query.
---@param category any The category of logbook entries to retrieve.
---@return LogbookEntry[] logbook
function GetLogbook(startIndex, numQuery, category) end


--- Reads named properties off a macro, in the same variadic form as `GetComponentData`: every
--- argument after the macro is a property name, and one value comes back per name, in order.
--- Unlike `GetComponentData` it takes a macro name rather than a component, so it works without
--- an instance of the thing existing anywhere in the game.
---
--- `infolibrary` is the key worth knowing: it names the library the macro belongs to, which is
--- what the map feeds straight into `GetLibraryEntry`. The 55 keys 9.00 vanilla passes, most
--- used first:
---
--- `name`, `infolibrary`, `ware`, `makerraceid`, `shortname`, `islasertower`, `primarypurpose`,
--- `entityfemale`, `makerrace`, `makerracename`, `shiptype`, `icon`, `sectors`, `compatibility`,
--- `entityrace`, `image`, `macro`, `ammoicon`, `basemacro`, `compatibilityinfo`,
--- `entityracename`, `hasinfoalias`, `isventuremodule`, `mk`, `size`, `isminingweapon`, `isunit`,
--- `isvirtual`, `prestigename`, `sectorcomponent`, `shieldcapacitymodifier`,
--- `shieldrechargedelaymodifier`, `shieldrechargeratemodifier`, `shiptypename`, `spacesuitmacro`,
--- `storagetags`, `tier`, `waregroup`, `weaponheatmodifier`, `canclaimownership`,
--- `defaultmaxtraveldrivestabilityvalue`, `haswaveprotection`, `isdeployable`, `isfixedstation`,
--- `isintegrated`, `isshowroomdock`, `isshowroommodule`, `makericon`, `maxradarrange`,
--- `maxtraveldrivestabilityvalue`, `maxworkforce`, `primarypurposeicon`,
--- `resourcedetectionrange`, `waregroupicon`, `workforcecapacity`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 251 vanilla call sites, 2-9 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_docked.lua:509, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:574
---@param macro string The name of the macro.
---@param ... string One or more property names.
---@return ... any One value per name, in the order asked.
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


--- How many characters of `text` fit into `width` pixels when drawn in the named font at the
--- named size. It measures a string against a box; it has nothing to do with a widget, and the
--- element ID this was once declared to take does not exist.
---
--- `GetMaxTextLength("Probe text", "Zekton", 22, 200)` -> `10`. All four parameters are
--- required: a bare call answers `Invalid number of arguments (0, expected 4)`. It needs no game
--- object and changes nothing, so it can be called from anywhere at any time.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - one working call with synthesised arguments, arity stated by the engine
-- in words; both rungs answered the same either side
---@param text string The string to measure.
---@param fontname string The font to measure it in, e.g. `"Zekton"`.
---@param fontsize number The font size.
---@param width number The available width in pixels.
---@return number maxLength How many characters of `text` fit into `width`.
function GetMaxTextLength(text, fontname, fontsize, width) end


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


--- Returns the mining unit macros a ship macro can carry - the drones it launches to mine.
--- The argument is a **macro name string**, not a component; this row declared no parameter
--- at all until it was measured. A bare call still returns an **empty array**, so the return
--- value never announces the missing argument - but the engine does, in the log:
--- `Invalid number of arguments (0, expected 1)`. Reading returns alone is what hid this.
---
--- Measured on 8.00: `ship_arg_m_miner_liquid_01_a_macro` ->
--- `ship_gen_s_miningdrone_liquid_01_a_macro`. Every other macro measured returns an empty
--- array, solid miners included, so the answer is whether the macro carries mining **drones**
--- and not whether it mines at all. `GetStandardUnitMacros` on the same macro returns this
--- set plus the cargo drone, so this is the mining subset of that one.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 54 calls over nine ship macros and a station macro, one non-empty; twelve
-- more calls on 9.00, still at most one entry
---@param macro string The macro name of the ship to ask about.
---@return string[] macros The mining unit macros, empty when the macro carries none.
function GetMiningUnitMacros(macro) end


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


--- Returns the people on stations in `sector` that are within `distance` of **the player** -
--- not of the sector being asked about. The sector argument selects the population, the radius
--- is measured across the universe from wherever the player is, in metres, so a remote sector
--- needs a radius on the order of 1e8 before it answers at all.
---
--- `distance` is a literal radius and not a flag: `0` returns nothing, in every sector, every
--- time. The count saturates at the sector's own total once the radius covers it - Ore Belt
--- reached 31 at 500000 and stayed there through 1e9 - so a huge value is an honest radius
--- rather than a sentinel for "no limit".
---
--- The container has to be a `station` or a `buildstorage`. People on ships are not included,
--- whatever the radius.
---
--- Both arguments are 64-bit component IDs. A `UniverseID` cdata straight out of
--- `C.GetContextByClass` is refused with
--- `Invalid argument #1 <sector> (got cdata, expected component ID)` - convert it first.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - the reference point measured against three candidates over seven sectors
-- and then proved by moving the player: the gradient followed them, so no sector-local point can
-- be what the radius is measured from. The same split on 9.00 over eight sectors: the player's
-- own sector answers 0, 7, then 34 as the radius grows while every other sector answers 0 at
-- every radius, and the first non-empty radius lands on the nearest npc's own distance from the
-- player to the metre
---@param sectorID any The sector whose stations are searched, as a 64-bit component ID.
---@param distance number The radius in metres, measured from the player. 0 returns nothing.
---@return table npcs The people found, empty when none are in range.
function GetNPCsInSectorOnStations(sectorID, distance) end


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


---@meta
---@class OwnLicence
---@field id string The licence id.
---@field type string The licence type.
---@field name string The licence's displayed name.
---@field price number The licence price.
---@field minrelation number The minimum relation required to buy it.
---@field issellable boolean Whether the licence can be bought from this faction.
---@field icon? string The licence icon.
---@field desc? string The licence description.
---@field isbasic? boolean Whether it is a basic licence.
---@field precursor? string The licence that must be held first.
---@field parent? string The licence this one sits under.

--- Returns the licences a faction offers, as a list. Called per faction rather than for all of
--- them - the diplomacy and player information menus loop over the relations and ask for each
--- one, then sort the result themselves; the trader menu asks only about the faction being
--- traded with.
---
--- `precursor` and `parent` are what make the list a tree: a licence with a `precursor`
--- cannot be bought until that one is held.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_diplomacy.lua:1200, ui/addons/ego_detailmonitor/menu_encyclopedia.lua:564
---@param factionID string The ID of the faction.
---@return OwnLicence[] licences
function GetOwnLicences(factionID) end


--- Returns the people aboard a controllable, broken down by role. The result is a mixed table: an
--- array of one entry per role actually present - { amount, name, role }, where name is the display
--- name ("Crewman", "Marine") and role the libraries/roles.xml id - plus the hash keys capacity and
--- stored holding the object's totals.
---
--- Passing a role in argument 2 filters the array to that role alone and adds a rolestored key with
--- its headcount; a role nobody holds gives an empty array and rolestored 0. Measured on 8.00, a
--- crewed XL ship: 181 service + 179 marine, capacity 361, stored 361.
---
--- The roles do not sum to stored. In that measurement they came to 360 against a stored of 361:
--- a person filling a control post, such as the captain or a station manager, is counted in the
--- total but belongs to no role. An object whose people all hold posts returns an empty array, so
--- the array part is invisible unless role-holding crew are actually aboard.
---
--- Argument 1 is a controllable, not a role: a role string in slot 1 gives "Invalid argument #1
--- <controllable> (got string, expected component ID)", and an npc gives "is not of class
--- controllable". Both rejections still return a table rather than failing, so an empty result is
--- not by itself evidence that the call was accepted.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - both arguments and the return shape measured in-game; on 9.00 the bare
-- call refused with "expected >= 1", seven role ids each answering, and a person refused as not
-- of class controllable
---@param controllable any The ship or station whose people to report.
---@param role? string A role id from libraries/roles.xml, e.g. "marine", "service", "worker".
---@return table roleData Array of { amount: integer, name: string, role: string }, plus capacity, stored and (when role is given) rolestored.
function GetPeopleRoleData(controllable, role) end


--- Returns whether crash reports carry the player's user ID, and pairs with
--- `SetPersonalizedCrashReportsOption` on the privacy page - the separate question from whether
--- reports are sent at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:2895
---@return boolean isEnabled True if personalized crash reports are enabled.
function GetPersonalizedCrashReportsOption() end


--- Returns the **docking bays** of a container, whatever this name suggests - every one of 358
--- elements measured across five targets resolved to class `dockingbay`, with bay names like
--- "S Standard Docking Bay" and "M Luxury Docking Bay". It accepts ships as readily as
--- stations: a player HQ gave 172, a shipyard 166, a Tokyo carrier 19, a Syn destroyer 1 and a
--- Katana corvette 0 - the empty being the correct answer for a ship with no bay.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - arity 1, every element's class resolved over the whole array, on both
-- versions
---@param container any The ship or station whose docking bays to list.
---@return table dockingBays Array of `dockingbay` components; empty when the container has none.
function GetPlatforms(container) end


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


--- Returns the player's inventory, keyed by ware id, in the same shape `GetInventory` returns
--- for any other entity: each value carries `name`, `amount` and `price`. Every menu that shows
--- or spends inventory wares - crafting, the mod shop, the player information page - reads it
--- fresh rather than caching it, because crafting and trading both change it underneath.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 11 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:227, ui/addons/ego_detailmonitor/menu_diplomacy.lua:4110
---@return table<string, InventoryWare> inventory
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


---@meta
---@class DisplayAdapter
---@field name string The adapter name.
---@field ordinal integer The adapter ordinal - the value `SetAdapterOption` takes.

--- Returns the graphics adapters that can be selected, as a list. The options menu pairs it
--- with `GetAdapterOption` to build the dropdown and mark the current one; `GetAdapterOption`
--- reports the adapter by **name**, so vanilla matches on `name` and then uses `ordinal` as the
--- dropdown's value.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:6936
---@return DisplayAdapter[] adapters
function GetPossibleAdapters() end


---@meta
---@class ProductResource
---@field ware string The resource ware id.
---@field name string The resource's displayed name.
---@field cycle number The amount consumed per cycle.

---@meta
---@class PossibleProduct
---@field ware string The product ware id.
---@field name string The product's displayed name.
---@field cycletime number The cycle duration in seconds - the `time` of the matching method in `libraries/wares.xml`.
---@field component string Empty string on every target measured, both player and NPC owned. Unexplained.
---@field resources ProductResource[] What each cycle consumes; each element's `cycle` is that input's `amount`.

--- Returns what a production module produces - despite the plural, **one entry per module, not
--- one per production method of the ware**. A hull parts module returned only the `default`
--- method, 900s for graphene 40 / energycells 80 / refinedmetals 280, though `hullparts` defines
--- three methods; `libraries/modulegroups.xml` explains it, giving `prod_gen_hullparts` and
--- `prod_tel_hullparts` **separate module macros**. So the module's own macro decides the
--- method, and the ware's method list is not what this reads.
---
--- The module is class `module, destructible, production` and **not** `container` or `object`,
--- which is the class shape a container-guard silently skips. **The station holding it is not a
--- substitute**: a player factory answered an empty array where its own production module
--- answered the ware in full.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - two wares, two owners, entries dumped in full, arity 1; on 9.00 a
-- production module answered one entry in full while the station holding it answered empty
---@param moduleID any The production module to ask about.
---@return PossibleProduct[] products
function GetPossibleProducts(moduleID) end


---@meta
---@class ScreenResolution
---@field width number Resolution width in pixels.
---@field height number Resolution height in pixels.

--- Returns the resolutions the display can take, as a list. The options menu sorts them itself
--- and marks the one `GetResolutionOption` reports.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:7386
---@return ScreenResolution[] resolutions
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


---@meta
---@class ProductionWare
---@field ware string The ware id.
---@field name string The ware's displayed name.
---@field amount number The amount in storage.
---@field cycle number The amount per cycle.
---@field component string The component name.

---@meta
---@class ProductionWareList
---@field [integer] ProductionWare The wares themselves.
---@field efficiency number Efficiency percentage; 100 by default.

---@meta
---@class ProductionModuleData
---@field state string `"producing"`, `"waitingforresources"`, `"empty"` and the other production states.
---@field cycletime number Cycle duration; 0 unless the state is `producing`.
---@field remainingcycletime number Time left in this cycle; 0 unless the state is `producing`.
---@field cycleprogress number Percentage through the current cycle; 0 unless the state is `producing`.
---@field cycleefficiency number Cycle efficiency percentage; 100 by default.
---@field remainingtime number Time until the module runs out of resources. Ignores limited storage space.
---@field products ProductionWareList What the module makes.
---@field presources ProductionWareList Primary resources, in the same shape as `products`.
---@field sresources ProductionWareList Secondary resources, in the same shape as `products`.
---@field estimated? boolean Non-nil when the figures are filtered rather than exact.

--- Returns the live production state of a module. It can come back holding nothing but
--- `state = "empty"` for a module that is not producing at all, and the map menu tests for
--- that; `menu_research.lua` relies on the same thing, guarding `cycleprogress` with `or 0`.
---
--- `cycletime`, `remainingcycletime` and `cycleprogress` are 0 outside the `producing` state
--- rather than absent. The three ware lists carry their wares in the array part and an
--- `efficiency` percentage as a named field alongside them, so walk them with `ipairs`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 21 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:17814, ui/addons/ego_detailmonitor/menu_research.lua:271
---@param module any The production module to inspect.
---@return ProductionModuleData data
function GetProductionModuleData(module) end


--- Returns the production modules of a station, as a list. Vanilla uses both the list itself
--- and just its length - `#GetProductionModules(id) > 0` is how a menu decides whether a
--- station produces anything at all.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 9 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_encyclopedia.lua:2761, ui/addons/ego_detailmonitor/menu_map.lua:14498
---@param objectID any The ID of the object (e.g., station).
---@return table modules A table of production modules, as Lua-side component ids. Every vanilla
--- site feeds them straight back to a Lua global such as `GetComponentData`; an `ffi` call needs
--- `ConvertIDTo64Bit` first, and handed one raw it reads nothing.
function GetProductionModules(objectID) end


--- Returns "" on every call, on both versions, so nothing has ever read a radar module name
--- out of it. 9.00 deprecates it outright: the engine answers every call with `has been
--- deprecated and has no effect` and no longer checks the argument count, where 8.00 refuses a
--- bare call with `Invalid number of arguments (0, expected 1)`.
-- Environment: addons only
-- Versions: 8.00 - deprecated in 9.00
-- Usage: unverified - no vanilla call site
-- Deprecated: 9.00 - the engine answers every call with `has been deprecated and has no
-- effect`, and stops checking the argument count; 8.00 still refuses a bare call
-- Probed: 8.00, 9.00 - the one behaviour difference the 9.00 pass found: "" and a live arity
-- check on 8.00, the deprecation notice and no arity check on 9.00, over two call keys in two
-- separate runs
---@param object any The object to ask about. Never read; 9.00 does not check that it is there.
---@return string name Always "", on both versions.
function GetRadarModuleName(object) end


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


---@meta
---@class RegisteredModule
---@field id string The module id.
---@field name string The module's displayed name.
---@field description? string The gamestart description, if any.
---@field image? string The gamestart image, if any.
---@field tutorial? boolean Whether the module is a tutorial.
---@field group? any The group the tutorial belongs to; the help menu groups by it.
---@field unlocked? boolean Whether the module is unlocked.
---@field unlockhidden? boolean Whether it is hidden until unlocked.
---@field hasunlockconditions? boolean Whether it has unlock conditions at all.
---@field unlockprogress? number Progress towards unlocking.
---@field unlocktotal? number The total needed to unlock.
---@field unmetuserdata? any The unmet unlock condition.
---@field custom? boolean Whether it is a custom module.
---@field timelinesscenario? boolean Whether it is a Timelines scenario.
---@field scenariodata? table Scenario details; carries `chapter`.
---@field scenariochapterfinale? boolean Whether it ends its chapter.
---@field usetimelinesplayercharacter? boolean Whether it uses the Timelines player character.

--- Returns the registered game modules - tutorials and scenarios - as a list. Called with no
--- argument it leaves scenarios out; the scenario selection passes true to get them.
---
--- The help menu filters on `unlockhidden` and `unlocked` and groups tutorials by
--- `group`, and the scenario selection uses `timelinesscenario`, `scenariodata.chapter`,
--- `hasunlockconditions` and `unlocked` to decide what to show. Note that `stats` and `ladder`,
--- which also appear on these entries in `menu_scenario_selection.lua`, are added by the menu
--- afterwards and do not come from here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 0-1 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_help.lua:215, ui/addons/ego_detailmonitor/menu_scenario_debriefing.lua:90
---@param includeScenarios? boolean If true, includes scenarios in the list.
---@return RegisteredModule[] modules
function GetRegisteredModules(includeScenarios) end


--- Returns the mouse cursor position in an element's own coordinate space, as x, y and z.
--- 0/0/0 is the element's upper left front edge. Without `useElementSize`, or with it false, the
--- range is 0 to 1; with it true the range runs to the element's own `boxWidth`, `boxHeight`
--- and `boxDepth`.
---
--- The result is undefined if the element is not pickable at all, or was not hit by the cursor
--- in the current frame - vanilla only ever calls it on an element it has just established the
--- mouse is over. Two of the three call sites take x and y alone and ignore z.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 2 arguments
-- Seen at: ui/core/lua/dialogmenu.lua:892, ui/core/lua/monitors.lua:3633
---@param elementID any The ID of the UI element.
---@param useElementSize? boolean Scale to the element's own size instead of 0 to 1.
---@return number x The relative x-coordinate.
---@return number y The relative y-coordinate.
---@return number z The relative z-coordinate.
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


---@meta
---@class SaveInvalidPatch
---@field id string The patch id.
---@field name string The patch name.
---@field state any The patch state.
---@field requiredversion any The version the savegame requires.
---@field installedversion any The version currently installed.

---@meta
---@class SaveGameEntry
---@field filename string The save file name.
---@field name string The savegame name. Where `error` is set, this holds the non-localised error message instead.
---@field displayedname string The name as the menu shows it.
---@field description string The savegame description.
---@field location string The save location.
---@field time string The formatted save date.
---@field rawtime number The save date as a number.
---@field version any The savegame version.
---@field rawversion any The savegame version as a number.
---@field empty boolean Whether the slot is empty.
---@field error boolean The savegame could not be read; `name` then holds the error message.
---@field modified? boolean Whether the save was made on a modified game.
---@field isonline? boolean Whether it is an online save.
---@field isonlinesavefilename? boolean Whether the file name is an online save name.
---@field invalidgameid? boolean The save is from a different game.
---@field invalidversion? boolean The save version is newer than the running game.
---@field invalidpatches? SaveInvalidPatch[] Extensions whose versions do not match.
---@field playtime? number Played time. Documented; vanilla does not read it.
---@field playername? string Player name. Documented; vanilla does not read it.
---@field money? number Player money. Documented; vanilla does not read it.
---@field difficulty? any Save difficulty. Documented; vanilla does not read it.
---@field mindifficulty? any The lowest difficulty the save was ever set to. Documented; vanilla does not read it.

--- Returns the savegames as a list. The argument is a filter function the engine calls per
--- file - vanilla passes `Helper.validSaveFilenames`, which keeps the game's own naming scheme
--- and drops anything else in the folder.
---
--- It is performance critical: do not call it unnecessarily. The three `invalid*` fields are
--- what the load menu checks before letting a save be opened, and `error` marks a save that
--- could not be read at all - its `name` then carries the raw error message rather than a
--- savegame name.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 4 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:24909, ui/addons/ego_gameoptions/gameoptions.lua:11608
---@param filter? function An optional function to filter the save game list.
---@return SaveGameEntry[] savegames
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


--- Returns the unit macros a ship macro carries as standard. The argument is a **macro name
--- string**, not a component; this row declared no parameter until it was measured. A bare call
--- still returns an **empty array**, so nothing in the return value says an argument is
--- missing - the engine says it in the log instead, as
--- `Invalid number of arguments (0, expected 1)`.
---
--- Measured on 8.00, and the set is small: every ship macro tried - bomber, corvette,
--- destroyer, battleship, both miners - returns `ship_gen_xs_cargodrone_empty_01_a_macro`;
--- `ship_ter_xl_carrier_01_a_macro` adds `ship_gen_xs_buildingdrone_01_a_macro`; and
--- `ship_arg_m_miner_liquid_01_a_macro` adds `ship_gen_s_miningdrone_liquid_01_a_macro`,
--- which is exactly what `GetMiningUnitMacros` returns on its own for that macro. A station
--- macro returns an empty array.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 54 calls over nine ship macros and a station macro; no target has yet
-- returned more than two entries, twelve more 9.00 calls included
---@param macro string The macro name of the ship to ask about.
---@return string[] macros The standard unit macros, empty when the macro carries none.
function GetStandardUnitMacros(macro) end


--- Reads named properties of one statistic and returns one value per name, in order. Same
--- shape as `GetComponentData`: ask for everything you need in one call. The statistic IDs
--- come from `GetAllStatIDs`.
---
--- **Five property names are measured**, where vanilla uses only the last three:
--- `"exists"` (boolean), `"value"` (the raw number), `"hidden"` (boolean, the `secret`
--- attribute of `libraries/stats.xml` resolved against the current value), `"displayname"`
--- and `"displayvalue"`. **`"displayvalue"` is formatted, not numeric** - the same statistic
--- reads back as `"480"` and, once set to 4242, as `"4,242"` - so anything doing arithmetic
--- wants `"value"`.
---
--- **A bad property name and a bad statistic ID fail differently.** A bad name is reported as
--- `Invalid argument N, got unknown key 'X'`, puts `nil` in that slot and still returns every
--- good property beside it. A bad ID returns **no values at all**, silently, with nothing in
--- the log - so `nret == 0` means argument 1 was wrong, and `"exists"` can never answer
--- `false`. Use `GetAllStatIDs` to test for a statistic, not this.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 2-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_playerinfo.lua:2527, ui/addons/ego_detailmonitor/menu_playerinfo.lua:2531
-- Probed: 8.00, 9.00 - five keys measured on one statistic, plus a bad-key and an absent-id
-- control; the same answers on both versions, the good key still returned beside the bad one
---@param stat string The statistic ID, one of those `GetAllStatIDs` returns.
---@param ... string Property names: exists, value, hidden, displayname, displayvalue.
---@return ... any One value per requested property, in order; nothing at all if the ID is unknown.
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


---@meta
---@class StorageWare
---@field ware string The ware id.
---@field name string The ware's displayed name.
---@field amount number Units currently stored.
---@field volume number Volume per unit.
---@field consumption number Consumption and production of this ware.

---@meta
---@class StorageModule
---@field [integer] StorageWare The wares held in this cargo bay.
---@field name string The cargo bay's name.
---@field capacity number The bay's capacity.
---@field stored number The amount stored in the bay.
---@field consumption number The bay's total consumption.

---@meta
---@class StorageData
---@field [integer] StorageModule One entry per storage module.
---@field capacity number Total capacity across all modules.
---@field stored number Total amount stored across all modules.
---@field estimated? boolean Non-nil when the figures are filtered rather than exact.
---@field modules? StorageModule[] Documented, but no vanilla code reads it.

--- Returns the storage of a container as an array of storage modules, plus the totals.
--- Iterate the array part for the modules and each module's own array part for its wares -
--- all five vanilla call sites do exactly that, and `menu_map.lua:14529` spells the fields out
--- in its own comments. The totals `capacity` and `stored` sit on the returned table itself;
--- `estimated` is non-nil only where the player cannot see exact figures, which is what
--- `targetmonitor.lua` tests before prefixing the value with an approximation mark. For a
--- container with no storage information the table is empty, so vanilla guards every read
--- with `next(storagearray)`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:14043, ui/addons/ego_targetmonitor/targetmonitor.lua:878
---@param object any The container to inspect.
---@return StorageData
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


--- Builds the full target-monitor description for a component: the display template, with
--- `$token$` placeholders in its `text` rows that `GetLiveData` resolves one at a time.
---
--- The returned table carries `duration`, `header` (itself `color{r,g,b,a,glow}`, `font`,
--- `fontsize`, `text`), `notorietyComponent`, `notorietyEffect`, `notorietyFaction`,
--- `notorietyIcon` and `text`. **The shape varies with the target**: a sector returned those 7
--- keys with an empty `text`, a player station 8 - adding `interactionID` - with `text` a
--- 3-element array of `{left, right}` rows.
---
--- **`templateConnectionName` must be a string.** `""` is accepted and produces no error at all;
--- `nil` still returns a partial table but logs `GetCompSlotPlayerActionTriggeredConnection():
--- Given connection name is nullptr` plus three `targetmonitor.lua: HasTag(): Invalid argument
--- #2 <templateConnectionName> (got nil, expected string)` from inside the function.
-- Source: ui\addons\ego_targetmonitor\targetmonitor.lua
-- Defined by an addon file, not by the engine, and explicitly not part of the public
-- UI API - the vanilla source says so at targetmonitor.lua:1044. Returns an empty table
-- for an invalid component.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Probed: 8.00, 9.00 - a sector, a player station and a player ship, keys enumerated on each,
-- with the nil and empty-string connection names measured against one another on 8.00; eight
-- 9.00 targets, eight keys on a ship and seven on everything else
---@param component any The component to describe.
---@param templateConnectionName string The connection the template is bound to. Must be a string; `""` is accepted.
---@param isSofttarget boolean Whether the component is the current soft target.
---@return table details The display template, empty for an invalid component.
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


---@meta
---@class TradePriceModifier
---@field name string The modifier name.
---@field level any The modifier level.
---@field amount number The modifier amount.
---@field expire number When the modifier expires.

---@meta
---@class TradeData
---@field id any The trade id - what `CanTradeWith` and `IsValidTrade` take.
---@field ware string The ware traded.
---@field name string The ware's displayed name.
---@field amount number The trade amount.
---@field desiredamount number The desired amount.
---@field minamount number The minimum amount; vanilla passes this to `CanTradeWith`.
---@field price number The trade price.
---@field marketprice number The price before discounts and commissions.
---@field quantityfactor number Market price divided by average price.
---@field totalprice number Price times amount.
---@field totalmarketprice number Market price times amount.
---@field isbuyoffer boolean Whether the offer is a buy offer.
---@field isselloffer boolean Whether the offer is a sell offer.
---@field rebundle boolean Whether units are rebundled.
---@field unbundle boolean Whether units are unbundled.
---@field expire number When the trade expires.
---@field isshady? boolean Whether the offer is a shady one; the map can filter on it.
---@field ismissionoffer? boolean Whether the offer belongs to a mission.
---@field issupply? boolean Whether the offer is a supply offer.
---@field station? any The trade container.
---@field stationname? string The trade container's name.
---@field stationzone? string The trade container's zone name.
---@field stationzoneid? any The trade container's zone.
---@field stationsectorid? any The trade container's sector.
---@field isplayer? boolean Whether the trade container is player owned.
---@field faction? string The trade container's faction.
---@field pricemodifiers? TradePriceModifier[] The modifiers applied to the price.

--- Returns everything about one trade - the ware, the amounts, the price. The second argument
--- is the container it is being looked at from, which decides whether the trade reads as a buy
--- or a sell; without it the trade is described from its own side. Guard it with
--- `IsValidTrade`, because a trade can be gone by the time the row showing it is redrawn.
---
--- The station fields and `pricemodifiers` are only present where the trade has a container
--- behind it. The map reads `isshady`, `ismissionoffer` and `issupply` when it sorts offers
--- into its buy, sell and mission lists. Fields
--- like `active`, `stale` and `ammotypename` also appear on these tables in `menu_map.lua`, but
--- the menu writes those itself - they do not come from here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 3 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:1063, ui/addons/ego_detailmonitor/menu_map.lua:27498
---@param tradeID any The trade to read.
---@param component? any Container the trade is viewed from, which decides the buy/sell direction.
---@return TradeData tradedata
function GetTradeData(tradeID, component) end


--- Returns the trade offers of a container, as seen from a given ship, each entry in the same
--- shape `GetTradeData` returns for a single trade.
---
--- The third argument selects which half of the list comes back. Vanilla calls it twice on the
--- same container and ship - once with the argument omitted for the offers the ship can act on,
--- and once with false for the rest, which it then marks `stale` and inactive after
--- deduplicating them against the first set by trade id.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 6 vanilla call sites, 1-3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21371, ui/addons/ego_detailmonitor/menu_map.lua:21372
---@param tradeOfferContainer any The station or ship offering the trades.
---@param currentShip? any The ship the offers are evaluated for.
---@param unknown? boolean Selects which half of the list is returned.
---@return TradeData[] tradeoffers
function GetTradeList(tradeOfferContainer, currentShip, unknown) end


--- Returns the trade orders a container currently has queued, as an array of order entries. Each
--- entry names the ware and the station it is placed at, the agreed amount and price, and flags for
--- what kind of order it is:
---   amount, minamount   integer   units ordered, and the smallest acceptable fill
---   name                string    ware name, e.g. "Advanced Composites"
---   price               number    this order's price; averageprice is the ware's market average
---   id                  userdata  the order's own component id
---   station, stationname          the counterparty station and its name
---   isbuyoffer, isselloffer, ispassive, isshiptoship, iswareexchange   boolean
---
--- The array is a flat list of whatever orders the container currently holds, one entry each, in no
--- documented order. Measured on 8.00: a mining ship held a single buy order (6250 Ice at one
--- station), a trade ship held two for the same ware, one marked isselloffer and one isbuyoffer at
--- different stations. Do not read a pairing into that - the two entries are independent orders that
--- happened to share a ware, not the legs of one run. A container with nothing queued returns an
--- empty table, so an empty result means no orders, not a bad call.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - signature and return shape measured in-game, on both versions
---@param container any The ship or station whose orders to report.
---@return table orders Array of { amount, minamount, name, price, averageprice, id, station, stationname, isbuyoffer, isselloffer, ispassive, isshiptoship, iswareexchange }.
function GetTradeOrders(container) end


---@meta
---@class TradeRestrictions
---@field faction boolean The global restriction on trading with other factions.
---@field overrides table<string, boolean> Per-ware overrides of that global restriction.

--- Returns the trade restrictions on a container: one global faction restriction plus the
--- per-ware overrides of it. `ToggleFactionTradeRestriction` and `ToggleFactionTradeWareOverride`
--- are the setters for the two halves.
---
--- No vanilla code calls it, so the signature is unverified: the container parameter and the
--- shape are what the community reference describes, and the entry here previously declared no
--- parameter at all. Note that the documentation spells the second field `overrrides`, with
--- three r's; that is a typo in the documentation rather than the field name, but nothing here
--- can confirm which spelling the engine actually returns.
--
-- The engine answers every call with `Obsolete since version 3.20, returns empty data!` and an
-- empty table. So the shape below is the documentation's, not a measurement: nothing this
-- build returns can confirm it.
-- Environment: addons only
-- Versions: none - present in both, but deprecated in 3.20
-- Usage: unverified - no vanilla call site
-- Deprecated: 3.20 - the engine answers every call with `Obsolete since version 3.20,
-- returns empty data!` and an empty table, on both versions
-- Probed: 8.00, 9.00 - empty data, with the engine's obsolescence notice beside it, on both
-- versions
---@param containerID any The container to ask about.
---@return TradeRestrictions restrictions
function GetTradeRestrictions(containerID) end


--- Returns the trades offered at one connection of a container. Arity is 2, stated by the engine
--- itself (`Invalid number of arguments (0, expected 2)`), and argument 2 is a template
--- connection name by the shape of its only sibling, `GetMissionOfferAtConnection`, which vanilla
--- calls twice and gates on `HasTag(component, connection, "mission")`.
---
--- **The return is still unmeasured.** The connection an interact menu carries on the map is
--- `"connectionui"`, the generic UI connection rather than a tagged interaction point, and the
--- sibling answered nothing on it either. A tagged connection belongs to a trade console or dock
--- point, which can only be clicked in first person, where the interact menu does not open.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
-- Probed: 8.00, 9.00 - arity from the engine on both versions; no tagged connection has been
-- reached to ask on
---@param component any The container the connection belongs to.
---@param templateConnectionName string The name of the template connection.
---@return table trades
function GetTradesAtConnection(component, templateConnectionName) end


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


---@meta
---@class TradeShipCargo
---@field ware string The ware id, as in `wares.xml`.
---@field name string The ware's displayed name.
---@field amount number Units of the ware carried.
---@field volume number Volume of THIS stack - the amount times the ware's unit volume, not the unit volume.

---@meta
---@class TradeShipQueueEntry
---@field id any The trade partner's cargo bay: a `cargobay` component, not an abstract trade id.
---@field name string The ware's displayed name.
---@field amount number The trade amount.
---@field minamount number The trade's minimum amount.
---@field price number The trade price.
---@field averageprice number The ware's universe average price from `wares.xml` - a constant, not this ship's average.
---@field isbuyoffer boolean Whether the ship is selling.
---@field isselloffer boolean Whether the ship is buying.
---@field stationname? string The trade partner's name.
---@field stationsectorid? any The trade partner's sector.

---@meta
---@class TradeShipData
---@field shipid any The ship id.
---@field name string The ship's displayed name.
---@field cargo TradeShipCargo[] One entry per ware stack in the hold; empty when the hold is empty.
---@field queue TradeShipQueueEntry[] The ship's trade queue.
---@field cargocurrent number Cargo space used, in volume - not in units of ware.
---@field cargomax number Cargo capacity, in volume.
---@field cargofree number Free cargo capacity, in volume.
---@field numtrips number The number of planned trips. Matched the queue length in both ships measured.

--- Returns the trade-related state of one ship: what it is carrying, its cargo figures and its
--- trade queue. Note that `isbuyoffer` and `isselloffer` read from the offer's side, not the
--- ship's - a buy offer is one the ship sells into.
---
--- **The argument must be a ship.** A station is refused with `Component '<name>' is not of class
--- ship` and nothing comes back. `GetTradeShipList` returns a list of these.
---
--- `cargo` and `queue` are both plain arrays, countable with `#`. `cargo` is **one entry per ware
--- stack** rather than a single record, which is what this row declared until a loaded miner was
--- measured, and it is empty on a ship with an empty hold.
---
--- **The cargo figures are volumes, not units.** A miner holding 5,000 silicon reports
--- `amount = 5000` and `volume = 50000` - the ware's unit volume of 10 times the amount - and
--- `cargocurrent` is that same 50,000 against a `cargomax` of 50,000 with `cargofree` at 0.
---
--- The offer-side reading of the two flags is measured too: a trader's queued pair came back as
--- `isselloffer = true` at 481 where it buys and `isbuyoffer = true` at 485 where it sells.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - the whole structure, on a loaded miner and a trader with two trades
-- queued; the same eight keys on four 9.00 ships, with `cargo` and `queue` empty
---@param shipID any The ship to ask about.
---@return TradeShipData shipdata
function GetTradeShipData(shipID) end


--- Returns the player ships available for trade orders, each entry in the same shape
--- `GetTradeShipData` returns for a single ship. The map takes the list and filters it down
--- itself: it drops any ship with a commander other than the player-occupied ship, anything
--- deployable, anything with no transport unit macros, and optionally the player's own ship and
--- ships already running an order loop.
---
--- Only `shipid` is confirmed - it is the one field the single vanilla call site reads, and it
--- feeds `GetCommander`, `GetComponentData` and `ConvertIDTo64Bit`. The rest of the entry is
--- what the community reference describes.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:30308
---@return TradeShipData[] ships
function GetTradeShipList() end


--- Returns the current traffic density - the value `SetTrafficDensityOption` writes. No vanilla
--- code calls either half, and unlike the character-density pair this setting has no MD property
--- and no script reader at all.
---
--- Reads the persisted setting, not save state: it matches `<trafficdensity>` in `config.xml` and
--- survives a reload. Returns the stored 32-bit float widened to a Lua number, so a value that is
--- not exactly representable comes back approximate - `0.8` reads as `0.80000001192093`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - the read-back witness for SetTrafficDensityOption across four values, on
-- both versions
---@return number density Traffic density. 0 to 1 by convention; the setter does not clamp.
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


--- Reads named properties off a ware, in the same variadic form as `GetComponentData`: every
--- argument after the ware id is a property name, and one value comes back per name, in order.
--- Vanilla calls it more often than almost anything else in the file, usually for `name` alone
--- but frequently for a handful at once.
---
--- The 67 keys 9.00 vanilla passes, most used first:
---
--- `name`, `component`, `avgprice`, `islimited`, `transport`, `volume`, `ismissiononly`,
--- `resources`, `ispaintmod`, `maxprice`, `ispersonalupgrade`, `isprimarymodpart`, `minprice`,
--- `researchprecursors`, `tradelicence`, `volatile`, `buyprice`, `description`, `isunbundleammo`,
--- `sortorder`, `allowdrop`, `hasblueprint`, `iscraftingresource`, `isequipment`,
--- `ishiddenwithoutlicence`, `ismodpart`, `isbraneitem`, `video`, `blueprintsowners`,
--- `iscrafting`, `isdeprecated`, `isoperationvolatile`, `isplayerblueprintallowed`,
--- `isseasonvolatile`, `nocustomgamestart`, `productionresearchprecursors`, `products`,
--- `researchtime`, `tradeonly`, `hasproductionmethod`, `icon`, `inventory`, `iscraftable`,
--- `isprocessed`, `issinglecraft`, `isunreadinventory`, `isventureuploadallowed`, `modclass`,
--- `modquality`, `playerillegal`, `productionmethod`, `shortname`, `factoryname`, `image`,
--- `isblueprintsaleonly`, `iscargo`, `isexplorationchart`, `isminable`, `ismodule`, `isship`,
--- `istransmutable`, `miningmapcolor`, `productionamount`, `productionmethods`, `productiontime`,
--- `storagename`, `tags`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 338 vanilla call sites, 2-8 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_crafting.lua:102, ui/addons/ego_detailmonitor/menu_crafting.lua:238
---@param wareID string The ID of the ware.
---@param ... string One or more property names.
---@return ... any One value per name, in the order asked.
function GetWareData(wareID, ...) end


--- Returns the trades available for a ware exchange between two containers, as a list of trade
--- offers in the same shape `GetTradeData` returns for a single trade. It takes the **ship**
--- and the **other container** - `menu_map.lua:21362` passes exactly that pair.
---
--- `SetVirtualCargoMode` has to have been called on both containers first, or the result comes
--- back empty, which is the reason a correct-looking call can return nothing. No vanilla call
--- site passes a third argument.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:21362
---@param tradingShipID any The ship doing the exchange.
---@param tradedContainerID any The container it is exchanging with.
---@param sortby? any Sort order. Documented; no vanilla call site passes one.
---@return TradeData[] tradeList
function GetWareExchangeTradeList(tradingShipID, tradedContainerID, sortby) end


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


--- Reports whether a **space** - a cluster, sector or zone - contains a shipyard. No vanilla
--- code calls it; the menus ask `GetComponentData(id, "isshipyard")` of an object instead,
--- which answers several such questions at once.
---
--- **It never returns `false`.** A space with a shipyard returns `true`; one without returns
--- *nothing at all*, which reaches the caller as `nil`. `if HasShipyard(s) then` is therefore
--- correct, while anything that counts return values or compares against `false` is not.
---
--- A bare `HasShipyard()` returns `true`, because the missing argument resolves to the whole
--- universe, which does contain shipyards. That is not an error and not an answer about
--- anything the caller has in hand.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 51 calls, the true and the silent case each matched against the map across
-- thirteen sectors; two 9.00 sectors, one silent with no shipyard in its seed data and one `true`
-- with the player's own shipyard in it
---@param spaceID any The cluster, sector or zone to ask about.
---@return boolean? isShipyard `true`, or no value at all when there is none.
function HasShipyard(spaceID) end


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


--- Reports whether a **space** - a cluster, sector or zone - contains a wharf. No vanilla code
--- calls it; the menus ask `GetComponentData(id, "iswharf")` of an object instead, which
--- answers several such questions in one call.
---
--- **It never returns `false`**, exactly as `HasShipyard` does not: a wharf gives `true`, no
--- wharf gives *nothing*, reaching the caller as `nil`. A bare `HasWharf()` returns `true`,
--- the missing argument resolving to the whole universe.
---
--- Unlike its twin, this name is absent from the community LuaLS library altogether, so the
--- space-class argument here is the engine's own, taken from its rejection of everything else.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 51 calls, the true and the silent case each matched against the map across
-- thirteen sectors; two 9.00 sectors, both `true`, one for `wharf_alliance_toa` in its seed data
-- and one for the player's own wharf
---@param spaceID any The cluster, sector or zone to ask about.
---@return boolean? hasWharf `true`, or no value at all when there is none.
function HasWharf(spaceID) end


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
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
function HideAllCircles() end


--- Hides every rectangle drawn with `DrawRect`. No vanilla code calls it - the menus clear all
--- shape kinds at once with `HideAllShapes`.
-- Source: ui\widget\lua\widget_fullscreen.lua
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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


--- Adds to a statistic. **`addvalue` is optional and defaults to 1**: measured, the
--- two-argument call moved the statistic by exactly the value given, and the one-argument
--- call moved it by 1 with no engine complaint. The engine reports this one as
--- `expected >= 1`, unlike `SetStatValue`'s hard `expected 2`.
---
--- No vanilla Lua calls it - the shipped menus only read statistics, with `GetAllStatIDs` and
--- `GetStatData` - so it is there for code that has its own counters to keep. Uncalled is not
--- unused: the game writes statistics constantly from MD, where a statistic is a plain lvalue
--- and the equivalent of this call is a `set_value` on `stat.<id>` with `operation="add"`.
---
--- See `SetStatValue` for which statistics are safe to write: some persist to the Steam/GOG
--- account rather than to the savegame.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - +7 and the bare +1 default, both read back and witnessed from MD, on both
-- versions
---@param statID string The ID of the statistic to increment.
---@param addvalue? number The value to add. Defaults to 1.
function IncStatValue(statID, addvalue) end


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
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:13537
---@param appid any -- The AppID of the DLC to install.
function InstallSteamDLC(appid) end


-- Interrupts the player's computer control, likely to regain control for the UI.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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


--- Reports whether a container's operational range covers the given space. No vanilla code
--- calls it.
---
--- **Both arguments are required.** The one-argument call this row used to declare is answered
--- with `Invalid number of arguments (1, expected 2)` - there is no default space.
---
--- Argument 2 is a space of any granularity: **cluster, sector and zone are all accepted**, and on
--- every target tried the three agree with one another. So **the answer follows the container, not
--- the space it is asked about**. Every station measured answers `false` - a headquarters, a
--- shipyard, a wharf and a factory - while four of five ships answer `true` and a carrier answers
--- `false`, so it is not a class test either. What makes a range "sufficient" is still not
--- measured, so the condition behind the boolean remains the name's own claim.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - four call shapes on a player HQ: bare, and against its zone, sector and
-- cluster; the same four on each of nine 9.00 targets, where the bare call is refused as
-- "(1, expected 2)" and the other three always agree with one another, so the space argument does
-- not move the answer. Those runs are also the first to see it return `true`: four ships true,
-- one ship and all four stations false
---@param containerID any The container to ask about.
---@param spaceID any The space to test the range against: a cluster, sector or zone.
---@return boolean isSufficient True if the range is sufficient.
function IsContainerOperationalRangeSufficient(containerID, spaceID) end


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


--- Reports whether something blocks the line of sight to a target element, identified by its
--- position id - a real ray-cast, which is why the core target system stores the answer and
--- reuses it for the rest of the frame.
---
--- With `obstructedByOwnComponent` true, the element can also be obstructed by geometry on its
--- own component - a target point on a capital ship blocked by that ship's own hull, say. The
--- third argument governs the player's cockpit geometry: when it is true the cockpit never
--- counts as an obstruction, which is the pre-4.20 behaviour and remains the default.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:3946
---@param position any The position id of the target element to check.
---@param obstructedByOwnComponent? boolean Let the element's own component obstruct it.
---@param ignoreCockpitObstruction? boolean Do not treat the player cockpit as an obstruction. Defaults to true.
---@return boolean isObstructed True if the position is obstructed.
function IsObstructed(position, obstructedByOwnComponent, ignoreCockpitObstruction) end


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
-- Probed: 8.00, 9.00 - false on the GOG build and true on the Steam build, the same rung on both stores
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


--- Moves a component to the top of an entity's repair queue. **Both arguments are components**:
--- argument 1 is the entity holding the queue - the engine answers anything else with
--- `is not of class entity` - and argument 2 is the component to promote.
---
--- There is no priority number. This row declared one, and nothing had ever passed one: the
--- call `MakeRepairPriority(entity, 5)` is answered with `Component 5 does not exist any more`,
--- the engine reading 5 as a component ID. So the name sets a position in a queue by naming a
--- component, not a rank.
---
--- The effect has never been witnessed. The call returns nothing, raises nothing on a valid
--- pair, and Lua has no reader for a repair queue, so whether it did anything is not something
--- a mod can check from here.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - argument 2 typed by the engine's own rejection of a number, repeated on
-- 9.00 against a station's defence computer and a ship's pilot
---@param entityID any The entity whose repair queue is reordered.
---@param componentID any The component to move to the top of that queue.
function MakeRepairPriority(entityID, componentID) end


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
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
function onUpdate() end


--- Opens a menu by name, with up to two parameters - `"TopLevelMenu"`, `"DockedMenu"`,
--- `"MapMenu"`. The second parameter is the menu's own argument list, whose shape each menu
--- defines: the map takes `{ x, y, ... }` and can be handed a whole submenu request in it. This
--- is the call that opens a vanilla menu from anywhere, including from a mod.
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
-- Probed: 8.00, 9.00 - bare on both stores: the game's own store page in the overlay on Steam, nothing at all on GOG
---@param appID? number The Steam AppID of the page to open.
function OpenSteamOverlayStorePage(appID) end


--- Opens a web page in the Steam overlay. No vanilla code calls it; `OpenSteamOverlayStorePage`
--- is the one the UI uses, and both are only safe behind `IsSteamworksEnabled`.
---
--- **It works, and only on a Steam build.** The same eleven rungs ran on the GOG 8.00 build and
--- the Steam 9.00 one. On Steam (`IsSteamworksEnabled()` true, `C.IsGOGVersion()` false) the real
--- call opened the overlay browser on the URL over the running game; on GOG (`IsSteamworksEnabled()`
--- false, `C.IsGOGVersion()` true) the identical call did nothing, silently, and returned normally -
--- and `C.CanOpenWebBrowser()` was true there, so the GOG fallback is vanilla's own
--- `C.OpenWebBrowser` branch and not something this name falls back to. Nothing distinguishes the
--- two runs in the log: the guard is the caller's job.
---
--- **Argument checking runs before the Steam gate**, word for word the same on both builds. Arity is
--- exactly 1 - `Invalid number of arguments (0, expected 1)` bare and `(2, expected 1)` with a second
--- argument - and slot 1 is strictly a string: a table and a boolean are refused with
--- `Invalid argument #1 <url> (got table, expected string)`, the engine's own parameter name, while a
--- number is taken by the usual Lua coercion with no complaint. No return, on every rung.
---
--- **The URL itself is never validated.** `""` and `"not a url at all"` passed the argument check in
--- silence on both builds and opened no page on Steam, so a bad string is indistinguishable from a
--- refused one except by what appears on screen.
---
--- The overlay is one window: the control `OpenSteamOverlayStorePage()` and this call, fired seconds
--- apart, landed as two tabs in call order rather than two windows.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - eleven rungs on each store, three environment readings first and the real URL last, with OpenSteamOverlayStorePage as the control
---@param url string The URL to open. Not validated: a number is coerced, an empty or non-URL string is accepted and opens nothing.
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


--- Loads a render target texture so it is ready before anything draws into it, and returns
--- whether that succeeded. The monitor code prepares both radar targets up front, so switching
--- radar integration mode mid-flight cannot stall.
---
--- Documented as **unsupported** and not designed to be used by mods.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 5 vanilla call sites, 1 argument
-- Seen at: ui/core/lua/monitors.lua:796, ui/widget/lua/widget_fullscreen.lua:8777
---@param renderTargetName string The name of the render target texture.
---@return boolean success
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


-- Quits the game, closing all related processes and returning to the desktop.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 2 vanilla call sites, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8125, ui/addons/ego_gameoptions/onlineupdate.lua:96
function QuitGame() end


-- Quits the current module or menu, returning to the previous state or the desktop.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 0 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:8127
function QuitModule() end


--- Fires the MD event `event_player_interaction` for a live interaction id from
--- `CreateInteractionDescriptor2`. The cue receives the **interaction name in `param`**, the
--- descriptor's payload in **`param2`** and a **null `event.object`** - so an MD handler matches
--- it the way `md/conversations.xml:1789-1830` does, `<event_player_interaction param="'my
--- interaction'"/>`. (Interactions raised from MD's own `show_notification` fill the two slots
--- the other way round, the name in `param2`; both shapes exist in vanilla.)
---
--- **Synchronous**, measured: the cue has run before this call returns, unlike
--- `AddUITriggeredEvent`, whose cue runs after the Lua handler ends.
---
--- It needs nothing but a live id. Vanilla only raises one that is currently on the target
--- monitor, but `TargetMonitorInteractionShown2` is **not** a precondition - a descriptor that was
--- never shown raises exactly the same event. A **freed** id does not: the engine answers `Error
--- raising the interaction event. Errormessage: Cannot find notification with ID 'N'` and no cue
--- runs. A legacy `CreateInteractionDescriptor` userdata is refused outright.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:1221
---@param interactionID integer An id from CreateInteractionDescriptor2, not yet released.
function RaisePlayerInteractionEvent(interactionID) end


--- Returns the Lua the player has typed into the debug input, or nothing when there is none.
--- `ego_debug` polls it from its own `onUpdate` and `loadstring`s whatever comes back - which
--- is why it only works when `IsLuaDebugInputEnabled` is true.
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
---
--- **It never fails and never complains.** Missing text returns the placeholder
--- `"=ReadText<page>-<line>="` with no log line, so a mod cannot detect a missing entry from this
--- call except by matching that string. `ExistsText` is the correct pre-check, and `ReadTextTest`
--- is the same read with the engine's `TextDB lookup failed` line added.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 7474 vanilla call sites, 2 arguments
-- Seen at: ui/addons/ego_chatwindow/chatwindow.lua:133, ui/addons/ego_detailmonitor/menu_crafting.lua:263
---@param pageID integer The ID of the text page.
---@param textID integer The ID of the text entry within that page.
---@return string # The text content.
function ReadText(pageID, textID) end


--- **`ReadText` that complains.** It returns exactly what `ReadText(pageID, textID)` returns -
--- the same text on a hit, and the same `"=ReadText<page>-<line>="` placeholder when the page or
--- the entry is missing - but on a miss it also writes `TextDB lookup failed for (page, line)` to
--- the game log, which `ReadText` never does. That log line is the whole difference between the
--- two, and it makes this the read to use while developing a mod: a missing `t/` entry shows up
--- in the Debug Log instead of as a placeholder in the UI.
---
--- **`fallbacktext` is required and never reaches the return.** Measured over five values on both
--- the hit and the miss path - a sentinel string, the entry's own text, a number and an empty
--- string - and the result was the text on a hit and the placeholder on a miss every time. The
--- parameter is named for a behaviour the 8.00 return path does not have. Omitting it is refused
--- outright: `Invalid number of arguments (2, expected 3)`, a hard requirement rather than an
--- open minimum.
---
--- **Slot 3 is strictly a string.** A number is accepted by the usual Lua coercion and the call
--- proceeds normally; a table and a boolean - both `true` and `false` - are refused with
--- `Invalid argument #3 <fallbacktext> (got table, expected string)`, the engine's own parameter
--- name, and the call then returns nothing at all. So it is not a flag: there is no boolean to
--- pass, and an empty fallback does not force the placeholder on a hit either.
---
--- Not to be confused with `C.GetLocalizedText(pageid, textid, defaultvalue)`, the three-argument
--- C-side read whose third argument **is** returned when the lookup fails, and which every
--- vanilla caller hands a plain fallback literal (`widget_fullscreen.lua:907-918`).
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - thirteen calls over two runs: a known-good pair, both kinds of miss, five
-- fallback values and four type refusals, with ReadText on the same pairs as the contrast; all
-- fourteen rungs answered the same either side
---@param pageID integer The ID of the text page.
---@param textID integer The ID of the text entry within that page.
---@param fallbacktext string Required, and never returned in 8.00. A number is coerced; a table or a boolean is refused.
---@return string # The text, or `"=ReadText<page>-<line>="` when it is missing. Nothing at all if the call is refused.
function ReadTextTest(pageID, textID, fallbacktext) end


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


--- Frees a **legacy** interaction descriptor - the counterpart of `CreateInteractionDescriptor`,
--- and it takes that function's **userdata**, measured. It is not the release for the current
--- API: handed the integer id from `CreateInteractionDescriptor2` it answers `invalid parameters`
--- and frees nothing, which the raise afterwards proves by still working.
---
--- **The current id is freed through the C function of the same name**, `void
--- ReleaseInteractionDescriptor(int32_t id)`, which `ui/core/lua/monitors.lua:103` cdefs and
--- `monitors.lua:1766` calls. That cdef is **core's, and is not visible in the addon Lua state** -
--- `C.ReleaseInteractionDescriptor` there answers `missing declaration for symbol`. An addon that
--- creates descriptors must declare the symbol itself; `ffi.cdef` accepts it, and the release then
--- works, after which a raise on that id reports `Cannot find notification with ID 'N'`.
--- Without that declaration an addon can create and raise interactions but **cannot free one**.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - accepts a legacy userdata descriptor, refuses an integer id with
-- `invalid parameters`, on both versions
---@param descriptor userdata A descriptor from CreateInteractionDescriptor.
function ReleaseInteractionDescriptor(descriptor) end


--- No vanilla code calls this, so nothing here confirms what it releases or what it takes. Its
--- neighbours in the `Release*` family each free a descriptor the engine handed out, and the
--- declaration carries no parameters.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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


--- Releases a softtarget lock taken with `RequestSofttargetLock`. `requester` has to be the
--- same name that took the lock.
---
--- The return value says only whether that requester's own request was found and removed. It
--- does **not** mean the target lock has been lifted: other requesters may still hold locks of
--- their own, and the softtarget stays fixed until the last of them is gone.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:2377
---@param requester string The name that took the lock.
---@return boolean requesterRemoved Whether this requester's request was found, not whether the lock was lifted.
function RemoveSofttargetLockRequest(requester) end


--- Repairs each destructible named as an argument, **to full hull, synchronously, in one call**.
--- Variadic: three arguments are accepted without complaint, so the engine's `expected >= 1` is a
--- real tail here and not a trailing parameter with a default. Returns nothing.
---
--- A "destructible" is `scriptproperties.xml`'s parent class, so the vocabulary spans whole
--- objects and their surface elements alike. Both are measured: a ship, an engine and a shield
--- generator were each repaired by being named.
---
--- **It repairs exactly what is named and nothing else.** Passing a ship repairs the ship's hull
--- and leaves every one of its surface elements untouched, so the plural in the name is about the
--- argument list, not about what one object contains. Proved with a negative control: of three
--- identically damaged engines, the two named went to full and the third did not move, then moved
--- when it was named in the next call.
---
--- **A wreck is refused silently.** A destroyed element is still present - its slot answers its id
--- and its name is unchanged - but `GetComponentClass` degrades it from `turret` /
--- `shieldgenerator` / `engine` to plain `destructible`, with `hull` 0 of 0 and `isfunctional`
--- false, and MD reports `isrepairable` false. Naming one changes nothing and raises nothing.
--- Restoring a wreck is `<restore_object>`'s job in MD, a different operation.
---
--- Each repair raises MD's `event_object_hull_repaired` **twice: once on the component and once on
--- its parent object**, with `event.param` naming the repaired component in both, so a listener
--- attached to a ship hears about its own surface elements. The event's undocumented payload,
--- measured here and read by no vanilla script: `param2` is the repaired component's full hull
--- (6027 for an engine, 500 for a shield, 35000 for the ship) and **`param3` is the hull delta**.
--- `<set_object_hull>` raising a hull from MD does **not** raise this event - it is specific to a
--- repair.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - hull and class read back per component, with an MD group listener; that
-- arguments 2 onwards are acted on is a 9.00 reading, taken against the one-argument call as its
-- own control in the same run
---@param destructible any A destructible: an object, or one of its surface elements.
---@param ... any Further destructibles. Each is repaired independently.
function RepairDestructibles(destructible, ...) end


--- Asks for the softtarget to be held fixed, preventing the current target from changing, and
--- returns whether the lock was granted. `requester` names the holder - the core target system
--- passes `"softtargetManager"` - and the same name has to be handed to
--- `RemoveSofttargetLockRequest` to let it go again.
---
--- Calling it with no current softtarget **fails** and reports so in its return value. Before
--- 4.20 that same call was the way to prevent anything being targeted at all; that no longer
--- works, so the return value has to be checked rather than assumed.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/targetsystem.lua:2367
---@param requester string The name holding the lock.
---@return boolean success
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
--- keeps apart: actions (a press), states (held down) and ranges (an axis), each in the shape its
--- own getter returns - keyed by integer id, holding a list of source, code and signum triples.
---
--- It takes all three every time; vanilla never saves one map alone, and calls it after every
--- individual rebind rather than batching changes up.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 8 vanilla call sites, 3 arguments
-- Seen at: ui/addons/ego_gameoptions/gameoptions.lua:3143
---@param actions table<integer, InputBinding[]> As returned by `GetInputActionMap`.
---@param states table<integer, InputBinding[]> As returned by `GetInputStateMap`.
---@param ranges table<integer, InputBinding[]> As returned by `GetInputRangeMap`.
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


--- No vanilla code calls this, so nothing here confirms what it does. By its name it picks the
--- back option of the dialog `SelectDialogOption` selects a button in.
---
--- A bare call is accepted and **returns `false`**, with no engine line to say why - so unlike
--- its neighbours it answers rather than acting silently, but whether `false` means "no dialog
--- is open" or something else is unmeasured. No argument is required.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions with no dialog open: `false` and no engine
-- line either side. No argument is required; what the boolean reports is unmeasured.
---@return boolean selected `false` in every call measured, with no dialog open.
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


--- Sets the density of characters on station platforms, and returns nothing. Vanilla MD reads
--- the same setting as `player.chardensity`, which `scriptproperties.xml` documents as a float
--- *"between 0 and 1"* - but **that range is the game's own, not a constraint the setter
--- enforces**: `1.5` is taken and stored unchanged. Values above 1 push vanilla past its own
--- ceiling, since `md/npc_instantiation.xml:1695` computes `30 * player.chardensity`.
---
--- The value is **not save state**. It persists to `config.xml` as `<chardensity>`, written
--- through as soon as the setter is called, so it outlives the save and the session.
---
--- Uncalled is not unused: no Lua code calls this setter in any version from 7.10 to 9.00, but
--- `scriptproperties.xml` and `md/npc_instantiation.xml` have read the setting in all five. The
--- game has no UI for it either, which makes this the only programmatic way to change it.
---
--- Stored as a 32-bit float: `0.8` reads back as `0.80000001192093`, while an exactly
--- representable `1.5` or `0.5` reads back unchanged. Never compare a read-back for equality.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 0.5 -> 0.8 -> 1.5 -> 0.5, each value read back through
-- GetCharacterDensityOption, confirmed in config.xml between steps, and read back a third
-- time from MD as player.chardensity - which reported 1.5 unclamped on the script side
---@param density number Characters on platforms. 0 to 1 by convention; not clamped.
function SetCharacterDensityOption(density) end


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
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
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


--- Sets a mission target message on a position marker. **This name is an alias and the engine
--- answers under its own**: called bare it replies
--- `SetPriorityMissionTargetMessage(): invalid argument. Proper syntax:
--- SetPriorityMissionTargetMessage(posid, messageid)`, naming the real internal function and
--- its full signature in one line. The two parameters below are the engine's own words; no
--- call has ever been made with arguments, so neither type has been measured.
---
--- **Egosoft marks it UNSUPPORTED.** Both names carry `UNSUPPORTED. Not designed to be used by
--- mods.` in Egosoft's X Rebirth Lua function overview, which is why this row is documented
--- rather than measured - parked on Egosoft's own word, not for want of a way to call it.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: unverified - no vanilla call site
-- Probed: 8.00, 9.00 - one bare call on each version, both printing the same real name and
-- syntax, `SetPriorityMissionTargetMessage(posid, messageid)`; parked there
---@param posid any Position id. Named by the engine, type unmeasured.
---@param messageid any Message id. Named by the engine, type unmeasured.
function SetMainMissiontargetMessage(posid, messageid) end


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


--- Sets the menu position. No vanilla code calls it.
---
--- **It does take arguments, and the declaration does not name them.** A bare call is not
--- refused on arity - there is no `expected N` line - but it returns `false` and the engine
--- writes `(from presentation '...') SetMenuPosition(): invalid parameters`, so the check is the
--- presentation's rather than the engine's argument counter. What it wants is unmeasured; the
--- `false` is the refusal, not a position.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: `false` and the same `invalid parameters`
-- line either side. The parameters it wants are unmeasured.
---@return boolean positioned `false` when the parameters are rejected.
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
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
function SetMouseSleeping() end


--- Writes one value onto an NPC's blackboard, where Mission Director code can read it. The key
--- is the MD variable name including its `$` - the trader inventory menu sets `$TradeDone` to
--- true when a trade completes.
---
--- **A Lua `true` crosses as MD integer `1`**, measured: written here, it reads back through
--- `GetNPCBlackboard` as `number 1` and MD's own `typeof` calls it `integer`, not `bool`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_trader_inventory.lua:538
-- Probed: 8.00, 9.00 - a station and a ship defence entity, read back in Lua and in MD, on both
-- versions
---@param entity userdata The NPC entity to set the blackboard for.
---@param key string The key of the value to set. The MD variable name, `$` included.
---@param value any The value to set. A `true` arrives in MD as integer 1; `false` was not measured.
function SetNPCBlackboard(entity, key, value) end


--- Sets one skill of one NPC. Arity 3, returns nothing. MD's `<set_skill entity= type= exact= />`
--- (`common.xsd:35803`) is the same operation from the script side, and no vanilla Lua calls this.
---
--- Argument 1 is an **entity** - an NPC component id such as a ship's `assignedpilot`, not the
--- ship and not a seed-based crew member. The engine names the type itself, answering
--- `Component '<name>' is not of class entity` to a controllable and
--- `Invalid argument #1 <entity> (got cdata, expected component ID)` to the player person.
--- Both complaints print while the call still returns normally.
---
--- **Argument 2 is the bare skill id**, one of `boarding`, `engineering`, `management`, `morale`
--- or `piloting` - `C.GetSkills` enumerates them and they match MD's `skilltype` enum exactly.
--- MD's own `skilltype.` prefix is **not** accepted. Unlike most of this family, a wrong skill -
--- a name that does not exist, the prefixed spelling, or an integer - **fails silently**: nothing
--- moves and the engine prints nothing, so this call cannot be probed by feeding it nonsense.
---
--- **Argument 3 is on the 0-15 skill scale, not the 0-100 combined one**, and is **clamped at
--- both ends rather than refused**: 75 and 100 each wrote 15, a negative wrote 0, and a fraction
--- truncates. An out-of-range call leaves the skill usable - the next in-range value takes.
---
--- The write reaches the real store: `C.GetEntitySkillsForAssignment`, `C.GetEntityCombinedSkill`
--- and MD's `skill.{$skilltype}` all track it.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - a ship's pilot, every skill read back either side of every call, MD as a
-- second witness; the 0-15 scale, the truncated fraction and the clamp reproduced on both versions
---@param entityID any The NPC entity whose skill is written. Not a controllable, not a seed person.
---@param skill string One of boarding, engineering, management, morale, piloting. A wrong id is silently ignored.
---@param value number The new value on the 0-15 scale. Clamped to 0-15; a fraction is truncated.
function SetNPCSkill(entityID, skill, value) end


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


--- Sets a statistic to an exact value. Arity 2: a statistic ID from `GetAllStatIDs` and a
--- number. Returns nothing, and the write is immediate - `GetStatData(id, "value")` reads the
--- new value back in the same frame. It is a true assignment, not a maximum: a measured call
--- took a statistic from 4250 back down to 480. Note that the statistics marked
--- `highest="true"` in `libraries/stats.xml` keep only their highest value, so a set on one
--- of those is expected to be one-way.
---
--- No vanilla Lua calls it, nor `IncStatValue`, but uncalled is not unused: the shipped game
--- writes statistics constantly from MD, where a statistic is a plain lvalue and the
--- equivalent is `set_value` on `stat.<id>`. Measured from both sides - after a Lua
--- `SetStatValue`, MD reads the new value in `stat.<id>`, so the two are one store.
---
--- **Some statistics are not save state.** `libraries/stats.xml` marks 21 of them
--- `account="true"`, meaning they persist to the Steam/GOG account across savegames, every
--- achievement in the game hangs off one of those, and `copyto`/`addto`/`mapto` propagate a
--- write from a plain statistic into them. Reloading a save does not undo such a write.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - set and read back exactly, and witnessed from MD as stat.<id>, on both
-- versions
---@param statID string The ID of the statistic to set.
---@param value number The value to set it to.
function SetStatValue(statID, value) end


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


--- Sets the traffic density, and returns nothing. Measured to behave identically to
--- `SetCharacterDensityOption` in every respect - same arity, same float storage, same
--- write-through to `config.xml` as `<trafficdensity>`, and the same absence of clamping,
--- `1.5` being taken unchanged.
---
--- Unlike its twin it has **no MD property and no script reader anywhere**, so a set is
--- unobservable from MD: it is absent from `scriptproperties.xml`, and `md/`, `aiscripts/`
--- and `libraries/` never mention `trafficdensity`. So the traffic it governs is spawned
--- engine-side, nothing in the game's own scripts consumes the value, and the 0-to-1
--- convention is inherited from the twin rather than documented for this name.
---
--- The value is **not save state**; it persists to `config.xml` and outlives the session.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - 0.5 -> 0.8 -> 1.5 -> 0.5 alongside SetCharacterDensityOption, read back
-- through GetTrafficDensityOption and confirmed in config.xml between steps
---@param density number Traffic density. 0 to 1 by convention; not clamped.
function SetTrafficDensityOption(density) end


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


--- Flies **the player's own ship** to the given object under autopilot. The argument is the
--- **destination**, not the ship: `GetAutoPilotTarget` reads the component straight back out
--- after the call, and the game writes `Autopilot engaged` followed by the order it issued for
--- the ship the player is piloting. **The order depends on what the destination is**: a station
--- gives `Command: Fly to <object>`, a ship gives `Command: Follow <ship>`. A route through gates
--- is planned as needed, and the screen reports `Flying to Jump Gate` while it runs - the targets
--- measured were 34,627km and 122,094km away, both in another sector. Returns nothing.
---
--- **The player has to be piloting a ship.** Called from the bridge with no ship under the
--- player, it is accepted silently and nothing happens: no autopilot, no error, and
--- `GetAutoPilotTarget` still reads `nil`.
---
--- `StopAutoPilot` cancels it, after which `GetAutoPilotTarget` reads `nil` again. No vanilla
--- code calls either one; the menus drive the autopilot through the player activity instead.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - read back through GetAutoPilotTarget, before, after and after
-- StopAutoPilot. On 9.00 the engaged autopilot was also left standing between two clicks rather
-- than cancelled in the same frame, which is the only way the order and the route are visible at
-- all: the read-back alone cannot see them
---@param targetID any The object to fly to.
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


--- Stops the autopilot started by `StartAutoPilot`, after which `GetAutoPilotTarget` reads
--- `nil` and the game writes `Autopilot disengaged`. Takes nothing, returns nothing, and is
--- harmless when the autopilot is already off. No vanilla code calls it, and neither is
--- `StartAutoPilot` called; the menus stop it through the player activity instead, with
--- `C.StopPlayerActivity`.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - read back through GetAutoPilotTarget; on 9.00 also against an autopilot
-- that had been running for a while rather than one started in the same frame, and it cancelled
-- that one the same way
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
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
function TargetMonitorInteractionHidden() end


--- Takes the interaction off the target monitor. Argument 1 is the **integer id** from
--- `CreateInteractionDescriptor2`; a legacy `CreateInteractionDescriptor` userdata is refused with
--- `invalid parameters`. Vanilla pairs it with `TargetMonitorInteractionShown2` and then releases
--- the descriptor (`monitors.lua:1770-1772`). Hiding is **not** a precondition for anything: an
--- interaction that was never shown still raises its event.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 1 argument
-- Seen at: ui/core/lua/monitors.lua:1770
---@param interactionID integer The id of the interaction to hide.
function TargetMonitorInteractionHidden2(interactionID) end


--- Tells the game that the target monitor's interaction is up. No vanilla code calls it, nor
--- its counterpart `TargetMonitorInteractionHidden`.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - in-game probe, no vanilla call site
-- Probed: 8.00, 9.00 - called bare on both versions: accepted with no arity complaint and
-- nothing returned, so no argument is required. Whether it takes an optional one is unmeasured.
function TargetMonitorInteractionShown() end


--- Tells the game that a target monitor interaction is on screen, with its ID, its text and
--- whether it is a notification - the version the monitor code actually calls, unlike the
--- argument-less `TargetMonitorInteractionShown`. Argument 1 is the **integer id** from
--- `CreateInteractionDescriptor2`; a legacy userdata descriptor is refused with `invalid
--- parameters`. Calling it is **not** what makes an interaction raisable -
--- `RaisePlayerInteractionEvent` works on a descriptor that was never shown.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/monitors.lua:2770
---@param interactionID integer The id from CreateInteractionDescriptor2.
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


---@meta
---@class UnitStorageEntry
---@field macro string The unit macro name.
---@field name string The unit's displayed name.
---@field amount number How many are stored.
---@field unavailable number How many of those are unavailable.

---@meta
---@class UnitStorageData
---@field [integer] UnitStorageEntry One entry per unit macro.
---@field capacity number Total unit capacity.
---@field stored number Total units stored.
---@field categorystored? number Units stored of the requested category, where one was given.

--- Returns the units stored on a defensible, optionally filtered to one unit category. The
--- units themselves sit in the array part, with the totals as named fields alongside them, so
--- walk it with `ipairs` and read `capacity` and `stored` off the table itself.
---
--- `virtualammo` only means anything after `SetVirtualCargoMode` has been called. Neither it
--- nor `excluderestricted` is passed by any vanilla call site, which never uses more than two
--- arguments, so neither is confirmed.
-- Environment: addons only
-- Versions: 8.00, 9.00
-- Usage: confirmed - 13 vanilla call sites, 1-2 arguments
-- Seen at: ui/addons/ego_detailmonitor/menu_map.lua:16180, ui/addons/ego_detailmonitor/menu_map.lua:22295
---@param objectID any The defensible to query.
---@param unitType? string Unit category filter, e.g. `"transport"`.
---@param virtualammo? boolean Include virtual ammo; requires `SetVirtualCargoMode` first.
---@param excluderestricted? boolean Leave restricted units out.
---@return UnitStorageData data
function GetUnitStorageData(objectID, unitType, virtualammo, excluderestricted) end


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
--- screen. Only applicable outside worldspace mode. The two sizes are the space to reserve
--- around the element, which is what makes the on-screen test account for its extent rather
--- than a bare point. `GetUIElementRectangleScreenPosition` is the version that returns a
--- rectangle.
---
--- x and y run from `-viewWidth/2` to `+viewWidth/2` and `-viewHeight/2` to `+viewHeight/2`,
--- with 0/0 at the centre of the screen and the negative corner at the lower left - not the
--- top-left origin the rest of the widget system uses. z is the position between the clipping
--- planes, from 0 to 1.
-- Environment: addons + core
-- Versions: 8.00, 9.00
-- Usage: confirmed - 1 vanilla call site, 3 arguments
-- Seen at: ui/core/lua/targetsystem.lua:3643
---@param posID any The element position ID.
---@param sizeX number Reservation width, used for the on-screen test.
---@param sizeY number Reservation height, used for the on-screen test.
---@return number x
---@return number y
---@return number z
---@return boolean onScreen
function GetUIElementScreenPosition(posID, sizeX, sizeY) end


--- Projects a UI element position onto the screen as a **rectangle**: x, y, z, whether it is on
--- screen, and the rectangle's width and height. Only applicable outside worldspace mode. The
--- minimum size and maximum scale bound how large it may be drawn, and the core target system
--- asks for the rectangle first, because whether a target is off screen depends on the extent
--- rather than the centre point.
---
--- The width and height are always a multiple of 2. x, y and z carry the same meaning as in
--- `GetUIElementScreenPosition`: x and y measured from the centre of the screen, negative
--- towards the lower left, and z between the clipping planes from 0 to 1.
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

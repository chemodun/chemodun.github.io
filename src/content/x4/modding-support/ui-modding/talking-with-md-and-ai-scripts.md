---
title: Talking with MD and AI scripts
description: The channels between UI Lua and the XML side - raise_lua_event, AddUITriggeredEvent, SignalObject and the blackboard - with a working pair of files for each.
order: 4
wikiPath: Modding Support/UI Modding support/Talking with MD and AI scripts
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Talking with MD and AI scripts

An extension's UI code is Lua - a file registered through `ui.xml` into the menus environment. Its game logic is XML: Mission Director cues and AI scripts. Sooner or later one needs something from the other, and the way across is not obvious from either side on its own.

Three channels, each of them working in both directions:

- **events** - a doorbell: wakes the other side, carries almost nothing
- **the blackboard** - a mailbox: script variables held on an entity; carries anything, wakes nobody
- **object signals** - a doorbell aimed at one object, so whatever AI script is running on it hears it too

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## The channels

| Direction | You call | It arrives at | What it can carry |
| --- | --- | --- | --- |
| Scripts → Lua | `<raise_lua_event>` | the function you handed to `RegisterEvent` | one string, number or component |
| Lua → scripts | `AddUITriggeredEvent` | `<event_ui_triggered>` | a screen name, a control name, one extra value |
| Lua → any object | `SignalObject` | `<event_object_signalled>` | the object plus up to three params, and a param may be a whole table |
| Scripts → any object | `<signal_objects>` | `<event_object_signalled>` | the same |
| either side, no wake-up | `GetNPCBlackboard` / `SetNPCBlackboard` | `$variables` on an entity | anything - tables, lists, components, even cue references |

The two doorbells cannot carry structure. The mailbox carries anything but nobody notices when it changes. So the pattern almost every mod with both sides ends up on uses both at once: **park the payload in the mailbox, then ring the doorbell** - in that order, so the value is in place by the time the handler runs.

Every Lua function on this page belongs to the menus environment. The HUD (`ui/core`) has none of them, apart from `AddUITriggeredEvent`, which it got in 9.00.

[↑ Contents](#toc)

## The pieces on disk

Everything below belongs to one fictional extension, `example_bridge`:

```none
extensions/example_bridge/
    content.xml
    ui.xml
    ui/example_bridge.lua
    md/example_bridge.xml
    aiscripts/example.order.with.bridge.listener.xml
```

`ui.xml` is what gets the Lua file loaded into the menus environment:

```xml
<?xml version="1.0" encoding="utf-8"?>
<addon name="example_bridge" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="../../ui/core/addon.xsd">
  <environment type="menus">
    <file name="ui/example_bridge.lua" />
  </environment>
</addon>
```

The MD script and the AI script need no registration - the game picks up anything in `md/` and `aiscripts/`.

[↑ Contents](#toc)

## Doorbell one: scripts wake Lua

`md/example_bridge.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Bridge" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <cues>

    <cue name="Greet_Lua" instantiate="true">
      <conditions>
        <check_any>
          <event_game_loaded />
          <event_game_started />
        </check_any>
      </conditions>
      <actions>
        <raise_lua_event name="'ExampleBridge.Greeting'" param="player.name" />
      </actions>
    </cue>

  </cues>
</mdscript>
```

`ui/example_bridge.lua`:

```lua
local function onGreeting(_, param)
  DebugError("ExampleBridge: MD says the player is " .. tostring(param))
end

RegisterEvent("ExampleBridge.Greeting", onGreeting)
```

Worth knowing about this pair:

- The event name is global across the whole game. Prefix it with your mod's name or you will collide with somebody.
- The handler's **first** argument is not the payload - vanilla discards it with `_` everywhere - and the value you sent is the second.
- `param` is limited by the schema to _a string, number or component_. Not a table, not a list. This single restriction is the reason the blackboard exists as a channel.
- Raising an event nothing listens for just does nothing. There is no error to chase - which is also what makes it comfortable to raise events for a Lua side that may not be installed.
- Undo a registration with `UnregisterEvent`, passing the same function reference, not a copy.
- `<raise_lua_event>` is not MD-only. An AI script raises it exactly the same way, which is how a ship's own order asks the UI for something mid-flight.

[↑ Contents](#toc)

## Doorbell two: Lua wakes the scripts

Lua:

```lua
AddUITriggeredEvent("ExampleBridge", "panel_opened", "trade")
```

MD:

```xml
<cue name="On_Panel_Opened" instantiate="true">
  <conditions>
    <event_ui_triggered screen="'ExampleBridge'" control="'panel_opened'" />
  </conditions>
  <actions>
    <debug_text text="'ExampleBridge: the %s panel was opened'.[event.param3]"
      chance="100" filter="general" />
  </actions>
</cue>
```

The three arguments land as `event.param` (`'ExampleBridge'`), `event.param2` (`'panel_opened'`) and `event.param3` (`'trade'`). The script side exposes `param`, `param2` and `param3`, so one extra value is what fits.

Two more things about this one:

- Vanilla menus fire this constantly, with their own menu name as the screen. Pick a screen name nobody else uses - or deliberately pick a vanilla one, which is a perfectly good way to notice the player opening the map.
- Both attributes are optional. A bare `<event_ui_triggered />` catches every UI event in the game, which is the fastest way to find out what vanilla is already announcing.
- The cue above is MD, but the condition itself is not. The same `<event_ui_triggered />` works in an AI script's `<interrupts>` handler.

[↑ Contents](#toc)

## The mailbox: script variables on an entity

This is the part that is usually explained backwards. `GetNPCBlackboard` is not a separate store the engine keeps for the UI. It is the ordinary script variables held on an entity, seen from Lua. Despite the function name nothing about it is NPC-specific - any entity carries them, and `player.entity` is simply the one most mods reach for. These two lines touch exactly the same thing:

```xml
<set_value name="player.entity.$ExampleBridgeConfig" exact="..." />
```

```lua
GetNPCBlackboard(playerId, "$ExampleBridgeConfig")
```

A full pair. MD writes a config table and rings:

```xml
<cue name="Write_Config" instantiate="true">
  <conditions>
    <event_game_loaded />
  </conditions>
  <actions>
    <set_value name="player.entity.$ExampleBridgeConfig" exact="table[
      $enabled  = true,
      $maxRange = 40,
      $label    = 'Nearby ships'
    ]" />
    <raise_lua_event name="'ExampleBridge.ConfigChanged'" />
  </actions>
</cue>
```

Lua reads it:

```lua
local ffi = require("ffi")
local C = ffi.C

ffi.cdef [[
  typedef uint64_t UniverseID;
  UniverseID GetPlayerID(void);
]]

local playerId = 0

local function onConfigChanged()
  playerId = ConvertStringTo64Bit(tostring(C.GetPlayerID()))

  local cfg = GetNPCBlackboard(playerId, "$ExampleBridgeConfig") or {}

  local enabled  = (cfg.enabled == true) or (cfg.enabled == 1)
  local maxRange = tonumber(cfg.maxRange) or 0
  local label    = tostring(cfg.label or "")

  DebugError(string.format("ExampleBridge: enabled=%s maxRange=%s label=%s",
    tostring(enabled), tostring(maxRange), label))
end

RegisterEvent("ExampleBridge.ConfigChanged", onConfigChanged)
```

Three things in that pair that are easy to lose an evening to:

- **The outer key keeps its `$`, the inner ones lose theirs.** You ask for `"$ExampleBridgeConfig"`, but the members come back as `cfg.enabled`, not `cfg["$enabled"]`. It works the same in reverse: a plain Lua table written with `SetNPCBlackboard` arrives on the script side with `$` on every key.
- **It survives saving.** Lua state does not. So the blackboard is also where a mod parks whatever it needs to still be there after a load.
- **You need the entity id.** `C.GetPlayerID()` returns an FFI value, so it goes through `ConvertStringTo64Bit(tostring(...))` before anything will accept it.

[↑ Contents](#toc)

<a id="conversions"></a>

## What survives the crossing

Whichever channel carries a value, it gets re-typed on the way through. Most of that is invisible until it is not, and it is where the time goes.

### Objects

Coming **from** a script, a component arrives as a LuaID. Everything in the UI's own game API wants a 64-bit id instead, so it gets converted on arrival - a single value from an event param:

```lua
local function onSetTarget(_, object)
  local component = ConvertStringTo64Bit(tostring(object))
  ...
end
```

and a whole list handed over through the blackboard, the same way:

```lua
local sectors = GetNPCBlackboard(playerId, "$ExampleBridgeDataExchange") or {}
for i = 1, #sectors do
  sectors[i] = ConvertStringTo64Bit(tostring(sectors[i]))
end
```

Going **back**, there are two routes and both of them work.

Convert in Lua, and the script side has nothing to do:

```lua
local data = { object = ConvertStringToLuaID(tostring(component)) }
AddUITriggeredEvent("ExampleBridge", "destroy_object", data)
```

```xml
<destroy_object object="event.param3.$object" explosion="false" />
```

Or send the raw 64-bit id and put the prefix on at the script level:

```lua
AddUITriggeredEvent("ExampleBridge", "reveal", { gate64a, gate64b })
```

```xml
<do_for_each name="$id" in="event.param3">
  <set_known object="component.{$id}" known="true" />
</do_for_each>
```

The first suits anything the script side is going to keep working with; the second suits the case where Lua already holds 64-bit ids and the script needs each one once.

The part that is easy to get backwards: **which conversion Lua needs depends on where the value came from**, not on what it looks like.

- From the bridge - an event param, a blackboard value, a signal param → `ConvertStringTo64Bit(tostring(x))`
- From the UI's own data - `GetComponentData`, menu tables, info-table rows → `ConvertIDTo64Bit(x)`

Using the string form on a LuaID out of that second group crashes rather than returning nil.

### Enumerations

Enums cross as plain strings, both ways, without their prefix. `faction.argon` reaches Lua as `"argon"`. Going back, Lua sends the bare string and the script side puts the prefix back with the lookup braces:

```lua
local data = {
  ship      = "ship_arg_l_destroyer_01_a_macro",
  ownerId   = "argon",
  ownerRace = "argon",
  role      = "marine",
}
AddUITriggeredEvent("ExampleBridge", "spawn_ship", data)
```

```xml
<set_value name="$data" exact="event.param3" />
<create_ship name="$ship" macro="$data.$ship" sector="$sector">
  <owner exact="faction.{$data.$ownerId}" overridenpc="true" />
  <pilot>
    <select race="race.{$data.$ownerRace}" tags="tag.aipilot" />
  </pilot>
</create_ship>
<create_npc_template object="$ship" role="entityrole.{$data.$role}" name="$npcTemplate" macro="$roleMacro" />
```

`faction.{...}`, `race.{...}`, `ware.{...}`, `macro.{...}`, `entityrole.{...}`, `tag.{...}`, `class.{...}` - all the same shape.

Watch the attribute you are feeding, though. `<create_ship macro="$data.$ship">` takes the bare name, while `<generate_loadout macro="macro.{$data.$ship}">` wants it wrapped. The schema type of that particular attribute decides, so there is no single rule to memorise - only the habit of checking.

### Booleans

A script's `true` reaches Lua as `1`, and `false` as `0`. Since `0` is truthy in Lua, the obvious check is wrong in exactly the case that matters:

```lua
-- true even when the script said false
if cfg.enabled then

-- correct
local enabled = (cfg.enabled == true) or (cfg.enabled == 1)
```

The other way, a Lua `true` compares equal to the script side's `true`. Both tests together cost nothing on anything shared, and the same variable tends to get written from both sides over a mod's life:

```xml
<do_if value="@player.entity.$ExampleBridgeDebug == true or
              @player.entity.$ExampleBridgeDebug == 1">
```

### Nothing at all

Writing `nil` from Lua removes the script variable outright - `SetNPCBlackboard(playerId, "$ExampleBridgeRequests", nil)` leaves the same state as `<remove_value name="player.entity.$ExampleBridgeRequests" />`, and the `?` test on the script side goes back to false. That is what makes drain-and-clear work from either end.

### Numbers

Numbers cross as numbers, and the script side's units come off. A position that is `position.[-38186.99m, ...]` on the script side arrives in Lua as plain `x`, `y`, `z`, and plain numbers go straight back in:

```lua
local data = { position = { x = offset.x, y = offset.y, z = offset.z } }
```

```xml
<position x="$data.$position.$x" y="$data.$position.$y" z="$data.$position.$z" />
```

[↑ Contents](#toc)

## The full round trip

This is where both doorbells and the mailbox come together, and it is the shape most mods settle into. The menu has a "park this ship" button; the rules for what parking means live in MD, so Lua asks and waits for an answer.

Lua sends the request:

```lua
local function requestPark(shipId)
  local queue = GetNPCBlackboard(playerId, "$ExampleBridgeRequests") or {}

  queue[#queue + 1] = {
    command = "park",
    ship    = ConvertStringToLuaID(tostring(shipId)),
  }

  SetNPCBlackboard(playerId, "$ExampleBridgeRequests", queue)
  AddUITriggeredEvent("ExampleBridge", "request")
end
```

MD does the work and answers:

```xml
<cue name="On_Request" instantiate="true">
  <conditions>
    <event_ui_triggered screen="'ExampleBridge'" control="'request'" />
  </conditions>
  <actions>
    <create_list name="$answers" />

    <do_for_each name="$request" in="player.entity.$ExampleBridgeRequests">
      <set_value name="$ship" exact="@$request.$ship" />
      <do_if value="@$request.$command == 'park' and
                    @$ship.exists and $ship.isclass.{class.ship}">
        <create_order object="$ship" id="'Wait'" immediate="true" />
        <append_to_list name="$answers" exact="table[$ship = $ship, $result = 'ok']" />
      </do_if>
      <do_else>
        <append_to_list name="$answers" exact="table[$ship = $ship, $result = 'rejected']" />
      </do_else>
    </do_for_each>

    <remove_value name="player.entity.$ExampleBridgeRequests" />
    <set_value name="player.entity.$ExampleBridgeAnswers" exact="$answers" />
    <raise_lua_event name="'ExampleBridge.Answers'" />
  </actions>
</cue>
```

Lua picks the answers up:

```lua
local function onAnswers()
  local answers = GetNPCBlackboard(playerId, "$ExampleBridgeAnswers") or {}
  SetNPCBlackboard(playerId, "$ExampleBridgeAnswers", nil)

  for _, answer in ipairs(answers) do
    DebugError(string.format("ExampleBridge: %s -> %s",
      tostring(answer.ship), tostring(answer.result)))
  end
end

RegisterEvent("ExampleBridge.Answers", onAnswers)
```

Four details in that shape that are easy to get wrong:

- **A list, not a single value.** The player can click twice before the script side gets a turn. A single slot loses the first click; a list does not.
- **The reader drains and clears.** The script side clears the request var with `<remove_value>`, Lua clears the answer var by writing `nil`. Whoever consumes it empties it, so the other side can start filling it again immediately.
- **A component crosses as a LuaID.** Lua wraps it with `ConvertStringToLuaID(tostring(id))`; on the script side `$request.$ship` is then a normal component reference, usable straight away with no `component.{}` wrapping.
- **Scripts can hand Lua things Lua cannot read.** An MD cue reference or a component put into a request comes back out of Lua unchanged and still works on the script side. Lua does not have to understand a value to carry it.

[↑ Contents](#toc)

## Signals: reaching one object, and the AI script flying it

The doorbells are addressed to the game as a whole. `SignalObject` is addressed to one object, and everything running on that object hears it - including its AI script. This is how a UI talks to a specific ship rather than to the mod in general.

The object does not have to be a ship, though, and that is what makes signals usable as a general channel too. `C.GetPlayerID()` in Lua and `player.entity` in a script are the same entity, so signalling it gives a bridge that needs no target at all:

```lua
SignalObject(playerId, "ExampleBridge.SomethingHappened")
```

```xml
<cue name="On_Something" instantiate="true">
  <conditions>
    <event_object_signalled object="player.entity" param="'ExampleBridge.SomethingHappened'" />
  </conditions>
  <actions>
    ...
  </actions>
</cue>
```

That covers the same ground as `AddUITriggeredEvent`, with one useful difference: `param2` takes a table, so a structured payload can travel with the signal instead of being parked first. The rest of this section is the aimed-at-a-ship case, where the AI script is the listener.

Lua tells one ship what to fetch:

```lua
local function sendOrders(shipId, wareName, amount)
  local ship  = ConvertStringTo64Bit(tostring(shipId))
  local pilot = ConvertIDTo64Bit(GetComponentData(ship, "pilot"))

  SetNPCBlackboard(pilot, "$exampleBridgeOrders", {
    ware   = wareName,
    amount = amount,
  })

  SignalObject(ship, "ExampleBridge.NewOrders")
end
```

The handler goes wherever a script is already running on that pilot - your mod's own order script is the natural place for it, in its `<interrupts>` block. `aiscripts/example.order.with.bridge.listener.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<aiscript name="example.order.with.bridge.listener" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="aiscripts.xsd" version="1">
  ...
  <interrupts>
    ...
    <handler>
      <conditions>
        <event_object_signalled object="this.assignedcontrolled"
          param="'ExampleBridge.NewOrders'" />
      </conditions>
      <actions>
        <set_value name="$orders" exact="@this.$exampleBridgeOrders" />
        <debug_text text="'ExampleBridge: %s told to fetch %s x %s'.
                          [this.assignedcontrolled.debugname, @$orders.$amount, @$orders.$ware]"
          chance="100" filter="scripts" />
        <remove_value name="this.$exampleBridgeOrders" />
        <raise_lua_event name="'ExampleBridge.OrdersTaken'" param="this.assignedcontrolled" />
      </actions>
    </handler>
    ...
  </interrupts>

  <attention min="unknown">
    <actions>
      ...
    </actions>
  </attention>
</aiscript>
```

And the confirmation coming back into Lua:

```lua
RegisterEvent("ExampleBridge.OrdersTaken", function(_, param)
  local ship = ConvertStringTo64Bit(tostring(param))
  DebugError("ExampleBridge: orders taken by " .. tostring(ship))
end)
```

The asymmetry in that pair is the part that takes longest to see:

- **You write the payload on the pilot, and you signal the ship.** Inside the AI script the pilot is `this`, so it reads its own mailbox as `this.$exampleBridgeOrders` - the same variable Lua wrote with `SetNPCBlackboard(pilot, ...)`. The signal, meanwhile, is aimed at the ship, so the handler catches it with `object="this.assignedcontrolled"`.
- **Any script on that pilot will do.** The example above is an order, but `this` is the pilot in every script running on it, so the same handler works unchanged in a behaviour, a task or a listener script of its own.
- **For small payloads you can skip the blackboard.** `SignalObject`'s `param2` accepts a whole Lua table, which arrives as a script-side table with `$` on every key:

```lua
SignalObject(ship, "ExampleBridge.NewOrders", { ware = "energycells", amount = 500 })
```

```xml
<event_object_signalled object="this.assignedcontrolled" param="'ExampleBridge.NewOrders'" />
...
<set_value name="$ware" exact="@event.param2.$ware" />
```

That is the one place where structured data crosses without the mailbox. It has no equivalent for `raise_lua_event` going the other way, which is why the round trip above needs the blackboard and this does not.

The script side signals objects the same way, with `<signal_objects>`:

```xml
<signal_objects object="$ship" param="'ExampleBridge.NewOrders'"
  param2="table[$ware = ware.energycells, $amount = 500]" delay="200ms" />
```

The `delay` attribute is there for a reason: a signal sent with no delay from inside a cue can re-trigger that same cue and recurse forever.

[↑ Contents](#toc)

## Gotchas

The conversion traps are all in [What survives the crossing](#conversions). What is left over:

- `raise_lua_event` takes a string, number or component. Nothing structured. Everything else goes through the blackboard.
- Event names, screen names and signal names are global. Prefix all of them with the mod name.
- Nothing listening means silence, in both directions. No error to go looking for.
- Script format strings only understand `%s`. `%d` is a runtime error. Numbers print fine through `%s`.
- Only the menus environment can do any of this. `AddUITriggeredEvent` is the sole exception, and only since 9.00.

[↑ Contents](#toc)

[Back to UI Modding support](doc:WebHome) · [Lua Globals Reference](<doc:Lua Globals Reference.WebHome>) for the signatures of every function named here.

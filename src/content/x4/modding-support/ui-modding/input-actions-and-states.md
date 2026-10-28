---
title: Catching input actions and states
description: How an extension's UI Lua gets its own handler for the game's input actions and states, next to the game's own handling of them, with the container magnet and the pause key as the worked examples.
order: 6
wiki: Catching input actions and states
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Catching input actions and states

Every key the player presses goes through the input system first. A key is mapped to an **action** (one event per press: pause, open the map, deploy a satellite) or to a **state** (something that is on for as long as the key is held: accelerate, strafe, the container magnet). The list of actions and states is part of the game and cannot be extended by an extension. The game handles each of them itself, and nothing about that changes with an extension installed.

An extension can still have its own handler for them. The menus side of the UI has a hook for exactly this, and the game's own menus use it: the chat window opens on its action, the interact menu reads two states while it is open. The hook delivers the id of the action or state and, for a state, whether it just became active or inactive. The game's own handling runs as before; the callback is an addition to it.

This article covers what arrives in Lua, how an id is attached to the hook, and what is easy to get wrong. The examples are the container magnet, `INPUT_STATE_LOOTMAGNET`, and the pause action, `INPUT_ACTION_PAUSE`.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Actions and states

The ids are defined by the game. `libraries/contexts.xml` lists every action, state and range inside the **contexts** it belongs to; `libraries/inputmap.xml` holds the default key of each one. An id that is not in that list does not exist: a binding to an unknown name is refused with an error in the log.

A context is a set of inputs that is active together. `INPUT_CONTEXT_BASE` is on all the time and holds the pause and screenshot actions; `INPUT_CONTEXT_SHIP` is on while the player pilots a ship and holds the flight states, the container magnet among them. A key only resolves to an id while a context holding that id is active, which matters later: the magnet state does not exist while the player walks on a platform or sits docked.

The two kinds behave differently at the hook:

| Kind | Fires | Arrives as |
| --- | --- | --- |
| action | once per press | `(id, true)` |
| state | on the press edge and on the release edge | `(id, true)` then `(id, false)` |

## Where the callback arrives

The widget layer, `ui/widget/lua/widget_fullscreen.lua`, keeps a list of hotkey scripts. An extension registers one from its Lua file:

```lua
SetScript("onHotkey", myHandler)
-- and later, if the extension wants out:
RemoveScript("onHotkey", myHandler)
```

Every registered script is called with the same two arguments, `id` as a string and `active` as a boolean, for every attached action or state that fires. A script that errors does not stop the others; the error lands in the log with the id in it. Registering the same function twice logs an error and keeps the first registration.

There is no per-id registration: a handler sees every id attached through the binding below and picks what it wants by the id string. The vanilla menus do the same, each one ignoring what is not its own.

The game's own handling has already happened when the callback runs. For the pause action, the game is paused inside the callback; for the magnet state, the magnet is on by the time the `true` edge arrives, and the feedback text is already on its way to the message ticker.

## Attaching an id to the hook

What makes the game call the hook for a given id is a **binding** inside a `bindinggroup` of an addon's `ui.xml`. The debug log addon's file is the smallest example in the game:

```xml
<bindinggroup id="debuglog" context="INPUT_CONTEXT_ADDON_DEBUGLOG" alwaysactive="true">
  <binding action="INPUT_ACTION_OPEN_DEBUG_LOG" />
</bindinggroup>
```

A `binding` names an `action` or a `state`. When the addon loads, each one is looked up in the game's list and attached to the dispatcher that calls the `onHotkey` scripts. The attachment is keyed by the id alone: once the magnet state is bound, its edges arrive whenever the state fires in the ship context, whatever context the group itself names. A group of one's own with `context="INPUT_CONTEXT_BASE"` and `alwaysactive="true"` is enough; the `context` and `alwaysactive` attributes are required by the schema, and the base context is on all the time.

Two rules come with it:

- **An id is bound by one addon.** A second addon binding the same action or state gets an error in the log ("already registered before") and its whole group is refused.
- **Only the game's own addons declare a group.** The schema an extension's `ui.xml` is validated against, `ui/core/addon.xsd`, has no `bindinggroup` element; the element exists in `ui/core/coreaddon.xsd`, which applies to addons whose name starts with `ego_`. The binding therefore goes into one of the vanilla addon files.

The way to get it there is to ship a complete copy of a vanilla `ego_*` addon's `ui.xml` with a group of one's own added, in a `subst_` catalog, since the file replaces the original rather than patching it; a `<diff>` of that file is not applied. Any of the vanilla addon files will do; the smallest ones, such as the target monitor's, carry no group of their own, so the copy is the original plus the new group. How those catalogs differ from `ext_` ones, and why two extensions replacing the same file cannot both take effect, is in [Catalogs](/x4/modding-support/anatomy-of-an-extension/catalogs/#ext_-and-subst_-are-not-the-same-kind-of-thing). The copy has to match the game version it ships for.

A new catalog is read when the game starts. Reloading the UI does not pick it up.

## Example: an input watcher

A fictional extension `input_watch` reports how long the container magnet was held to the script side, and counts pauses on the Lua side. The split is deliberate: scripts do not run while the game is paused, so a reaction to the pause itself has to live in Lua, while the magnet is released in a running game and the script side can take it from there. Four files.

### `ui.xml` of the extension

The extension's own addon file, registering its Lua as usual:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<addon name="input_watch" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="../../ui/core/addon.xsd">
  <environment type="menus">
    <file name="ui/input_watch.lua" />
  </environment>
</addon>
```

### `ui/addons/ego_targetmonitor/ui.xml`, packed into `subst_01.cat`

The vanilla file with one group added. It is the whole file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<addon name="ego_targetmonitor" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../../core/coreaddon.xsd">
  <environment type="menus">
    <file name="targetmonitor.lua" />
    <bindinggroup id="inputwatch" context="INPUT_CONTEXT_BASE" alwaysactive="true">
      <binding state="INPUT_STATE_LOOTMAGNET" />
      <binding action="INPUT_ACTION_PAUSE" />
    </bindinggroup>
  </environment>
</addon>
```

The catalog holds that one entry at that path.

### `ui/input_watch.lua`

```lua
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
  const char* GetMappedInputName(const char* functionkey);
]]

local inputWatch = {
  heldSince = nil,
  pauses = 0,
  lastPause = nil,
}

local function onHotkey(id, active)
  if id == "INPUT_STATE_LOOTMAGNET" then
    if active then
      inputWatch.heldSince = getElapsedTime()
    elseif inputWatch.heldSince then
      local held = getElapsedTime() - inputWatch.heldSince
      inputWatch.heldSince = nil
      AddUITriggeredEvent("InputWatch", "released", held)
    end
  elseif id == "INPUT_ACTION_PAUSE" then
    -- an action arrives once, with active == true; the game is already
    -- paused here, so this stays on the Lua side
    inputWatch.pauses = inputWatch.pauses + 1
    inputWatch.lastPause = getElapsedTime()
  end
end

local function init()
  SetScript("onHotkey", onHotkey)
  -- the key the player has mapped, for any text that names it
  inputWatch.keyName = ffi.string(C.GetMappedInputName("INPUT_STATE_LOOTMAGNET"))
end

init()
```

`getElapsedTime()` is real time, so a pause does not stretch the measured hold. The key name is read once for a display text; the `$INPUT_STATE_LOOTMAGNET$` placeholder inside a text page entry resolves to the same name when the text is read, as the game's own tutorial lines do.

### `md/input_watch.xml`

The script side receives the magnet event:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="InputWatch" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="MagnetReleased" instantiate="true">
      <conditions>
        <event_ui_triggered screen="'InputWatch'" control="'released'" />
      </conditions>
      <actions>
        <debug_text text="'magnet held for %s s'.[event.param3]" filter="general" />
      </actions>
    </cue>
  </cues>
</mdscript>
```

With the files in place and the game started, holding the magnet key in a ship writes the held time on release, the magnet itself attracts containers as before, and each press of the pause key still pauses and is counted in Lua.

## What to expect

- **Nothing arrives outside the context.** The magnet state fires only while the player pilots an undocked ship. On a platform, inside a ship's interior or at a dock, the key resolves to nothing, so the handler sees nothing. An action in `INPUT_CONTEXT_BASE` such as pause arrives anywhere.
- **The game's handling stays, and comes first.** The container magnet attracts, the feedback text appears in the message ticker, the pause pauses, all before the callback runs. The hook reports; it does not intercept.
- **The current key, not the default.** Players rebind. A text that names the key reads it through `GetMappedInputName` or the `$INPUT_STATE_...$` placeholder rather than naming the default from `inputmap.xml`.
- **Actions carry `true`.** The second argument is meaningful for states only; for an action it is always true, which is why the vanilla handlers that only bind actions take a single parameter.
- **One binding per id across all installed extensions.** Two extensions that each want the magnet state cannot both bind it. An extension that binds an id on behalf of others has to hand the callback on itself.
- **Two ways to collide with another mod, one loud and one silent.** The same id bound by two extensions is refused for the later one, with the error in the log, so it is found quickly. Two extensions that each ship their own copy of the same vanilla `ui.xml` is quieter: one copy wins, the other extension's group is simply absent, and no line in the log says so, since each copy is a valid file on its own. The exposure is smallest when the copy changes nothing but the added group and the group holds only the ids the extension needs; where several mods want the same ids, one extension that binds them and hands the callbacks on, with the others depending on it, avoids both collisions.

[Back to UI Modding support](/x4/modding-support/ui-modding/) · [Catalogs](/x4/modding-support/anatomy-of-an-extension/catalogs/) for the `subst_` packaging.

---
title: Adding an entry to the top menu
description: The top menu row holds 11 icons and a 12th stops every menu from opening. How to add an entry that switches the row to the game's own scrolling view when it overflows.
order: 5
wiki: Adding an entry to the top menu
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Adding an entry to the top menu

The row of icons on top of the map, the options and the other full-screen menus is built from one shared list, `Helper.topLevelMenus`. An extension adds its own menu to the row by inserting an entry there. The row has a hard limit, and when several extensions each add an icon, the limit is easy to pass without any single one of them doing anything wrong.

This article covers the limit, what happens past it, and a pattern that keeps the menus working: insert the entry, and switch the row to the game's built-in scrolling view whenever it no longer fits.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## The limit

`Helper.createTopLevelTab` draws the row as one table with a column per shown entry plus two more. A table has at most `Helper.maxTableCols` columns, which is 13, so **at most 11 entries may be shown at once**. An entry is shown when `Helper.checkTopLevelConditions(entry)` returns true; some vanilla entries come and go with the game state (`docked` or `cockpit`, terraforming once it is unlocked, the multiverse map while ventures are online).

Vanilla itself shows 9 or 10 entries, which leaves room for one or two extension entries.

A 12th shown entry does not degrade gracefully. The game log gets

```text
Too many columns. Table contains 14 columns while the max number of columns allowed is 13
```

from `Helper.createTopLevelTab`, the view fails, the UI reloads, and the next attempt fails the same way. Every menu with the row fails: the map, the options menu (so Escape too), player information. The player is left without a way to switch anything off.

## The scrolling view

The row has a second layout, off by default: a carousel of five icons around the current one, with the others one click away on either side. It always uses the same number of columns, so any number of entries fits.

It is a plain field:

```lua
Helper.topLevelConfig.scrolling = true
```

`Helper.createTopLevelConfig()` builds `Helper.topLevelConfig` once, when the helper loads, and nothing in vanilla changes it later. Setting the field takes effect the next time a menu draws the row; no patch is needed. A UI reload builds the config again with scrolling off, and the extension's own init runs again after it, so the state does not outlive the Lua session. The field exists in 8.00 and 9.00 alike.

The carousel is fixed at five icons. `numDisplayedIcons` in the config looks adjustable, but `createTopLevelTab` fills exactly five slots, so a larger value only adds empty columns.

## The pattern

1. Insert the entry, then count the shown entries. Over 11, switch scrolling on at once.
2. Count again every few seconds while the entry is in the list. Other extensions may insert their entries later, and vanilla's own count changes during the game.
3. Give the player an option to hide the icon. When it is switched off, remove the entry and switch scrolling off again, but only if scrolling was switched on by an extension (not by something else) and the row now fits.
4. Write a line to the game log whenever scrolling is switched on, naming the option that gets the full row back. A player reading the log, or a modder reading a player's log, sees the reason at once.

Step 3 needs a mark that says "an extension switched this on". Store it on the config itself, under a name every extension using this pattern shares: `Helper.topLevelConfig.chemodunOverflowScrolling`. With one shared name, any of them can switch scrolling off when its own icon goes away, whichever one switched it on, and none of them switches off a scrolling view that another source asked for.

The count limit uses `Helper.maxTableCols - 2` rather than a literal 11, so it follows the helper if the table limit ever changes.

## Example

A complete Lua side for a fictional extension whose overview menu is `FleetBoardMenu`, with its icon right after the map. `fleetBoard` is the extension's own table, and `fleetBoard.iconOn()` stands for however it reads its own option.

```lua
local TOP_LEVEL_ID = "fleetboard"
local SCROLLING_MARK = "chemodunOverflowScrolling"
local CHECK_INTERVAL = 5
local checkQueued = false

local function topLevelRoom()
  local shown = 0
  for _, entry in ipairs(Helper.topLevelMenus) do
    if Helper.checkTopLevelConditions(entry) then
      shown = shown + 1
    end
  end
  local max = (Helper.maxTableCols or 13) - 2
  return max - shown, shown, max
end

local function hasEntry()
  for _, entry in ipairs(Helper.topLevelMenus) do
    if entry.id == TOP_LEVEL_ID then
      return true
    end
  end
  return false
end

local function enableScrolling(shown, max)
  local cfg = Helper.topLevelConfig
  if (not cfg) or cfg.scrolling then
    return
  end
  cfg.scrolling = true
  cfg[SCROLLING_MARK] = true
  DebugError(string.format("Fleet Board: the top menu shows %d entries, at most %d fit in a row: switched it to scrolling. Switch the Fleet Board top menu icon off in Extension Options to get the row back.", shown, max))
end

local function releaseScrolling()
  local cfg = Helper.topLevelConfig
  if not (cfg and cfg.scrolling and cfg[SCROLLING_MARK]) then
    return
  end
  local room = topLevelRoom()
  if room >= 0 then
    cfg.scrolling = false
    cfg[SCROLLING_MARK] = nil
  end
end

local scheduleCheck

local function checkRow()
  checkQueued = false
  if not hasEntry() then
    return
  end
  local room, shown, max = topLevelRoom()
  if room < 0 then
    enableScrolling(shown, max)
  end
  scheduleCheck()
end

scheduleCheck = function()
  if checkQueued then
    return
  end
  checkQueued = true
  Helper.addDelayedOneTimeCallbackOnUpdate(checkRow, false, getElapsedTime() + CHECK_INTERVAL)
end

local function addEntry()
  local list = Helper.topLevelMenus
  local pos = #list + 1
  for i, entry in ipairs(list) do
    if entry.id == TOP_LEVEL_ID then
      return
    end
    if entry.id == "map" then
      pos = i + 1
    end
  end
  table.insert(list, pos, {
    id = TOP_LEVEL_ID, name = ReadText(77000, 1), icon = "tlt_fleetboard", shortcut = "",
    menu = "FleetBoardMenu", helpOverlayID = "toplevel_fleetboard", helpOverlayText = ReadText(77000, 2), param = { 0, 0 },
  })
  local room, shown, max = topLevelRoom()
  if room < 0 then
    enableScrolling(shown, max)
  end
  scheduleCheck()
end

local function removeEntry()
  local list = Helper.topLevelMenus
  for i, entry in ipairs(list) do
    if entry.id == TOP_LEVEL_ID then
      table.remove(list, i)
      break
    end
  end
  releaseScrolling()
end

-- Called from init and whenever the option changes.
function fleetBoard.syncTopLevelEntry()
  if fleetBoard.iconOn() then
    addEntry()
  else
    removeEntry()
  end
end
```

The menu draws the row itself as usual, with `Helper.createTopLevelTab(menu, "fleetboard", frame, ...)` in its display function; the id there is the entry's `id`. Nothing in the menu changes for the scrolling view.

## Notes

- The icon option is the player's way out, so keep it and keep it on the Extension Options page, which opens without the row.
- The recheck only switches scrolling on. Switching it off while the entry is still in the list would bring back the failure the moment another entry appears; that happens only through the icon option, when the row is known to fit.
- A rescheduled check stops by itself once the entry is removed, so there is no timer to cancel.

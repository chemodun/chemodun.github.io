---
title: UI Modding support
description: X4's interface is Lua, and it is moddable without touching the executable.
order: 1
wiki: UI Modding support
---

# UI Modding support

X4's interface is Lua, and it is moddable without touching the executable. The vanilla code sits in `ui.cat`: `ui/addons/*` are the menus, `ui/core/*` is the HUD, and `ui/widget/lua/widget_fullscreen.lua` is the widget layer the menus are built on. An extension joins the menus side by shipping a `ui.xml` of its own; the HUD runs in a second, separate Lua environment that no extension can register a file into.

Either way, a UI mod starts from the global namespace the game hands it.

{{children}}

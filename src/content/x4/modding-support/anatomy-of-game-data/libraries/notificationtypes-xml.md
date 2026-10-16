---
title: notificationtypes.xml
description: How libraries/notificationtypes.xml lists the notification types the player can switch on and off - the interactive and informational NPC events and the ticker messages - how the settings screen shows them, how a script honours the setting, and how an extension adds a type for its own messages.
---

# notificationtypes.xml

The player can decide which of the game's messages to see: the pilot asking for orders, a ship reporting it is out of ammunition, the ticker lines about money received or reputation gained. Each of those is a **notification type**, and `libraries/notificationtypes.xml` is the list of them. The Notification Settings screen shows the list with a checkbox per type, and a script that is about to show a message of that kind checks whether the type is enabled first.

The file does not define the messages themselves. A message is shown by a script with `show_notification` or `show_interactive_notification` and its own text; the type is the switch the player holds over it. This article covers the format, the settings screen, the script side and how an extension adds a type. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Notification type**: one `<notification>` entry, named by its `id`. A script refers to it as `notification.<id>`.
- **Category**: one of three, deciding where the type is listed in the settings: `npc_interactive`, `npc_info` or `ticker`.
- **Interactive notification**: a message in the target monitor the player can respond to, shown with `show_interactive_notification`.
- **Ticker**: the line of text at the top of the screen, shown with `show_notification`.

[↑ Contents](#toc)

## How a type is used

1. **The settings screen lists the types.** The Notification Settings section of the player information menu reads every type, groups them under the three category headings, and shows a checkbox per type with its name and, as a tooltip, its description. A checkbox per category switches all of its types at once.
2. **The player's choice is stored per type.** A type starts enabled unless its entry says otherwise, and the player's change stays until changed again.
3. **A script checks the type before it shows anything.** `notification.ship_destroyed.active` is true while the player keeps the type on; vanilla's scripts test it and only then call `show_notification` with the message text. Nothing stops a script that does not check.

[↑ Contents](#toc)

## The file

### Layout

```xml
<notificationtypes>
  <!-- Interactive NPC events -->
  <notification category="npc_interactive" id="npc_under_attack" name="{1015,262}" />
  <notification category="npc_interactive" id="npc_out_of_ammo" name="{1015,43}" />
  ...
  <!-- Non-interactive NPC events -->
  <notification category="npc_info" id="npc_await_orders" name="{1015,1003}" />
  ...
  <!-- Ticker messages -->
  <notification category="ticker" id="money_added" name="{1015,1002}" />
  <notification category="ticker" id="reputation_gained" name="{1015,14}" />
  ...
</notificationtypes>
```

The base file holds a couple of dozen types in the three categories, each with a comment naming the script that uses it. No expansion ships a `notificationtypes.xml`.

The schema, `libraries/notificationtypes.xsd`, documents the attributes.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The type id, `notification.<id>` in a script |
| `name` | The name shown in the settings; vanilla's are on text page 1015, the page the notification texts share |
| `description` | A longer text, shown as the tooltip of the setting |
| `category` | `npc_interactive`, `npc_info` or `ticker`: the heading the type is listed under |
| `default` | Whether the type starts enabled; true when omitted, and vanilla omits it everywhere |

The category is a heading and nothing more: it decides where the type sits in the settings, and the script that shows the message decides whether it goes to the ticker or the target monitor.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `notification.<id>` | The type |
| `.active` | Whether the player has the type enabled; the check to make before showing a message |
| `.name`, `.description` | The texts |
| `set_notification_type_enabled type="..." enabled="..."` | Set the player's switch for a type. The schema says to do this during a game start only, since the player owns the setting afterwards; vanilla does not use it |
| `show_notification` | A ticker message: `text`, an optional `timeout`, `priority` and `sound` |
| `show_interactive_notification` | A message in the target monitor with an `<interaction>` the player can trigger, and optionally the relation bar of a faction or object |

The pattern in vanilla's order scripts is one line: `<do_if value="notification.npc_await_orders.active">` around the `show_notification` that tells the player a ship has finished its orders. The ticker types are checked the same way in the notification script.

[↑ Contents](#toc)

## Adding a type from an extension

An extension that shows messages of its own gives the player a switch for them by adding a type and checking it. The example below, for a fictional extension `example_alerts`, adds a ticker type for low fuel warnings.

`libraries/notificationtypes.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/notificationtypes">
    <notification category="ticker" id="example_low_fuel" name="{1234567,1}" description="{1234567,2}" />
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example alerts" descr="" voice="no">
    <t id="1">Low fuel warnings</t>
    <t id="2">A ticker message when one of your ships runs low on fuel.</t>
    <t id="3">%s is running low on fuel.</t>
  </page>
</language>
```

And the check in the extension's script, where the message is shown:

```xml
<do_if value="notification.example_low_fuel.active">
  <show_notification text="[{1234567,3}, $Ship.knownname]" sound="notification_warning" />
</do_if>
```

Some points about the example:

- **The type appears in the settings as soon as the diff is loaded**, under the ticker heading, enabled.
- **The check is the extension's to make.** The type does nothing by itself; a message shown without the `.active` test ignores the player's choice.
- **One type per kind of message** is the vanilla granularity: the player switches off low fuel warnings, not every message of the extension.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

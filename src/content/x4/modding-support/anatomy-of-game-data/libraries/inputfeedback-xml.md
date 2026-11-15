---
title: inputfeedback.xml
description: How libraries/inputfeedback.xml lists the input actions, states and ranges that give feedback - a line of text in the message ticker or in the centre of the screen, and a spoken line - with the default of each, how the two options pages expose them, where the feedback texts are, how UI Lua triggers feedback for the inputs it handles, and what an extension can change.
---

# inputfeedback.xml

When the key for Travel Mode is pressed, the game can confirm it: "Travel Mode activated", as a line of text, as a spoken line, or both. This is **input feedback**. `libraries/inputfeedback.xml` lists the inputs that give it and sets two things for each: the default form of the text, and whether a text and a voice option exist for it at all. Whether and how the feedback then appears is the player's choice in the options menu.

This article covers the format, the options that work on it, the feedback texts, the Lua side and what an extension can change. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Input**: something a key, button or axis can be bound to. The game has three kinds: an **action** happens once per press, a **state** lasts while the key is held, a **range** is an analogue value such as the throttle. The ids are the game's own, listed in `libraries/contexts.xml` and `libraries/inputmap.xml`.
- **Text feedback**: the line of text an input gives, shown in one of two places.
- **Message ticker**: the ticker of the flight interface, where notifications also appear; the first of the two places.
- **Screen centre**: a short line in the middle of the view, the second place. The file calls it `controlmessage`.
- **Voice feedback**: the same line, spoken.

[↑ Contents](#toc)

## How feedback is switched

Three levels decide what the player gets:

1. **The file** names the inputs that have feedback, with a default for text and voice. An empty value takes the option away.
2. **The master option**, Settings, Game Settings, Input Feedback: Off, Text only, Voice only, or Text and Voice. Its default, in `libraries/config.xml`, is text only.
3. **The option per input**, Settings, Accessibility Settings, Input Feedback Configuration. The page repeats the master option at the top and then lists the controls with two columns, Text Feedback with Off, Message Ticker and Screen Centre, and Voice Feedback with Off and On. Where the file gives an empty value, the cell shows "Unavailable" in place of a dropdown. Buttons above the list set all text or all voice options at once, and Restore Defaults returns to the defaults.

The list on that page follows the flight section of the Controls menu and shows the controls that have an entry in the file, with the same names and the same search field.

The player's choices are saved in an `inputfeedback.xml` in the personal folder, apart from the game's file. It has the same layout and holds only the entries the player changed. Restore Defaults removes it.

A screen centre line stays for about two seconds.

[↑ Contents](#toc)

## The file

### Layout

```xml
<inputfeedback>
  <config>
    <action id="INPUT_ACTION_TOGGLE_TARGET_LOCK" text="controlmessage" voice="on" />
    <action id="INPUT_ACTION_SELECT_PRIMARY_WEAPONGROUP_1" text="controlmessage" voice="on" />
    ...
    <action id="INPUT_ACTION_DEPLOY_COUNTERMEASURE" text="ticker" voice="on" />
    <action id="INPUT_ACTION_TOGGLE_TRAVEL_MODE" text="" voice="on" />
    <action id="INPUT_ACTION_TOGGLE_HUD" text="off" voice="on" />
    <action id="INPUT_ACTION_TARGET_NEXT_ENEMY" text="off" voice="" />
    <action id="INPUT_ACTION_MUTE" text="controlmessage" voice="" />
    ...
    <state id="INPUT_STATE_BOOST" text="ticker" voice="on" />
    <state id="INPUT_STATE_MATCH_SPEED" text="controlmessage" voice="on" />
    <state id="INPUT_STATE_LOOTMAGNET" text="ticker" voice="on" />
    <range id="INPUT_RANGE_THROTTLE" text="ticker" voice="on" />
    <range id="INPUT_RANGE_MOUSEWHEEL" text="ticker" voice="on" />
  </config>
</inputfeedback>
```

The root `<inputfeedback>` holds one `<config>`, and that holds a flat list: the `<action>` entries, then the `<state>` entries, then the `<range>` entries. The three elements have the same attributes.

The schema, `libraries/inputfeedback.xsd`, documents them.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The id of the input: `INPUT_ACTION_...` on an `<action>`, `INPUT_STATE_...` on a `<state>`, `INPUT_RANGE_...` on a `<range>` |
| `text` | The text feedback: `ticker` for the message ticker, `controlmessage` for the screen centre, `off` for none. Empty or left out, the input has no text option |
| `voice` | The voice feedback: `on` or `off`. Empty or left out, the input has no voice option |

`off` and empty are different things. With `off` the feedback is switched off by default and the player can switch it on; with an empty value there is nothing to switch.

[↑ Contents](#toc)

### What vanilla sets

The vanilla values show what each form is meant for:

- **`controlmessage` for a choice that has to be seen at once**: selecting a weapon group, locking the target, switching the steering axis or auto-roll, matching speed, muting the sound.
- **`ticker` for most of the rest**: countermeasures, stopping the engines, docking and undocking, deploying a satellite, mine or laser tower, the wing commands, boost, the container magnet.
- **An empty `text` where the interface shows the result itself**: Travel Mode, SETA, the scan modes, flight assist and the mouse steering modes have their own display, and get voice only.
- **`text="off"` for the busy keys**: cycling targets and subcomponents, toggling the HUD. Text exists and can be switched on.
- **An empty `voice` in a few places**, such as the target cycling keys and Mute.

Two entries carry `ADDON` in their id beside the plain one: `INPUT_ACTION_ADDON_DETAILMONITOR_TRAVELMODE` next to `INPUT_ACTION_TOGGLE_TRAVEL_MODE`, and the same for SETA. They belong to the same functions triggered from a menu, where the UI Lua handles the input and asks for the feedback itself, as shown in [The Lua side](#the-lua-side).

[↑ Contents](#toc)

## The feedback texts

The lines are on text page `20234`, "Input Feedback", in `t/0001-l0NN.xml`. The page is marked as voiced, which is what the voice feedback speaks.

The text ids on the page follow a pattern of seven digits: one for the kind of input, `1` for an action, `2` for a state, `3` for a range; four for the number of the input; and two for the message.

```xml
<t id="1030301">Travel Mode activated</t>
<t id="1030302">Travel Mode deactivated</t>
<t id="1030303">Travel Mode is not possible</t>
<t id="2008001">Container Magnet activated</t>
<t id="2008002">Container Magnet deactivated</t>
```

Here `0303` is the Travel Mode action and `0080` the container magnet state, the numbers these inputs have in the game and in the Controls menu. An input has as many messages as it has outcomes: one for a plain action, two for a toggle, more where an action can fail, as with docking, which has lines for permission granted, request queued, request denied, not possible, too far away and aborted. The game picks the message by the outcome.

A message may refer to another one, and may carry a colour: the line for weapons and boost blocked by the ship's stance is written with the named colour `text_error` of [colors.xml](/x4/modding-support/anatomy-of-game-data/libraries/colors-xml/).

[↑ Contents](#toc)

## How the expansions change it

No expansion ships an `inputfeedback.xml`. The base file holds every entry, including the one for an input that only matters with an expansion pack: `INPUT_ACTION_TOGGLE_STANCE`, for the ship stances of [stances.xml](/x4/modding-support/anatomy-of-game-data/libraries/stances-xml/).

[↑ Contents](#toc)

## The Lua side

Scripts have no access to input feedback: no MD or AI script element works on it. The UI Lua has two uses for it.

The first is the options pages, which read and write the settings:

| Function | What it does |
| --- | --- |
| `C.GetInputFeedbackOption()`, `C.SetInputFeedbackOption(value)` | The master option: `off`, `text`, `voice` or `textandvoice` |
| `C.GetNumAllInputFeedback()`, `C.GetAllInputFeedback(result, resultlen)` | Every entry as an `InputFeedbackConfig`: `type` (`action`, `state` or `range`), the number `id`, `idname`, `textoption` and `voiceoption` |
| `C.SetInputFeedbackTextOption(type, idname, textoption)`, `C.SetInputFeedbackVoiceOption(type, idname, voiceoption)` | Set the option of one entry |
| `C.ExportInputFeedbackConfig()` | Saves the player's settings to the personal file |
| `C.ImportInputFeedbackConfig(usedefault)` | With `true`, restores the defaults and removes the personal file; this is what Restore Defaults calls |

The second is asking for feedback. Most inputs are handled by the game, which gives the feedback itself. Where a menu handles an input, it asks:

```lua
C.TriggerInputFeedback("action", "INPUT_ACTION_ADDON_DETAILMONITOR_TRAVELMODE", "active", "")
```

The arguments are the kind, the input id, a trigger id that stands for the outcome, and a context id that vanilla leaves empty. The trigger ids found in vanilla are `active`, `inactive` and `impossible` for the Travel Mode and SETA entries of the map, `active` and `inactive` for the chat window, and `fasttravel` on `INPUT_ACTION_UNDOCK` for a fast travel off a platform, which gives "Fast travelled" in place of "Undocking". The inputs triggered this way are entries of the file like the others, with their own text and voice values.

Hooking an input from an extension's own Lua is a different matter and is covered in [Catching input actions and states](/x4/modding-support/ui-modding/input-actions-and-states/). The game's feedback for an input comes before such a hook runs.

[↑ Contents](#toc)

## Changing the defaults from an extension

The inputs are the game's own, so an extension does not add entries for inputs of its own making. What it can change are the defaults of the existing entries: where the text appears, whether it is on, and whether an option exists. The example below, for a fictional extension `example_feedback`, gives Travel Mode a text option, moves the engine stop message to the screen centre and switches the HUD text on.

`libraries/inputfeedback.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/inputfeedback/config/action[@id='INPUT_ACTION_TOGGLE_TRAVEL_MODE']/@text">ticker</replace>
  <replace sel="/inputfeedback/config/action[@id='INPUT_ACTION_STOP']/@text">controlmessage</replace>
  <replace sel="/inputfeedback/config/action[@id='INPUT_ACTION_TOGGLE_HUD']/@text">ticker</replace>
</diff>
```

Some points about the example:

- **No text file is needed.** The messages of all three inputs are on page `20234` already; Travel Mode has its lines although vanilla gives it no text option, because the voice speaks them.
- **An empty value is replaced like any other.** The `text` attribute of the Travel Mode entry is there with an empty value, so `<replace>` on `@text` finds it.
- **These are defaults.** An entry the player has changed keeps the saved value: with the engine stop message switched off in the options, it stays off. The other two entries follow the diff, and Restore Defaults returns to the values of the diff, not to the vanilla ones.
- **The master option still rules.** With Input Feedback set to Off or Voice only, no text appears whatever the entry says.
- **The file is patched like any other library.** Neither vanilla nor an expansion has a patch on it to copy from, but the diff follows the common rules of [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/), and the result shows on the Input Feedback Configuration page: Travel Mode gets a dropdown where it had "Unavailable".

The extension itself, its folder and `content.xml`, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/).

[↑ Contents](#toc)

## Reading on

[Catching input actions and states](/x4/modding-support/ui-modding/input-actions-and-states/) covers the ids of the inputs, the contexts they are active in and how an extension's Lua gets its own handler for them.

[colors.xml](/x4/modding-support/anatomy-of-game-data/libraries/colors-xml/) covers the named colours a feedback text can use.

[↑ Contents](#toc)

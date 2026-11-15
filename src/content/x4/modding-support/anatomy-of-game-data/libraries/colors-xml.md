---
title: colors.xml
description: How libraries/colors.xml defines the colours of the interface - the base colours with their alpha and glow, the mappings that give every interface feature its colour, and the colour-blindness transformations - how data files, texts, scripts and UI Lua refer to a colour, what the player can change in the options menu, and how an extension adds colours and mappings of its own.
---

# colors.xml

`libraries/colors.xml` is the colour table of the interface. The text colours of the menus, the faction colours, the colours of the map, the crosshair, the target elements and every widget are all named in this one file, and everything else refers to them by name. The file has two layers: **colours**, which say what a colour is, and **mappings**, which say which colour a feature of the interface uses. A third block holds the matrices of the colour-blind modes.

This article covers the format, the naming of the colours and mappings, how the rest of the game refers to them, what the player can change in the options menu, and how an extension adds its own. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Colour**: one `<color>` of the file, an id with red, green, blue, alpha and glow values.
- **Mapping**: one `<mapping>` of the file, an id that stands for one use of a colour, such as `text_error` or `faction_argon`, with a reference to the colour it uses. The options menu calls a mapping a **feature**.
- **Glow**: how strongly a colour glows on screen, from 0 to 1.
- **Daltonisation**: a correction that shifts colours so that they stay apart for a viewer with one of the forms of colour blindness.
- **Colour profile**: a set of colour changes a player saved under a name in the options menu.

[↑ Contents](#toc)

## How a colour is used

Whatever needs a colour by name asks for a **mapping id**. The mapping leads to a colour, and the colour gives the values:

```text
<color ref="faction_argon" />           in libraries/factions.xml
  -> <mapping id="faction_argon" ref="azure_dark_moderate_glow" />
    -> <color id="azure_dark_moderate_glow" r="0" g="105" b="179" a="255" glow="0.2" />
```

In vanilla the chain always has these two steps. The data files, the texts, the scripts and the UI Lua name mapping ids, not colour ids, and every mapping refers to a colour, not to another mapping.

The two layers serve two kinds of change. Changing a `<color>` changes every feature mapped to it at once. Pointing a `<mapping>` at another colour changes one feature and leaves the rest alone. The options menu offers both to the player, as described [below](#what-the-player-can-change).

[↑ Contents](#toc)

## The file

### Layout

```xml
<colormap>
  <daltonization>
    <transformation name="lms_trafo" type="rgb2lms">
      <long red="0.3905" green="0.07093" blue="0.02314"/>
      <middle red="0.5499" green="0.9631" blue="0.1280"/>
      <short red="0.008902" green="0.001358" blue="0.9361"/>
    </transformation>
    ...
  </daltonization>
  <colors>
    <color id="white" r="255" g="255" b="255" a="255"/>
    <color id="white_moderate_glow" r="255" g="255" b="255" a="255" glow="0.2"/>
    <color id="black_alpha_128" r="0" g="0" b="0" a="128"/>
    <color id="red_moderate_glow" r="255" g="0" b="0" a="255" glow="0.2"/>
    ...
  </colors>
  <mappings>
    <mapping id="text_normal" ref="white_weak_glow"/>
    <mapping id="text_error" ref="red_moderate_glow"/>
    <mapping id="faction_argon" ref="azure_dark_moderate_glow"/>
    ...
  </mappings>
</colormap>
```

The root is `<colormap>`, with one `<daltonization>`, one `<colors>` and one `<mappings>` block in that order. The mappings block is by far the longest: there are several mappings for every colour.

The schema, `libraries/colors.xsd`, documents every attribute.

[↑ Contents](#toc)

### Colours

| Attribute | Meaning |
| --- | --- |
| `id` | The colour id, which the mappings refer to. Letters, digits and underscores, not starting with a digit |
| `r`, `g`, `b` | The red, green and blue values, 0 to 255; default 0 |
| `a` | The alpha value, 0 for fully transparent to 255 for opaque; default 255 |
| `glow` | The glow value, 0.0 to 1.0; default 0 |

The vanilla ids follow a pattern that tells the values without looking them up:

- **A hue**: `white`, `black`, `grey_<n>` with the grey level as the number, and `red`, `orange`, `amber`, `yellow`, `green`, `cyan`, `azure`, `magenta`.
- **A brightness step** for the hues: `extra_dark`, `very_dark`, `dark`, none for the pure hue, `bright`, `very_bright`, `extra_bright`.
- **`alpha_<n>`** for a colour that is not opaque, with the alpha value as the number: `black_alpha_128`, `azure_dark_alpha_224`.
- **A glow word** at the end: `weak_glow` for 0.05, `moderate_glow` for 0.2, `glow` for 0.5 and `strong_glow` for 1.0.

So `azure_dark_alpha_160_glow` is the dark azure at alpha 160 with a glow of 0.5. The pattern is a convention of the file and the values are what counts: two `weak_glow` colours carry 0.02, with a comment in the file that 0.05 was too much.

The palette is wider than its use. A part of the colours has no mapping pointing at it; they are there to be picked.

[↑ Contents](#toc)

### Mappings

| Attribute | Meaning |
| --- | --- |
| `id` | The mapping id, which the rest of the game refers to |
| `ref` | The id of the colour the mapping uses |

The first word of a mapping id names the part of the interface it belongs to. The larger groups:

| Prefix | What it colours |
| --- | --- |
| `text_` | Text in menus by its meaning: `text_normal`, `text_lowlight`, `text_inactive`, `text_error`, `text_warning`, `text_positive`, `text_negative`, the relation colours `text_player`, `text_ally`, `text_enemy`, `text_hostile`, and text of missions, prices, skills, boarding and notifications |
| `icon_` | Icons by their meaning: normal, inactive, error, warning, mission, positive, negative |
| `faction_` | One colour per faction, the ones `libraries/factions.xml` refers to |
| `holomap_` | The map: sectors, orders, selection, the build and equipment views, the transform gizmo. The largest group |
| `crosshair_`, `targetsystem_`, `targetmonitor_`, `compass_`, `weaponpointer_` | The flight interface: crosshair, target elements, target monitor, compass and weapon pointer |
| `button_`, `row_`, `table_`, `dropdown_`, `slider_`, `checkbox_`, `editbox_`, `scrollbar_`, `frame_`, `graph_`, `flowchart_`, `statusbar_` | The widgets menus are built from, each with its background, highlight, border and inactive colours |
| `resource_` | The resources: their colour in scans, on asteroid nodes, as icons and in the resource view of the map |
| `messageticker_`, `playeractivity_`, `dockui_`, `chatuser_`, `loadingscreen_` | The message ticker, the mode displays (travel, scan, SETA), the docking interface, chat names and the loading screen |
| `mapblip_`, `highlight_` | The blips effects put on the map, and the outline and fill of highlighted and scanned objects |

A mapping id says what the colour is for, not what it looks like: `text_warning` stays the id whatever colour warnings have. Smaller groups exist for single menus and displays.

[↑ Contents](#toc)

### Daltonisation

The `<daltonization>` block holds six `<transformation>` elements, each a 3 x 3 matrix:

| `name` | `type` | What it does |
| --- | --- | --- |
| `lms_trafo` | `rgb2lms` | Converts a colour from red, green and blue to the long, middle and short wavelength responses of the eye |
| `rgb_trafo` | `lms2rgb` | The inverse, back to red, green and blue |
| `protanopia`, `deuteranopia`, `tritanopia` | `lms2lms` | Simulates how the colour looks with that form of colour blindness |
| `error_correction` | `rgb2rgb` | Spreads the difference between the defined and the simulated colour over the channels, which gives the corrected colour |

A transformation has three row elements named after the components it produces, `<red>`, `<green>`, `<blue>` or `<long>`, `<middle>`, `<short>`, and each row has three attributes named after the components it reads, each a coefficient between -10 and 10.

The three simulation names are the modes of the colour-blind option. As the comments in the file describe it, a colour goes through the chain: to the eye's responses, through the simulation of the chosen mode and back, and the difference between the defined and the simulated colour is then applied to the colour through `error_correction`, which also scales the effect. The comments name the sources of the matrices and note that the tritanopia values could be adjusted further.

[↑ Contents](#toc)

## How the rest of the game refers to a colour

| Where | Form |
| --- | --- |
| `libraries/factions.xml` | `<color ref="faction_argon"/>` in a faction |
| `libraries/parameters.xml` | Colour attributes throughout the interface sections, such as `color`, `goodcolor`, `badcolor`, `mapcolor`, `inactivecolor`. The schema marks them "referenced from libraries/colors.xml" |
| `libraries/effects.xml` | `<mapblip color="mapblip_good"/>` in an effect |
| Texts | `\033#text_error#` starts text in that colour and `\033X` ends it |
| MD and AI scripts | The cells of `show_overlay_text` take a mapping id as a string in `textcolor`, `iconcolor`, `bgcolor` and `flashcolor`. A list `[r, g, b, a]` is the older form |
| UI Lua | The global tables `Color` and `ColorText`, keyed by mapping id |

All of these name mapping ids.

[↑ Contents](#toc)

### The Lua side

The widget system fills two global tables from the colour table when the interface starts:

| Table | What an entry holds |
| --- | --- |
| `Color["text_error"]` | A table with `r`, `g`, `b`, `a` and `glow`, the form every widget property that takes a colour expects |
| `ColorText["text_error"]` | A string, the escape sequence that switches inline text to that colour. `"\27X"` ends it |

```lua
row[1]:createText(name, { color = Color["text_inactive"] })
row[2]:createText(ColorText["text_warning"] .. warning .. "\27X " .. details)
```

Three details matter when working with them:

- **Only mappings are in the tables.** A colour id such as `red_moderate_glow` is not a key. Asking for an id that is not there writes "Color setup error: Tried to access non-existing color" with the id to the log and gives a half-transparent magenta in its place, which makes a wrong id easy to spot on screen.
- **Alpha has another scale in Lua.** The file gives `a` from 0 to 255; in a `Color` entry it runs from 0 to 100.
- **The tables are filled when the interface starts.** A feature pointed at another colour in the options menu keeps its old `Color` entry in the running game and has the new one after a restart, which is what the restart notice of that page is about. The widget code can also refill the tables on a signal from the game, so a script that reads `Color[...]` at the time it builds a menu is on the safe side; a copy of the values kept from the start is not.

[↑ Contents](#toc)

## What the player can change

The options menu has a page for this file: Settings, Accessibility Settings, Colour-Blind Options. It shows the table as it is loaded:

- **Colour-Blind Mode** and **Colour-Blind Correction Strength**: one of the three modes or none, and how strongly the correction is applied.
- **Colours**: every colour id with a sample and an edit button, which opens sliders for red, green, blue, alpha and the glow factor. A new colour id can be added, and an added one can be deleted again while no feature uses it.
- **Features**: every mapping id with a sample and a dropdown of all colour ids, to point the feature at another colour. Both lists have a search field.
- **Colour profiles**: the changes can be saved under a name, loaded and overwritten. The profiles are kept in the `colorprofile` folder of the player's personal folder.
- **Apply** and **Restore Defaults**. Where a change needs it, the page shows that a restart is required for all changes to take effect.

The applied changes are saved in a `colors.xml` in the player's personal folder. It has the same `<colormap>` root as the game's file and holds only the colours and mappings the player changed or added. The game also writes the vanilla daltonisation matrices into it as a comment, with the note that they can be overridden there. Restore Defaults removes the file.

The page's own explanation states that manually adjusted colours are not affected by the colour-blind mode.

Because the lists are read from the loaded table, the page is also the quickest way to look through the colours and mappings with their real appearance, glow included. How the glow is drawn depends on two graphics options, UI Glow Quality and UI Glow Intensity.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships a `colors.xml`. The base file already holds the mappings the expansions need: the `faction_` colours of the factions an expansion adds are in it, and the expansion's `factions.xml` refers to them.

[↑ Contents](#toc)

## Adding colours and mappings from an extension

An extension changes the file with a diff. The example below, for a fictional extension `example_colors`, adds one colour and two mappings, points one vanilla feature at another colour, and uses the new mappings in a text and in Lua.

`libraries/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/colormap/colors">
    <color id="example_teal_glow" r="0" g="200" b="170" a="255" glow="0.5" />
  </add>
  <add sel="/colormap/mappings">
    <mapping id="example_text_highlight" ref="example_teal_glow" />
    <mapping id="example_text_muted" ref="grey_128" />
  </add>
  <replace sel="/colormap/mappings/mapping[@id='mapblip_bad']/@ref">red_moderate_glow</replace>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example colours" descr="" voice="no">
    <t id="1">Reactor status: \033#example_text_highlight#stable\033X</t>
    <t id="2">No further data</t>
  </page>
</language>
```

In a menu of the extension's UI Lua:

```lua
row[1]:createText(ReadText(1234567, 1))
row[2]:createText(ReadText(1234567, 2), { color = Color["example_text_muted"] })
```

Some points about the example:

- **The ids carry a prefix.** Colour ids and mapping ids are shared with the game and with every other extension, so a prefix of the extension's own keeps them apart.
- **The new colour follows the naming pattern**: `_glow` at the end for a glow of 0.5. Nothing checks it, but it keeps the id readable in the dropdown of the options menu.
- **A mapping does not need a colour of its own.** `example_text_muted` uses the vanilla `grey_128`. For most needs the vanilla palette is enough and the diff adds mappings only.
- **Texts and Lua name the mapping, not the colour.** In Lua the colour id is not available at all, and the mapping keeps the feature adjustable: it appears under Features in the Colour-Blind Options, where a player can point it at another colour.
- **The `<replace>` changes one feature.** The blip of that kind turns from white to red and nothing else changes. Editing the `<color>` it pointed at would recolour every feature mapped to that colour.
- **A player's own choice stands before the extension's.** Where the player has pointed `mapblip_bad` at a colour in the options menu, that choice stays; the `<replace>` sets the default, and Restore Defaults returns to it, not to the vanilla value.
- **A text sets its colour in two ways.** Text 1 carries the colour inside, for a part of the line, and ends it with `\033X`; text 2 is plain and gets its colour from the widget.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) covers the faction entry whose `<color>` refers to a `faction_` mapping, or gives a colour inline.

[parameters.xml](/x4/modding-support/anatomy-of-game-data/libraries/parameters-xml/) covers the sections whose colour attributes refer to this file.

[↑ Contents](#toc)

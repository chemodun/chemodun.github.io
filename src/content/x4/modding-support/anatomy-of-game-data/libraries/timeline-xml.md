---
title: timeline.xml
description: How libraries/timeline.xml defines the Timeline page of the encyclopedia - the dated history entries, their text, voice and video, the grouping on the page, the calendars the date is shown in, how an entry becomes visible to the player, the script side, and how an extension adds an entry of its own.
---

# timeline.xml

The encyclopedia has a **Timeline** page: a vertical line of dated events, from the first jump gates built at Earth to the stabilisation of the gate network, each with a short text, a spoken version of it and a video. Which events exist, when they happened, how they are grouped on the page and which text, voice and video belong to each is defined in `libraries/timeline.xml`. The entries start hidden; the player uncovers them one at a time, in vanilla by opening the data vaults scattered through the galaxy.

This article covers the format, how an entry reaches the player, how the page shows it, the script side and how an extension adds an entry. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Entry**: one event of the timeline, one `<entry>` of the file, identified by its `id`.
- **Known entry**: an entry the player has uncovered. The game keeps the set of known entries per save as part of the player's encyclopedia; an entry that is not known is a bare dot on the line.
- **Read entry**: a known entry the player has selected at least once. Until then the page marks it as new.
- **Data vault**: a landmark object with a data leak on it; scanning or repairing the leak uncovers one entry. Vanilla's entries are uncovered this way.
- **Calendar**: the page shows the year in one of four calendars, picked from a dropdown: New Time (NT), Anno Domini (AD), Human Era (HE) and Zuran Time (ZT). The file stores NT.
- **Voice sequence**: a spoken line defined in `libraries/voicesequences.xml`; an entry names one by id.
- **Cutscene key**: the name of a cutscene definition; an entry's video is one.

[↑ Contents](#toc)

## How the timeline reaches the player

The page lives in the encyclopedia menu, under the Timeline entry of its sidebar. It lists every entry of the file, sorted by date, one row each, with a gap between groups. A known entry shows its date and name, with a "New Entry" mark until it has been selected once; an entry that is not known shows only the dot on the line, so the player sees how many events there are and where the gaps in their knowledge sit.

Selecting a known entry plays it: the right side of the page holds a 16:9 panel in which the entry's video runs, the voice sequence starts a moment later, and the description is printed below. An entry without a video shows its image in the panel instead, and without an image the page's own placeholder picture.

An entry becomes known in one of three ways:

1. **A script adds it to the encyclopedia** with `add_encyclopedia_entry type="timeline"`. Vanilla's data vaults do this: `md/placedobjects.xml` places the vaults with a data leak each, and when the player scans or repairs a leak, the cue for that vault adds its entry, shows a notification, marks the vault unlocked and signals the player entity with `datavault_unlocked`. The number of unlocked vaults is also written to the user data state `known_timeline_unlock`, which the custom game start counts towards its budget.
2. **The game start lists it.** A `<gamestart>` in `libraries/gamestarts.xml` may carry a `<timeline>` block under `<player>`, one `<entry ref="..."/>` per entry the new game begins with. Vanilla uses it only in the test starts, which begin with the last entry known.
3. **The player collects it.** The schema of `libraries/drops.xml` has a `<data>` collectable with a `timeline` attribute, and crates, lockboxes and collectable data objects expose the entry ids they carry; picking such an object up raises `event_player_collected_data` with the type and the id. Vanilla's drops define no data collectables, so this path is defined but unused in the base game.

[↑ Contents](#toc)

## The file

### Layout

```xml
<timeline>
  <entry id="earth_jumpgates" name="{20299, 1261}" description="{20299, 1262}" date="-128.0" group="1"
         voice="timeline_earth_jumpgates" video="timeline_earth_jumpgates" />
  <entry id="winterblossom" name="{20299, 1171}" description="{20299, 1172}" date="-124.0" group="1"
         voice="timeline_winterblossom" video="timeline_winterblossom" />

  <entry id="terraformer_project_starts" name="{20299, 1101}" description="{20299, 1102}" date="-104.0" group="2"
         voice="timeline_terraformer_project_starts" video="timeline_terraformer_project_starts" />
  ...
</timeline>
```

The file is a flat list of `<entry>` elements under the root; there is nothing else in it. Vanilla's entries all follow the pattern above: name and description from text page `20299`, a voice sequence and a cutscene named `timeline_<id>`, no image. The order in the file does not matter to the page, which sorts by date, but vanilla keeps the file in date order with a blank line between groups.

The schema, `libraries/timeline.xsd`, is short and documents every attribute.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The entry's id, the key scripts, drops and game starts refer to it by |
| `name` | The title shown in the list and spoken first; a text reference |
| `description` | The text printed under the video and spoken after the name |
| `image` | A picture shown in the panel when the entry has no video, as a UI icon id. Vanilla sets none, and the page falls back to `ency_timeline_empty_01` |
| `video` | The cutscene key played in the panel while the entry is selected |
| `voice` | The id of the voice sequence played with it |
| `container` | The macro of the collectable data container for the entry, per the schema. Vanilla sets none |
| `date` | A number whose integer part is the year in NT and whose fraction orders entries within a year |
| `group` | An integer; entries with the same group sit together on the page, with a gap before the next group |

Every attribute is optional in the schema. An attribute left out behaves as an empty string: vanilla leaves `image` out everywhere and the page tests it against the empty string.

[↑ Contents](#toc)

### Dates and calendars

`date` is stored in New Time, the calendar of the Community of Planets; the years before it are negative, which is how the Earth entries sit at the top. Only the integer part is displayed. The fraction orders entries that share a year: vanilla gives the arrival of Kyle Brennan `742.1` to place it after the Xenon evolution at `742.0`, and the three events of year 763 the fractions `.0`, `.1` and `.2`.

The page converts the year into the calendar chosen in its dropdown with a fixed offset:

| Calendar | Shown as |
| --- | --- |
| NT, New Time | the year as stored |
| AD, Anno Domini | the year plus 2170 |
| HE, Human Era | the year plus 12170 |
| ZT, Zuran Time | the year minus 200 |

The texts of the entries quote dates in their own words and are not converted; an entry's description may well name the AD year while the list shows NT.

[↑ Contents](#toc)

### Groups

`group` controls the spacing of the page and nothing else. The list is sorted by date and a gap row is inserted whenever the group number changes from one row to the next, so groups should follow the date order; vanilla numbers them from 1 at the top to 12 at the bottom. Two entries with the same group number but other groups' dates between them would be split by the gaps around those.

[↑ Contents](#toc)

### Voice and video

The **voice** names a `<voicesequence>` in `libraries/voicesequences.xml`. Vanilla's timeline sequences all have the same shape: they speak the name line, wait two seconds and speak the description line, both with subtitles turned off, from the same text page the entry's texts come from. The page starts the sequence on the player's ship computer about a second after the entry is selected and stops it when another entry is selected or the menu closes. The sequence needs recorded audio for its lines; a text alone is not spoken.

The **video** is a cutscene key. Vanilla's are files `cutscenes/timeline_<id>.xml` in the game catalogs, each a one-shot cutscene whose only action is to play the video file `videos/timeline_<id>.mkv`; the videos themselves are plain files in the `videos` folder of the installation, not packed in a catalog. The page plays the cutscene into its render target and the cutscene events of the script side fire for it, which is how vanilla's advanced tutorial waits for the player to open the Timeline and for the first entry's video to start.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships a `timeline.xml`; the base file is the whole timeline, and the expansions' stories do not add to it. The word also appears in another sense: the Timelines expansion's scenarios are called timelines in the scripts and the game options, and have nothing to do with this file or the encyclopedia page.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `add_encyclopedia_entry type="timeline" item="..."` | Makes an entry known to the player; `item` is the entry id as a string expression. Vanilla calls it whether or not the entry is already known and tracks the newness itself, in user data |
| `remove_encyclopedia_entry type="timeline" item="..."` | Takes it away again |
| `player.encyclopedia.timeline.{$id}.exists` | Whether the player knows the entry |
| `player.encyclopedia.timeline.{$id}.name`, `.rawname`, `.description`, `.image`, `.video`, `.videomacro` | The entry's attributes as the player sees them |
| `player.encyclopedia.timeline.{$id}.voice`, `.date`, `.group` | The voice sequence id, the date as a number and the group; these three exist for timeline and audio log entries only |
| `event_player_collected_data` | The player picked up a data collectable: `param` is the type, `timeline` or `audiolog`, `param2` the entry id; the condition takes `type` and `id` to narrow it |
| `add_data object="..." timeline="..."`, `remove_data` | Adds one entry id or a list of ids to a collectable, a crate or a lockbox, or removes them |
| `$crate.timeline`, `$lockbox.timeline`, `$collectabledata.timeline` | The timeline entry ids a crate, lockbox or collectable data object carries, as a list |
| `<data timeline="..."/>` in `libraries/drops.xml` | A collectable data drop carrying an entry, or a `<select>` list of them by weight; `audiolog` is the alternative and `timeline` wins when both are given |
| `<timeline><entry ref="..."/></timeline>` in `libraries/gamestarts.xml` | Entries known from the start of a new game, under `<player>` |
| `event_cutscene_started`, `event_cutscene_stopped` with `key` | The entry's video began or ended in the page, by its cutscene key |

The entries in the file define what can be known; the script side decides when. Vanilla keeps the two apart by giving every entry a data vault of its own, so a player who finds all the vaults has the complete timeline.

[↑ Contents](#toc)

## Adding an entry from an extension

A new entry is a diff on `libraries/timeline.xml`, two texts, and a script that makes it known at the right moment, since nothing in the game uncovers an unknown entry on its own. The example below, for a fictional extension `example_timeline`, adds an event after the last vanilla one and uncovers it when the player's ship first arrives in Argon Prime.

`libraries/timeline.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/timeline">
    <entry id="example_guild_founded" name="{1234567,1}" description="{1234567,2}" date="823.0" group="13" />
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example timeline" descr="" voice="no">
    <t id="1">Founding of the Example Trading Guild</t>
    <t id="2">In 823 NT the independent traders of Argon Prime formed a guild of their own, pooling their freighters under one charter and one set of prices.\n\nThe guild's first act was to open a joint office at the Argon Prime Trading Station.</t>
  </page>
</language>
```

`md/example_timeline.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Timeline" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Unlock_Guild_Founded">
      <conditions>
        <event_object_changed_sector object="player.entity"/>
        <check_value value="event.param.macro == macro.cluster_14_sector001_macro"/>
      </conditions>
      <actions>
        <add_encyclopedia_entry item="'example_guild_founded'" type="timeline"/>
        <show_notification text="{1015,189}"/>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The date places the entry**, not the position in the file. `823.0` sorts it after the vanilla gate stabilisation of 820, and the new group number `13` gives it a gap of its own below the last vanilla group. An entry meant to sit among vanilla's events takes a date between theirs and the group number of its neighbours.
- **No video, voice or image.** The panel shows the placeholder picture and the description is printed, not spoken. A voice needs a `<voicesequence>` with recorded lines in `libraries/voicesequences.xml`; a video needs a cutscene key the game can resolve. Both are outside what a text-only extension can supply.
- **The cue fires once.** A cue without `instantiate` completes after its actions, so the entry is added on the first arrival only. Vanilla's own `event_object_changed_sector` conditions on the player use `player.entity`, and `event.param` is the sector arrived in.
- **The notification is vanilla's.** Text `{1015,189}` is the "New entry added to Timeline." line the data vaults show, so the new entry announces itself the same way as the existing ones.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) covers the `<player>` block of a game start, where the `<timeline>` list of known entries sits.

[drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) covers the drop lists in which a `<data>` collectable carrying an entry would be defined.

[voicesequences.xml](/x4/modding-support/anatomy-of-game-data/libraries/voicesequences-xml/) covers the voice sequences an entry's `voice` names: their steps, the text page behind a spoken line and its recording.

[audiologs.xml](/x4/modding-support/anatomy-of-game-data/libraries/audiologs-xml/) covers the audio logs, the second kind of entry in this format, which the base game defines but leaves empty.

[↑ Contents](#toc)

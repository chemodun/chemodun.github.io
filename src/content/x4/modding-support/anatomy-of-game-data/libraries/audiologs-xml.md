---
title: audiologs.xml
description: How libraries/audiologs.xml is meant to define audio logs - recorded messages the player finds as collectable data - with the entry format it shares with the Timeline, the data container, the drop and script elements that carry an audio log, the encyclopedia type behind it, what the base game does and does not provide, and how an extension defines a log and plays it.
---

# audiologs.xml

An **audio log** is a recorded message the player comes across: a data container floating in space, picked up, and a voice telling its story. The game has the parts for it: the entry file `libraries/audiologs.xml` with its schema, a data container with a ping that announces it, drop and script elements that put a log into a container, an event for the pickup and an encyclopedia type that remembers which logs the player has. The file itself is empty in the base game and in every expansion, and the interface has no page that lists the logs. What plays a log and what shows it is left to scripts.

This article covers the format, the parts the game provides, the script side and how an extension defines a log. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Audio log**: one `<entry>` of the file, identified by its `id`.
- **Collectable data**: a collectable object that carries entry ids instead of wares. The entries are audio logs or Timeline entries.
- **Known entry**: an entry the player's encyclopedia holds. The game keeps the known audio logs per save under the encyclopedia type `audiologs`.
- **Voice sequence**: a named list of spoken lines and pauses from `libraries/voicesequences.xml`. An audio log names one as its recording.

[↑ Contents](#toc)

## What the game provides

Audio logs and Timeline entries are built on the same mechanism. The two files have the same entry format, the script elements take either kind, and the data container holds either. The difference is in what the base game does with them: the Timeline has its entries, its data vaults and its page in the encyclopedia, and the audio logs have the mechanism alone.

| Part | For audio logs |
| --- | --- |
| The entry file | `libraries/audiologs.xml`, empty |
| The schema | `libraries/audiologs.xsd`, the same entry attributes as the Timeline's |
| A data container | The macro `sm_gen_audiolog_01_macro` of class `collectabledata`, whose component carries the sound `notification_audiolog_ping`, described in the sound library as the notification of a nearby audio log |
| A drop element | `<data audiolog="..."/>` inside a `<collectable>` of `libraries/drops.xml` |
| Script actions | `add_data` and `remove_data` put entries into a collectable, a crate or a lockbox and take them out |
| A pickup event | `event_player_collected_data`, with the type `audiolog` and the entry id |
| An encyclopedia type | `audiologs`, for `add_encyclopedia_entry` and `player.encyclopedia.audiologs.{$id}` |
| A menu page | None. No menu of the base game lists or plays audio logs |

[↑ Contents](#toc)

## The file

### Layout

The vanilla file is the root element and nothing else:

```xml
<audiologs>
</audiologs>
```

By the schema it is a flat list of `<entry>` elements, in the form of the Timeline's:

```xml
<audiologs>
  <entry id="..." name="{page,id}" description="{page,id}" voice="..." date="..." group="..." />
</audiologs>
```

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The entry's id, the key drops and scripts refer to it by |
| `name` | The title of the log, a text reference |
| `description` | The text of the log |
| `image` | A picture for the entry |
| `video` | A video for the entry |
| `voice` | The id of the voice sequence that is the log's recording |
| `container` | The macro of the collectable data container for the entry |
| `date` | A number whose integer part is a year and whose fraction orders entries within a year |
| `group` | A group number, described as controlling the spacing of entries |

Every attribute is optional in the schema. The descriptions are those of the Timeline schema word for word, including `date` and `group`, which the Timeline page uses to sort and space its rows. Nothing reads them for an audio log in 9.00 apart from the script properties below.

[↑ Contents](#toc)

## How a log can reach the player

Three routes exist, the same three a Timeline entry has:

1. **A data drop.** A drop in `libraries/drops.xml` can hold a data collectable, `<collectable><data audiolog="..."/></collectable>`, naming one entry or a weighted `<select>` list of them. Its `timeline` attribute is the alternative, and wins when both are given.
2. **A script fills a container.** `add_data object="..." audiolog="..."` adds one entry id or a list of them to a collectable, a crate or a lockbox. The ids an object carries are readable as `$object.audiologs`.
3. **A script adds the entry directly** to the encyclopedia with `add_encyclopedia_entry type="audiologs"`.

When the player collects data, `event_player_collected_data` fires with `param` set to the type, `audiolog` here, and `param2` to the entry id. What happens then is up to the script that listens: since no menu shows audio logs, a log that should be heard needs a script to play its voice sequence, and one that should be read needs a script to show its text.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships an `audiologs.xml`, and no vanilla drop list or script uses the audio log elements.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `add_encyclopedia_entry type="audiologs" item="..."` | Makes a log known to the player; `item` is the entry id as a string expression |
| `remove_encyclopedia_entry type="audiologs" item="..."` | Takes it away again |
| `player.encyclopedia.audiologs.{$id}.exists` | Whether the player knows the log |
| `player.encyclopedia.audiologs.{$id}.name`, `.rawname`, `.description`, `.image`, `.video` | The entry's texts and media |
| `player.encyclopedia.audiologs.{$id}.voice`, `.date`, `.group` | The voice sequence id, the date and the group; these three exist for Timeline and audio log entries only |
| `add_data object="..." audiolog="..."` | Adds one entry id or a list of ids to a collectable, a crate or a lockbox. With `timeline` given too, the `audiolog` attribute is ignored |
| `remove_data object="..." audiolog="..."` | Removes them |
| `$crate.audiologs`, `$lockbox.audiologs`, `$collectabledata.audiologs` | The audio log ids the object carries, as a list |
| `event_player_collected_data` | The player picked up data: `param` is the type, `param2` the entry id; the condition takes `type` and `id` to narrow it |
| `<data audiolog="..."/>` in `libraries/drops.xml` | A collectable data drop carrying a log, or a `<select>` list of them by weight |
| `play_voice_sequence sequence="..."` | Plays a voice sequence, which is how a script lets a log be heard |

[↑ Contents](#toc)

## Adding a log from an extension

An audio log takes an entry, a voice sequence for its recording, and a script that plays it. The example below, for a fictional extension `example_audiolog`, defines one log and lets the ship computer read it when the player first arrives in Argon Prime. A second cue plays any audio log the player collects from a data container, the example's own or another extension's. The recording is borrowed: the sequence speaks two lines of the Timeline page that the base game has audio for.

`libraries/audiologs.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/audiologs">
    <entry id="example_gate_log" name="{1234567,1}" description="{1234567,2}" voice="example_gate_log" date="820.5" group="1" />
  </add>
</diff>
```

`libraries/voicesequences.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/voicesequences">
    <voicesequence id="example_gate_log" page="20299">
      <delay time="1.5" />
      <speak line="1251" />
      <delay time="1" />
      <speak line="1252" />
    </voicesequence>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example audio logs" descr="" voice="no">
    <t id="1">Audio Log: The Gates Hold</t>
    <t id="2">A recording made in the year the gate network was declared stable.</t>
  </page>
</language>
```

`md/example_audiolog.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Audiolog" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Find_Gate_Log">
      <conditions>
        <event_object_changed_sector object="player.entity"/>
        <check_value value="event.param.macro == macro.cluster_14_sector001_macro"/>
      </conditions>
      <actions>
        <add_encyclopedia_entry item="'example_gate_log'" type="audiologs"/>
        <play_voice_sequence sequence="player.encyclopedia.audiologs.{'example_gate_log'}.voice" entity="player.computer"/>
        <show_notification text="player.encyclopedia.audiologs.{'example_gate_log'}.name"/>
      </actions>
    </cue>
    <cue name="Play_Collected_Log" instantiate="true">
      <conditions>
        <event_player_collected_data type="'audiolog'"/>
      </conditions>
      <actions>
        <add_encyclopedia_entry item="event.param2" type="audiologs"/>
        <do_if value="player.encyclopedia.audiologs.{event.param2}.voice">
          <play_voice_sequence sequence="player.encyclopedia.audiologs.{event.param2}.voice" entity="player.computer"/>
        </do_if>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The entry is read through the encyclopedia.** The script does not repeat the voice sequence id or the text: it asks the encyclopedia for the entry's `voice` and `name`, so the file stays the one place where the log is defined.
- **The first cue is the direct route**, without a container: it adds the entry and plays it. It fires once, as a cue without `instantiate` does.
- **The second cue is the pickup route.** It adds the collected entry to the encyclopedia itself, and plays it when the entry names a voice sequence.
- **A container for the log** is a drop of the data container macro with the log as its content, by the drops schema `<drop macro="sm_gen_audiolog_01_macro"><collectable><data audiolog="example_gate_log"/></collectable></drop>` in a drop list, or a collectable a script fills with `add_data`.
- **A recording of its own** needs a text page and audio files for the spoken lines, as the voice sequences article describes.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[timeline.xml](/x4/modding-support/anatomy-of-game-data/libraries/timeline-xml/) covers the file with the same entry format that the base game does use, and the encyclopedia page built on it.

[voicesequences.xml](/x4/modding-support/anatomy-of-game-data/libraries/voicesequences-xml/) covers the voice sequences a log's `voice` names, and what a spoken line needs.

[drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) covers the drop lists in which a data collectable is defined.

[↑ Contents](#toc)

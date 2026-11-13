---
title: voicesequences.xml
description: How libraries/voicesequences.xml defines the game's voice sequences - named lists of spoken lines and pauses, the text page that supplies both the subtitle and the recording, priorities and subtitles, where the game starts and the Timeline use them, the script action that plays one, and how an extension adds a sequence of its own.
---

# voicesequences.xml

A **voice sequence** is a short script for the voice channel: speak this line, wait two seconds, speak that one. The game uses them where a fixed piece of narration belongs to something that is not a conversation: the voice over a game start's preview and intro, and the narration of each Timeline entry. Each sequence has an id, and `libraries/voicesequences.xml` is the list of them. The other files refer to a sequence by that id, and a script can play one directly.

This article covers the format, how a line becomes sound, where the sequences are used, the script side and how an extension adds a sequence. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Voice sequence**: one `<voicesequence>` of the file: an id and an ordered list of `<speak>` and `<delay>` steps.
- **Line**: one text of a text page, addressed by page id and line id. A spoken line is the same text entry the subtitle comes from.
- **Voice page**: a text page marked `voice="yes"` in the `t` files. Its lines have recordings; most such pages hold the lines of one voice, such as one NPC voice of a race.
- **Recording**: the audio file of a line, stored per language, page and line.
- **Priority**: a number that decides which speech wins when two want the voice channel; conversations use 100.

[↑ Contents](#toc)

## How a sequence is played

Nothing plays a sequence on its own. Something names it by id and starts it, and the game then walks the steps in order: a `<delay>` waits, a `<speak>` plays the recording of its line and shows the line as a subtitle unless subtitles are turned off for it.

Three places start sequences in vanilla:

1. **The New Game menu, on selection.** A game start's `<cutscene>` in `libraries/gamestarts.xml` carries a `voice` attribute. When the preview cutscene of the selected start begins, the menu starts that sequence with it.
2. **The New Game menu, on start.** The game start's `<intro>` carries a `voice` as well, started together with the intro animation after the player confirms the start.
3. **The Timeline page of the encyclopedia.** Each entry of `libraries/timeline.xml` names a sequence in its `voice` attribute, started about a second after a known entry is selected, with the ship computer as the speaker.

The menus stop the running sequence when the selection changes or the menu closes. A script can start a sequence with `play_voice_sequence`; no vanilla script does.

[↑ Contents](#toc)

## The file

### Layout

```xml
<voicesequences>
  <voicesequence id="gamestart1_selected" page="10101">
    <delay time="1.5" />
    <speak line="99901" />
  </voicesequence>
  <voicesequence id="gamestart1_started" page="10101">
    <delay time="2.5" />
    <speak line="99902" />
  </voicesequence>
  ...
  <voicesequence id="timeline_earth_jumpgates" page="20299">
    <speak line="1261" nosubtitles="true" />
    <delay time="2" />
    <speak line="1262" nosubtitles="true" />
  </voicesequence>
  ...
</voicesequences>
```

The file is a flat list of `<voicesequence>` elements. Each holds any number of `<speak>` and `<delay>` children in any order, and they run in the order written.

Vanilla's sequences come in two families:

- **Game start sequences**, in pairs named `<start>_selected` and `<start>_started`. Each waits a moment and speaks one line: by convention line `99901` of the narrator's voice page for the selection and `99902` for the start. With the pause, the voice comes in after the cutscene or the intro animation has begun.
- **Timeline sequences**, named `timeline_<entry id>`. Each speaks the entry's name, waits two seconds and speaks the description, both from text page `20299` and both with subtitles off, since the page already shows the text.

The schema, `libraries/voicesequences.xsd`, documents every attribute.

[↑ Contents](#toc)

### Attributes

On `<voicesequence>`:

| Attribute | Meaning |
| --- | --- |
| `id` | The sequence id, required: letters, digits and underscores, not starting with a digit. It is what the other files and scripts refer to |
| `page` | The default text page for the `<speak>` steps |
| `priority` | The default priority for the `<speak>` steps; without it they speak at the conversation priority of 100 |
| `filter` | The default voice filter override for the `<speak>` steps |

On `<speak>`:

| Attribute | Meaning |
| --- | --- |
| `line` | The line id on the text page, required |
| `page` | The text page, when it differs from the sequence's default or the sequence has none |
| `priority` | The priority of this line, overriding the sequence's default. A priority of -50 or lower suppresses the subtitle |
| `nosubtitles` | `true` turns the subtitle off for this line; the default is to show it |
| `filter` | The voice filter override for this line |

On `<delay>`:

| Attribute | Meaning |
| --- | --- |
| `time` | The length of the pause in seconds, required; fractions are allowed |

Vanilla uses `id`, `page`, `line`, `nosubtitles` and `time` only. No vanilla sequence sets a priority or a filter.

[↑ Contents](#toc)

### Lines, pages and recordings

A `<speak>` step names a text, not a sound file. The page and line address an entry of the `t` files, and the same pair addresses the recording: the audio of line `99901` on page `10101` in English is `voice-l044/10101/.../99901.ogg` in the game catalogs, where `044` is the language id, the next folder is the page and the file name is the line.

Two things follow from that:

- **The page decides whose voice is heard.** Page `10101` holds the lines of one Argon male voice, so a sequence that speaks from it sounds like that character. The game start sequences each point at the page of the start's narrator; the Timeline sequences point at the Timeline's own page.
- **The text and the sound are separate assets.** The text entry supplies the subtitle and the recording supplies the sound. A new spoken line therefore needs both: the text, and an audio file at the matching place for every language it should be heard in.

A sequence may mix pages: the `page` on a `<speak>` overrides the sequence's default for that step, which is how one vanilla sequence speaks four lines from the Timeline page and closes with a line from a mission character's voice page.

[↑ Contents](#toc)

### Timing

The steps run one after another: a `<delay>` placed between two `<speak>` steps is the pause between the two lines, and a `<delay>` at the top postpones the first line. Vanilla's game start sequences open with a pause of a second and a half for the selection and two and a half for the start, and the Timeline sequences leave two seconds between the title and the body.

When a script plays a sequence, its `realtime` attribute decides how the delays are counted: in real time by default, or in game time.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships a `voicesequences.xml`. The base file already holds the sequences of the expansions' game starts, and the base `t` file holds their voice pages; the expansions' own `gamestarts.xml` files refer to those ids.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `play_voice_sequence sequence="..."` | Starts a sequence; `sequence` is the id as a string expression. Available in MD and AI scripts |
| `play_voice_sequence entity="..."` | The speaker entity; without it a dummy entity speaks |
| `play_voice_sequence realtime="..."` | Whether the delays run in real time, the default, or in game time |
| `<cutscene voice="...">`, `<intro voice="...">` in `libraries/gamestarts.xml` | The sequences of a game start's preview and intro; the attribute forms `cutscenevoice` and `introvoice` on the `<gamestart>` do the same |
| `voice="..."` on an `<entry>` of `libraries/timeline.xml` | The sequence of a Timeline entry |
| `player.encyclopedia.timeline.{$id}.voice` | The sequence id of a Timeline entry, as a string |
| `speak` | The script action for a single line by an actor, with its own page, line, priority and options; a sequence is the fixed, data-defined form of several of these |

There is no script action that stops a sequence and no event for its end. A script that needs to react when a line finishes, or to choose lines at run time, is better served by `speak`, which has `event_speak_finished` on its side.

[↑ Contents](#toc)

## Adding a sequence from an extension

A new sequence is a diff on `libraries/voicesequences.xml` and something that plays it. The example below, for a fictional extension `example_voice`, defines a sequence out of two lines the game already has recordings for, the title and the text of the last Timeline entry, and has the ship computer read them whenever the player arrives in Argon Prime. It needs no text and no audio of its own.

`libraries/voicesequences.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/voicesequences">
    <voicesequence id="example_gate_report" page="20299">
      <delay time="1.5" />
      <speak line="1251" />
      <delay time="1" />
      <speak line="1252" />
    </voicesequence>
  </add>
</diff>
```

`md/example_voice.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Voice" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Play_Gate_Report" instantiate="true">
      <conditions>
        <event_object_changed_sector object="player.entity"/>
        <check_value value="event.param.macro == macro.cluster_14_sector001_macro"/>
      </conditions>
      <actions>
        <play_voice_sequence sequence="'example_gate_report'" entity="player.computer"/>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The id is global.** Game starts, Timeline entries and scripts all look a sequence up by id alone, so a prefix of the extension's own keeps it clear of vanilla's and of other extensions'.
- **Subtitles are on.** The steps carry no `nosubtitles`, so both lines appear as subtitles while they are spoken. The vanilla Timeline sequence for the same entry turns them off, since the page prints the text.
- **The lines are borrowed.** Lines `1251` and `1252` of page `20299` exist in the base game with recordings, so the extension ships no audio. A sequence that speaks the extension's own text needs a line on a text page and a recording at the matching `voice-l<language>/<page>/` place.
- **To give a Timeline entry or a game start a voice**, no script is needed: the entry's or the start's `voice` attribute names the sequence and the menu plays it.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) covers the `<cutscene>` and `<intro>` elements whose `voice` names a sequence, and when the New Game menu plays them.

[timeline.xml](/x4/modding-support/anatomy-of-game-data/libraries/timeline-xml/) covers the Timeline entries and how the encyclopedia page plays an entry's video and voice.

[↑ Contents](#toc)

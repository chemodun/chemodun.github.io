---
title: sound_library.xml
description: How libraries/sound_library.xml defines every sound of the game - the sound files of a sound, their random selection, volume, hearing distance, curves and effects - how sound groups build the engine and ship sounds from flight data, who refers to a sound id (macros, components, effects, map defaults, scripts, UI Lua), how music and voice entries are laid out, and how an extension adds or changes a sound.
---

# sound_library.xml

A sound file on its own is not a sound of the game. Between the file and the place that plays it stands `libraries/sound_library.xml`: every entry of it gives one or more sound files an id and says how they are played, how loud, up to what distance, looped or once, and with which effects. A weapon macro, an effect, a sector, a script and a menu all name a sound by this id, not by a file.

This article covers the format, the sound groups of engines and ships, who refers to a sound, the music and voice entries, and how an extension adds or changes a sound. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Sound**: one entry of the file, a `<sound>` with an id. It is what the rest of the game refers to.
- **Sample**: a sound file. A sound has one sample, or a list of them to pick from.
- **Sound group**: a `<group>` of sounds that belong to one engine or one ship and play together, each switched and shaped by the flight of the ship.
- **3D sound**: a sound with a position in the world, heard from its direction and fading with distance. The opposite is a sound that plays the same wherever the player is, such as music or a menu click.
- **Curve**: a short list of points that turns one value into another, such as the distance to the sound into a volume.

[↑ Contents](#toc)

## How a sound is used

Nothing in the file says when a sound plays. Each entry is a definition that waits for something to name it:

1. A data file or a script names the sound id: a weapon macro for its firing sound, an effect for its explosion, a sector for its music, a script action, a menu.
2. The game looks the id up here and gets the samples and the settings.
3. It plays one of the samples with these settings, at the object that asked for it when the sound is a 3D one.

The volume the player hears is the volume of the entry scaled by the volume sliders of the Sound Settings: a master volume and one per kind of sound, for music, voice, ambient, interface and effects.

[↑ Contents](#toc)

## The file

### Layout

```xml
<soundlibrary>
  <sound id="ui_positive_click" description="Map cursor clicking on an object" repeat="1" is3d="0" preload="0">
    <sample start="sfx\ui\ui_positive_click"/>
    <volume start="0.4"/>
  </sound>
  <sound id="monument_energy_buzz" description="humming energy beam" repeat="-1" is3d="1" preload="0">
    <sample start="sfx\animation\monument_energy_buzz"/>
    <volume start="1.0" distance="0.15">
      <distancecurve>
        <point distance="0.0" volume="0.70"/>
        <point distance="0.5" volume="0.5"/>
        <point distance="0.75" volume="0.3"/>
        <point distance="1.0" volume="0.0"/>
      </distancecurve>
    </volume>
  </sound>
  ...
  <group id="enginedetail_spacesuit_01">
    <sound id="enginedetail_spacesuit_01_jet_01" tags="ambient" repeat="-1" is3d="1" preload="0">
      ...
    </sound>
    <sound id="enginedetail_spacesuit_s_01_boost_loop" tags="boosting" repeat="-1" is3d="1" preload="0">
      ...
    </sound>
  </group>
  ...
</soundlibrary>
```

The root `<soundlibrary>` holds a flat list of `<sound>` entries and, after them, the `<group>` entries. The vanilla file is ordered by subject with comment headers: ambient and cockpit sounds, animations of station modules, weapons, interiors, music, interface, voice, test sounds, then the groups. A commented "full example" at the top of the file shows every element once, with the value ranges of the effects.

The schema, `libraries/sound_library.xsd`, documents the attributes.

[↑ Contents](#toc)

### The sound

| Attribute | Meaning |
| --- | --- |
| `id` | The id of the sound, unique in the file. Required |
| `description` | A note for the reader of the file |
| `repeat` | How often the sound plays: `1` once, which is the default, a higher number that many times, `-1` in an endless loop |
| `is3d` | The sound has a position in the world. Vanilla sets it on every entry: `1` for sounds of objects, `0` for music, interface sounds and narration |
| `preload` | Load the sound at game start, not on first use. Vanilla sets it mostly for weapon and impact sounds |
| `isunique` | Only one instance of the sound plays at a time |
| `amount` | The highest number of instances that play at once. Vanilla sets it on a few weapon and impact sounds |
| `noocclusion` | The sound is not dampened by what stands between it and the player. The schema notes that only ambient and effect sounds need it; the others are not occluded anyway |
| `permanent` | The sound is not stopped or skipped for being too far away |
| `tag` | The connection tag where the sound is played. Vanilla has it on some cockpit and interface sounds, with tags such as `uisfx_hud` |

Inside a `<sound>` there is one `<sample>`, and optionally a `<volume>`, a `<pitch>`, an `<lfe>`, an `<effects>` and a `<random_noise>`.

[↑ Contents](#toc)

### Samples

A sample is named by its path from the game folder, with backslashes and without the extension:

```xml
<sample start="sfx\ui\ui_positive_click"/>
```

The vanilla effect sounds under `sfx/` are `.wav` files and the music under `music/` is `.ogg`.

A `<sample>` has up to three parts, `start`, `loop` and `end`, each a file of its own: an intro, a part that repeats while the sound lasts, and a tail played when it stops. Most sounds have only `start`. `startduration`, `loopduration` and `endduration` give the length of the parts.

```xml
<sample start="sfx\animation\amb_other_train_start" loop="sfx\animation\amb_other_train_loop" end="sfx\animation\amb_other_train_end" startduration="1.999" loopduration="1.783" endduration="1.999"/>
```

In place of one file a sample can hold a list to pick from:

```xml
<sample selection="random">
  <select start="sfx\ambient\ship\cockpit_random_beep_06" weight="2"/>
  <select start="sfx\ambient\ship\cockpit_random_beep_08" weight="2"/>
  <select start="sfx\ambient\ship\cockpit_random_2_2" weight="1"/>
</sample>
```

Each `<select>` takes the same attributes as the sample plus a `weight`, its share in the random pick; without one every entry counts the same. The `selection` attribute takes `one`, `random`, `random_except` or `choose`. Vanilla uses `random` nearly everywhere: for impacts and footsteps, so that a repeated sound does not come out identical each time, and for music, where the list is a playlist.

[↑ Contents](#toc)

### Volume and distance

| Attribute of `<volume>` | Meaning |
| --- | --- |
| `start`, `loop`, `end` | The volume of each part of the sample. `1` is the volume of the file; vanilla values go from near `0` to a little above `1` |
| `distance` | The distance up to which the sound can be heard, in kilometres |
| `category` | `Ambient`, `Effect`, `Music`, `UI` or `Voice`. The base file does not set it; Timelines sets `Music` on the music that plays as a 3D sound in its hub rooms |

`distance` is in kilometres, and the values show the scale: `0.01` to `0.2` for sounds inside a room or a cockpit, `1` to `20` for engines and weapons in space.

How the volume falls between the source and `distance` is set by a `<distancecurve>` of two to four points. Both values of a point are relative: `distance` as a share of the hearing distance, `volume` as a share of the volume.

```xml
<volume start="1" distance="0.20">
  <distancecurve>
    <point distance="0.0" volume="1.20"/>
    <point distance="0.25" volume="0.5"/>
    <point distance="0.5" volume="0.3"/>
    <point distance="1.0" volume="0.0"/>
  </distancecurve>
</volume>
```

The schema allows four more curves of the same form in a `<volume>`: `<lfecurve>`, `<lpfdirectcurve>`, `<lpfreverbcurve>` and `<reverbcurve>`. Vanilla uses none of them.

A `<customcurve>` drives the volume from a value other than distance; it is what the sound groups are built on and is covered [with them](#sound-groups). `<pitch>` holds only such a curve, and `<lfe>`, which the schema describes as the low pass filter of the sound, has `start`, `loop`, `end` and `distance` and can hold one too.

[↑ Contents](#toc)

### Effects

`<effects>` holds up to five elements, one of each kind:

| Element | Attributes | Meaning |
| --- | --- | --- |
| `<fade>` | `in`, `out` | Fades the sound in when it starts and out when it stops |
| `<filter>` | `mode`, `frequency`, `oneoverq`, `distance` | A filter: `lowpass`, `bandpass`, `highpass` or `notch`. With a `distance` and a `<distancecurve>` inside, the filter follows the distance, which is how vanilla makes a far engine sound dull |
| `<reverb>` | `room`, `roomsize`, `drymix`, `density` | Reverb of a named room, such as `hangar` or `sewer pipe`. The names are the environments of `libraries/sound_env_library.xml` |
| `<pitch>` | `start`, `end`, `steps` | A pitch range and a number of steps. The schema does not describe it; vanilla has it on three sounds |
| `<doppler>` | `factor` | The strength of the Doppler shift. Vanilla has it on one sound |

The full example in the file gives the ranges: `frequency` from 0 to 1, `oneoverq` from 0 to 1.5, `roomsize` from 1 to 100 in feet, `drymix` and `density` from 0 to 100 percent.

[↑ Contents](#toc)

### Random noise

`<random_noise>` turns a sound into occasional background noise: the sound plays again and again with a random pause, and `interval` is the average pause in seconds. The cockpit ambience is built this way, a random pick of beeps, fans and sparks per console with an interval of twenty seconds.

```xml
<sound id="cpit_amb_console_front" description="Cockpit Ambient - Console front" repeat="1" is3d="1" isunique="0" preload="0">
  <sample selection="random">
    ...
  </sample>
  <volume start="0.1" distance="0.01"/>
  <random_noise interval="20"/>
</sound>
```

An `<override interval="..." tags="..."/>` inside it gives another interval for a state of the object; the schema lists one tag, `damaged`.

[↑ Contents](#toc)

## Sound groups

The sound of a flying ship is not one sound. It is a set that plays together: the engine jet, a low rumble, the thrusters for each direction of a manoeuvre, the boost and travel drive phases, the echo off a nearby wall. A `<group>` holds such a set, and each sound in it carries `tags` that say when it is active and curves that shape it by the flight data.

```xml
<group id="enginedetail_spacesuit_01">
  <sound id="enginedetail_spacesuit_01_jet_01" tags="ambient" repeat="-1" is3d="1" preload="0">
    <sample start="sfx\engines\spacesuit\enginedetail_spacesuit_01_jet_01"/>
    <volume start="0.6" distance="1">
      <customcurve input="forwardacc">
        <point position="-1" value="1"/>
        <point position="0" value="0"/>
        <point position="1" value="1"/>
      </customcurve>
    </volume>
    <pitch>
      <customcurve input="forwardacc">
        <point position="-1" value="0"/>
        <point position="0" value="-0.1"/>
        <point position="1" value="0"/>
      </customcurve>
    </pitch>
  </sound>
  <sound id="enginedetail_spacesuit_s_01_boost_loop" tags="boosting" repeat="-1" is3d="1" preload="0">
    <sample start="sfx\engines\spacesuit\enginedetail_spacesuit_boost_loop"/>
    <volume start="1.0" distance="1"/>
  </sound>
</group>
```

Here the jet of the spacesuit is always active, silent at rest and at full volume under full acceleration in either direction, with a slightly lower pitch at rest. The boost loop plays while boosting.

A sound in a group is written like a sound outside one, with the same attributes and elements. The schema also allows a `ref` to the id of a sound defined outside the group, in place of an `id` and a definition of its own; vanilla defines every group sound in place.

[↑ Contents](#toc)

### Tags

The schema documents these tags:

| Tag | The sound is |
| --- | --- |
| `ambient` | Always active |
| `boostcharging`, `boosting` | Active while the boost is charging, and while boosting |
| `accelerate`, `decelerate` | Triggered when the throttle is raised or reduced |
| `boostchargestarted`, `boostchargestopped` | Triggered when the boost charge starts, and when it is aborted before it finished |
| `booststarted`, `booststopped` | Triggered when the boost itself starts and when it stops |

The attribute is not limited to them, and vanilla uses more of the same kind: `travelcharging`, `travelstarted`, `traveling`, `travelspeedreached` and `travelstopped` for the travel drive, `startup` and `shutdown`, `docking`, `highspeed`, a tag per manoeuvre (`strafeleft`, `yawleft`, `pitchup`, `rollleft` and so on) and a tag per side for a nearby wall (`wallleft`, `wallabove`, `wallbelowright` and so on). Several tags on one sound are separated by spaces. The pair `player` and `noplayer` splits a sound into two versions: vanilla gives the same event one sound with each tag, the second from a file with `_noplayer` in its name.

[↑ Contents](#toc)

### Custom curves

A `<customcurve>` takes a value of the flying ship as `input` and gives the volume, the pitch or the low pass value for it. A `<point>` has a `position`, the input value, and a `value`, the output; `default` on the curve is the output when the input is outside the points.

The inputs the schema lists, with its notes:

| Input | Value |
| --- | --- |
| `forwardspeed` | Relative forward speed, -1 to 1 |
| `forwardspeeddiff` | Relative difference between the current and the target forward speed, -2 to 2 |
| `forwardspeeddiff2` | Difference between the throttle input and the current forward speed, plus a tenth of the relative forward speed, -1 to 1 |
| `forwardacc`, `reverseacc` | Relative acceleration forward or in reverse; 1 is full, the value can be higher |
| `boostchargeprogress` | Progress of the boost charge, 0 to 1 |
| `gforce` | The force acting on the player |
| `horizontalstrafespeed`, `verticalstrafespeed` | Relative strafe speed: -1 left or down, 1 right or up |
| `pitchspeed`, `yawspeed`, `rollspeed` | Relative turn speed per axis |
| `leftspeed`, `rightspeed`, `upspeed`, `downspeed` | The higher of the strafe speed and the turn speed to that side |
| `leftacc`, `rightacc`, `upacc`, `downacc` | The same for acceleration |
| `leftforce`, `rightforce`, `upforce`, `downforce` | A value from acceleration and speed that matches the strength of the visible engine and thruster effects |
| `wallecho_left`, `wallecho_above`, `wallecho_below_right` and the other five sides | How close a wall is on that side, 0 for none and 1 for touching, times the forward speed |
| `ikspeed_linear`, `ikspeed_x`, `ikspeed_y`, `ikspeed_z`, `ikspeed_angular`, `ikspeed_pitch`, `ikspeed_yaw`, `ikspeed_roll` | The speed at which the part the sound is attached to moves or turns, 0 to 1 |

The engine jet in vanilla rises with `forwardspeed`, the thrusters follow the `...force` inputs, and the wall sounds follow `wallecho_...`. The `ikspeed` inputs work outside a group too: vanilla uses `ikspeed_z` on two plain sounds of moving parts.

[↑ Contents](#toc)

### The two kinds of group

Vanilla groups come in pairs, and a macro refers to each kind with its own element:

- **`enginedetail_...`**: the sounds of an engine, referred to by an engine macro with `<enginedetail ref="..."/>`. Jets, boost and travel drive.
- **`shipdetail_...`**: the sounds of a hull, referred to by a ship macro with `<shipdetail ref="..."/>`. Manoeuvring thrusters and wall echoes.

Both sit in the `<sounds>` of the macro's properties:

```xml
<sounds>
  <enginedetail ref="enginedetail_ship_m_02"/>
</sounds>
```

The groups are shared: one group per ship size and kind serves many macros, with groups of their own for the Xenon and the Kha'ak. `libraries/defaults.xml` gives the ship class a default `<shipdetail>` for the macros that name none.

[↑ Contents](#toc)

## Who refers to a sound

A sound id is used from many places. The main ones:

| Where | How | What for |
| --- | --- | --- |
| Macros | Named elements in `<sounds>`: `<ambient ref>`, `<firing ref>`, `<ammoreloadstarted ref>`, `<shieldcharging ref>`, `<breathing ref>` and others | The sound of an object's state: a weapon firing, a module humming, a dock working |
| Components | `<sounds><sound name="..." ref="..."/></sounds>` | A sound at a place of the model, such as a cockpit ambience or an animated part |
| `libraries/effects.xml` | `<sound ref="..."/>` in an effect element | The sound of an effect: a muzzle flash, an impact, an explosion |
| `libraries/defaults.xml` | The same `<sounds>` elements per class | Defaults: footsteps of the first person character, the fight music list, highway ambience |
| `libraries/mapdefaults.xml` | `<sounds><music ref="..."/></sounds>` in the dataset of a sector or a cluster | The music of that place |
| `libraries/region_definitions.xml` | `<ambientsound soundid="..."/>` | Ambient sounds inside a region |
| `libraries/startmenu.xml` | `music` on a `<scene>` | The music of a start menu scene |
| `libraries/parameters.xml` | Attributes of many elements | Fixed sounds of the game: the speed bar, the container magnet, the zoom, the alert sounds offered in the options |
| Scripts | `play_sound`, `play_music`, `show_notification` and others | See [The script side](#the-script-side) |
| UI Lua | `PlaySound("...")` | See [The Lua side](#the-lua-side) |

The engine and ship groups are referred to by their group id, everything else by a sound id.

[↑ Contents](#toc)

## Music

Music entries are sounds like the others, with `is3d="0"` and a sample from `music/`. Three things are particular to them.

**A sector's music is a playlist.** The dataset of a sector or cluster in `mapdefaults.xml` names one sound, and that sound holds a random list with weights:

```xml
<sound id="music_soundtrack_argon" description="Music selection for Argon core sectors" repeat="-1" is3d="0" preload="0">
  <sample selection="random">
    <select weight="8" start="music\Cluster\p1_amb_04"/>
    <select weight="4" start="music\cluster\p1_amb_07"/>
    <select weight="1" start="music\legacy\Alexei Zakharov - HOL_04"/>
    ...
  </sample>
</sound>
```

Several sectors share a playlist, so changing the music of one sector means giving it a sound of its own in its dataset, while a change to the list changes every sector that uses it.

**Fight music comes in pairs.** The galaxy dataset of `defaults.xml` holds a `<fightmusic>` list; each `<entry>` names a sound for a small fight and one for a big fight, with a weight.

**The main menu track is one entry**, `music_menu_main_music`, and a scene of [startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) can name another.

[↑ Contents](#toc)

## Voice

The spoken lines are not listed here one by one. The file has a small set of entries per speaker, with the speaker's number in the id and a folder as the sample:

```xml
<sound id="10111_comm" description="npc-player comms" repeat="1" is3d="1" preload="0">
  <sample start="voice\10111\comm"/>
</sound>
```

The entries of a speaker differ in the way the line is heard: `..._comm` for a call to the player, `..._comm_npc` for talk between characters, `..._comm_broadcast`, and `..._comm_signalleak` with a short hearing distance and a distance curve for the voice of a signal leak. Which line is spoken is decided elsewhere; [voicesequences.xml](/x4/modding-support/anatomy-of-game-data/libraries/voicesequences-xml/) covers how lines are put together.

[↑ Contents](#toc)

## How the expansions change it

Every expansion ships a `libraries/sound_library.xml`, and each is a `<diff>`. They do three things:

- **Add sounds and groups** with one `<add sel="/soundlibrary">`: weapons, animations, music, voice entries for new speakers, and engine and ship groups for the new ship lines. The samples are named with the path of the expansion in front, `extensions\ego_dlc_boron\sfx\...`.
- **Add tracks to an existing playlist** with an `<add>` into the `<sample>` of a base sound. The base file has an entry made for this, `music_complete_soundtrack`, whose description says that the expansions patch their tracks into it; the sector playlists and the playlist of the station design simulator get tracks the same way.
- **Replace a value of a base sound** with a `<replace>` on an attribute: several expansions set the sample and the volume of `music_menu_main_music` to their own main menu track.

```xml
<add sel="/soundlibrary/sound[@id='music_station_designer']/sample">
  <select start="extensions\ego_dlc_boron\music\Cluster\01. Alexei Zakharov - Lullaby of the Lilac Star"/>
  ...
</add>
<replace sel="/soundlibrary/sound[@id='music_menu_main_music']/volume/@start">0.3</replace>
```

[↑ Contents](#toc)

## The script side

The actions are shared by MD and AI scripts. A sound is named by a string with its id.

| Action | What it does |
| --- | --- |
| `<play_sound sound="..." object="..." type="..."/>` | Plays a sound at an object. `type` is `effect` (the default), `ambient` or `ui`; with `ui` no object is needed. The type decides which volume slider of the player applies. Looping sounds are not supported |
| `<play_music music="..." loop="..."/>` | Plays a music entry in place of the regular music. For an entry with a negative `repeat`, `loop` has to be `true`, and the script stops it itself |
| `<stop_music/>` | Stops the music started by `play_music` |
| `<set_music_volume volume="..."/>` | Scales the music volume, 0.0 to 1.0 |
| `<set_ambient_sound_state active="..."/>` | Switches the ambient sounds on or off |
| `<set_object_sound_override object="..." type="ambient" sound="..." volume="..."/>`, `<clear_object_sound_override .../>` | Replaces the ambient sound of an object or scales its volume, and returns to the default. Only room ambient sounds are supported |
| `<muffle_sound strength="..." duration="..."/>` | Muffles all sound to a strength from 0.0 to 1.0 over a time |

Other actions take a sound as one of their attributes: `show_notification` and `play_cutscene` have a `sound`, and a notification without one uses `notification_generic`.

```xml
<play_sound sound="'ui_interaction_not_possible'" type="ui"/>
<play_sound object="player.room" sound="'station_announcement_jingle'"/>
<play_music music="'intergalactic_tea'" loop="true"/>
```

[↑ Contents](#toc)

## The Lua side

The UI Lua plays interface sounds by id:

| Function | What it does |
| --- | --- |
| `PlaySound(id)` | Plays a sound once. Vanilla menus call it for clicks, hovers and confirmations, for example `PlaySound("ui_positive_click")` |
| `StartPlayingSound(id)` | Starts a sound and returns a handle. The map uses it for the looping sounds of its ambience, zooming and panning |
| `StopPlayingSound(handle)` | Stops a sound started this way |

The sounds an extension adds to the library are played the same way. Two things show in the log: an id that is not in the library gives the error `Invalid SoundID ... No definition found in SoundLibrary`, and a sound that cannot be started gives `Failed to start sound`, in which case `StartPlayingSound` returns nothing. The second happens when the same sound is started again in the same frame.

[↑ Contents](#toc)

## Adding a sound from an extension

The example below, for a fictional extension `example_sounds`, adds a chime with two variations, plays it from a script when the player enters a sector, and lowers the volume of one vanilla interface sound.

`libraries/sound_library.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/soundlibrary">
    <sound id="example_chime" description="Example: chime on entering a sector" repeat="1" is3d="0" preload="0">
      <sample selection="random">
        <select start="extensions\example_sounds\sfx\example_chime_01"/>
        <select start="extensions\example_sounds\sfx\example_chime_02"/>
      </sample>
      <volume start="0.6"/>
      <effects>
        <fade in="0.05" out="0.1"/>
      </effects>
    </sound>
  </add>
  <replace sel="/soundlibrary/sound[@id='ui_positive_click']/volume/@start">0.25</replace>
</diff>
```

`md/example_sounds.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Sounds" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Chime_On_Sector_Change" instantiate="true">
      <conditions>
        <event_object_changed_sector object="player.entity"/>
      </conditions>
      <actions>
        <play_sound sound="'example_chime'" type="ui"/>
      </actions>
    </cue>
  </cues>
</mdscript>
```

The two sound files are `sfx/example_chime_01.wav` and `sfx/example_chime_02.wav` in the folder of the extension.

Some points about the example:

- **The sample path starts at the game folder.** A file of an extension is named with `extensions\<folder>\` in front, as the expansions name theirs, with the folder name of the extension and without the file extension.
- **The id is the extension's own.** Ids share one list with the game's and with every other extension's, so a prefix keeps them apart.
- **A sound without a position needs no distance.** The chime is an interface sound: `is3d="0"`, no `distance`, played with `type="ui"` and no object. A sound of an object in the world takes `is3d="1"`, a `distance` in kilometres and usually a `<distancecurve>`.
- **`play_sound` plays a sound once.** The action does not support looping sounds, so the entry has `repeat="1"`.
- **A value of a vanilla sound is replaced by attribute.** The `<replace>` selects the `start` attribute of the `<volume>` and leaves the rest of the entry alone. A `<replace>` of the whole `<sound>` would also drop what an expansion or another extension added inside it, such as playlist tracks.
- **A new playlist track is an `<add>` into the `<sample>`** of the playlist's sound, the way the expansions add theirs.
- **Text is not involved.** The `description` is a note in the file and is not shown in the game, so no text file is needed.

The extension itself, its folder and `content.xml`, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/), and the diff operations in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[voicesequences.xml](/x4/modding-support/anatomy-of-game-data/libraries/voicesequences-xml/) covers how spoken lines are put together from parts.

[startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) covers the start menu scenes and the music a scene names.

[parameters.xml](/x4/modding-support/anatomy-of-game-data/libraries/parameters-xml/) covers the tuning values of the game, among them the fixed sounds it names.

[↑ Contents](#toc)

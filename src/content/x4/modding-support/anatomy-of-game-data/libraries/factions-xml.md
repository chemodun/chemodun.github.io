---
title: factions.xml
description: How libraries/factions.xml defines every faction - names, race, colour and icons, the licences it grants and holds, its starting relations to the others, the signal responses and the tags - how relations are measured and shown, how the expansions add factions, the script side, and how an extension adds a faction of its own.
---

# factions.xml

Every owner of a ship, station or sector in X4 is a **faction**: the governments, the pirate groups, the Xenon and Kha'ak, the player, and a few invisible ones the game uses for ownerless objects, criminals and visitors. Each is one `<faction>` in `libraries/factions.xml`. The entry says how the faction is named, which race it belongs to, what its colour and icons are, which licences it grants and which it holds from others, how it stands to every other faction when a game begins, and what its ships do when a pirate or the police hails them. The relations the game keeps between factions all start from here.

This article covers the format, what the game does with each part, how relations are measured, the script side and how an extension adds a faction. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Faction**: one `<faction>` entry, named by its `id`. A script refers to it as `faction.<id>`, and an object's `owner` is one of these.
- **Race**: the species a faction belongs to, from `libraries/races.xml`. A faction has one `primaryrace`; several factions share a race.
- **Relation**: a number from -1.0 to 1.0 between two factions. The interface shows it as a value from -30 to +30.
- **Relation range**: a named band of relation values, such as `friend`, `enemy` or `kill`. What a faction may do towards another depends on the range their relation falls in.
- **Licence**: a permission a faction grants, such as the right to buy its capital ships or to act as its police. A faction grants licences and holds licences from others.
- **Signal response**: what a faction's ships do when hailed by a pirate or the police, or when they find an abandoned ship or a lockbox.

[↑ Contents](#toc)

## How a faction entry is used

1. **At game start the factions are created** from the entries, with the relations each lists. Space, stations and ships come from elsewhere: `god.xml` places the stations, `jobs.xml` the ships, and both select by faction.
2. **Relations then change through play.** Attacks, kills, missions, trade and diplomacy move the number, and the scripts can set it outright. The file's own comment says it: the relations defined here apply at game start only.
3. **Licences gate what the player can buy and do.** A licence a faction grants names the relation the player needs for it and, where there is one, the licence that has to come first.
4. **The entry's texts and icons appear everywhere** the faction is named: the map, the encyclopedia, the trade and ship menus, the relations screen and the diplomacy screen.

[↑ Contents](#toc)

## The file

### Layout

```xml
<factions>
  <signals>
    <signal id="piratehalt" name="..." description="..." default="attack">
      <response id="attack" name="..." description="..." />
      <response id="comply" ... />
      ...
    </signal>
    ...
  </signals>
  <faction id="argon" ...> ... </faction>
  <faction id="player" ...> ... </faction>
  ...
</factions>
```

- `<signals>` defines the signals every faction can respond to and the responses each allows. It appears once, at the top.
- Each `<faction>` is one faction.
- The schema also allows a `<ranges>` element that overrides the relation ranges. Vanilla does not use it, and the default ranges are listed in [Relations](#relations).

The base file holds the base game's factions. Each expansion's `libraries/factions.xml` is a diff that adds its own factions and, into the entries of the existing ones, their relations to the new arrivals. See [How the expansions change it](#how-the-expansions-change-it).

The schema, `libraries/factions.xsd`, documents every element and attribute, and is the reference for the parts this article only names.

[↑ Contents](#toc)

### A faction, part by part

The Argon Federation, shortened:

```xml
<faction id="argon" name="{20203,201}" description="{20203,202}" shortname="{20203,203}" prefixname="{20203,204}"
         spacename="{20203,205}" homespacename="{20203,206}" primaryrace="argon" behaviourset="default"
         tags="claimspace economic police privateloadout privateship protective publicloadout publicship standard watchdoguser"
         policefaction="argon">
  <color ref="faction_argon" />
  <icon active="faction_argon" inactive="faction_argon" banner="diplomacy_banner_argon" />
  <licences>
    <licence type="generaluseship" name="{20207,2211}" minrelation="-0.01" tags="basic" />
    <licence type="ceremonyfriend" name="{20207,5001}" minrelation="0.01" />
    <licence type="militaryship" name="{20207,3001}" icon="bse_star" minrelation="0.01" precursor="ceremonyfriend" />
    <licence type="police" name="{20207,1001}" description="{20207,1002}" minrelation="0.01" precursor="ceremonyfriend" price="156000" maxlegalscan="2" />
    <licence type="ceremonyally" name="{20207,5011}" minrelation="0.1" />
    <licence type="capitalship" name="{20207,3011}" icon="bse_star" minrelation="0.1" precursor="ceremonyally" />
    ...
    <licence type="capitalship" factions="antigone" />
    <licence type="generaluseship" factions="antigone hatikvah" />
  </licences>
  <relations>
    <relation faction="antigone" relation="0.67" />
    <relation faction="teladi" relation="0.1" />
    <relation faction="holyorder" relation="-0.1" />
    <relation faction="scaleplate" relation="-0.32" />
    <relation faction="xenon" relation="-1" />
    ...
  </relations>
</faction>
```

- The attributes name the faction, tie it to a race, a flight behaviour set and a police faction, and carry its tags.
- `<color>` and `<icon>` are how the faction looks on the map and in the menus.
- `<licences>` holds two kinds of line: the licences this faction **grants**, each with a `type`, a name and the conditions, and the licences it **holds** from other factions, each a `type` with a `factions` list and nothing else.
- `<relations>` lists the faction's relation to the others at game start. A faction not listed starts at neutral.

Three more elements appear on some entries: `<account>` gives the faction an account of its own, `<signals>` overrides a default signal response, and `<buildrules>` overrides the build method its stations use.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The faction id. Scripts use it as `faction.<id>`; `god.xml`, `jobs.xml`, `ships.xml` and the rest select by it |
| `name`, `description`, `shortname` | The name, the encyclopedia text and the abbreviation; vanilla's are on text page 20203 |
| `prefixname` | The word put before an item's name, such as the faction's adjective before a ship class |
| `spacename`, `homespacename` | The names of the faction's territory and of its home |
| `primaryrace` | The race, from `races.xml`. The race supplies the character defaults, the name pool and the race relations |
| `behaviourset` | The flight behaviour set its pilots use, from `behaviours.xml`. Required; vanilla has `default`, `khaak` and `xenon` |
| `policefaction` | The faction whose police act in this faction's space. It has to carry the `police` tag. Without the attribute, the faction polices itself when it has that tag, and nobody does otherwise |
| `constructionbias` | How its stations grow: below 1.0 prefers vertical connections, above 1.0 horizontal. Omitted, the race's value applies |
| `tags` | The faction's traits, see [Tags](#tags) |
| `active` | Whether the faction exists from the start. Default true; the Trinity starts with `active="0"` and is activated by its story |
| `known` | Whether the player knows the faction from the start. Default true |

[↑ Contents](#toc)

### Colour and icons

`<color>` is either a reference into `libraries/colors.xml`, as `ref="faction_argon"`, or the colour itself as `r`, `g`, `b` and an optional `glow`. The colour is what the map, the ownership overlay and the faction name in menus use.

`<icon>` names icons from `libraries/icons.xml`: `active` and `inactive` are required and are the small icon shown beside the name; `image` is the large picture, and `banner` is the banner the diplomacy screen shows. A faction without a banner has no banner on that screen.

[↑ Contents](#toc)

### Licences

A `<licence>` line with a `name` is a licence the faction **grants**:

| Attribute | Meaning |
| --- | --- |
| `type` | One of the licence types the game knows, listed below |
| `name`, `description` | The texts; vanilla's are on page 20207 |
| `grantedtext`, `notgrantedtext` | Texts shown when the licence is granted or refused |
| `icon` | An icon shown with the licence |
| `minrelation` | The relation the player needs with this faction to be granted it |
| `precursor` | A licence type the player has to hold from this faction first |
| `price` | What it costs; without one it is free |
| `maxlegalscan` | For the police licence: up to which scan level scanning becomes legal while the licence is held |
| `tags` | `basic` and `hidden` in vanilla: the general use licences carry `basic`, and the licences not meant to be listed, such as the envoy access, carry `hidden` |

The licence types are `generaluseship`, `generaluseequipment`, `militaryship`, `militaryequipment`, `capitalship`, `capitalequipment`, `ceremonyfriend`, `ceremonyally`, `police`, `station_gen_basic`, `station_gen_intermediate`, `station_gen_advanced`, `station_equip_sm`, `station_equip_lxl`, `station_illegal`, `station_race_basic`, `station_race_intermediate`, `station_race_advanced`, `station_venture`, `subgroupfriend`, `tradesubscription`, `shipsalecontract`, `intelligence`, `innercore_access`, `outercore_access`, `envoy_access`, `hyperion_access` and `story_paranid_palace_module`. The two ceremonies are the steps of the vanilla ladder: friend at relation 0.01, ally at 0.1, and the military and capital licences name them as precursor.

A `<licence>` line with `factions` and no name is a licence the faction **holds**: `<licence type="capitalship" factions="antigone" />` on the Argon entry means the Federation holds Antigone's capital ship licence. The player's entry starts with the general use licences of every base game faction that grants them and the illegal station licence of two pirate factions. In a script, `licences` lists what a faction grants and `heldlicences` what it holds.

[↑ Contents](#toc)

### Relations

`<relations>` lists `<relation faction="..." relation="..."/>` lines, one per other faction, with the value at game start. A pair not listed starts at 0. Vanilla lists each pair from both sides with the same value, and a diff that adds a faction does the same: its own list, and one line added into each existing faction's list.

A `<relation>` can also carry `min` and `max`, bounds the relation cannot leave. `<relations locked="1">` freezes a faction's relations altogether, with `lockreason` as the text shown to the player; vanilla locks the hidden factions, the Xenon, the Kha'ak, the fanatics and two of the pirate factions.

The value is a number from -1.0 to 1.0, and what matters is the **range** it falls in. The defaults, from the file's own comment:

| Range | Values | Meaning |
| --- | --- | --- |
| `self` | 1.0 | The faction itself |
| `ally` | 0.5 to 1.0 | |
| `member` | 0.1 to 1.0 | |
| `friend` | 0.01 to 1.0 | |
| `neutral` | -0.01 to 0.01 | |
| `enemy` | -1.0 to -0.01 | |
| `killmilitary` | -1.0 to -0.1 | The faction attacks the other's military ships |
| `kill` | -1.0 to -0.32 | The faction attacks everything of the other's |
| `nemesis` | -1.0 | |

A `dock` range exists as well and is what the scripts read as `relation.dock.min`, the lowest relation at which docking is still allowed. The ranges overlap on purpose: a relation of 0.6 is `ally`, `member` and `friend` at once, and `hasrelation.friend.{...}` is the usual test for "at least a friend".

The interface shows a relation as a whole number from -30 to +30. The mapping is fixed at a few points and logarithmic between them: 1.0 is 30, 0.5 is 27, 0.32 is 25, 0.1 is 20, 0.032 is 15, 0.01 is 10 and 0.0032 is 5, with the negative side mirrored, and the step between -5 and +5 is linear. Two consequences follow for anyone writing values. The visible steps near zero are tiny numbers, so a mission reward of `0.0064` is a visible change at low relation and nothing at high relation. And the boundary between neutral and friend is 0.01, which the interface shows as +10. A script reads the number as `relation.{$value}.uivalue` when it needs the shown form.

Relations change through play in three ways. The game itself changes them on attacks, kills, boarding, scanning and hacking, by the amounts `libraries/defaults.xml` sets per class of object. The scripts change them for missions, trade and story with `add_faction_relation` and `set_faction_relation`, and the diplomacy system of 9.00 does so through `libraries/diplomacy.xml` and the diplomacy scripts. And a temporary **boost** can be laid over a relation, `set_relation_boost`, which the game uses for short-lived hostility such as during a boarding.

[↑ Contents](#toc)

### Signals

The file-level `<signals>` block defines six signals and the responses each allows: `attacked`, `foundabandonedship`, `foundlockbox`, `piratehalt`, `policehalt` and `policefoundcontraband`. Each signal has a `default` response, and `ask` says whether the player is asked rather than the default applied. The texts are on page 1036.

These are the choices the player sees in the responses settings of a ship, and the defaults for every NPC faction. A faction whose ships should answer differently carries its own `<signals>` with a `<response signal="..." response="..."/>` per signal it overrides; vanilla does this for two pirate factions, the Xenon and the Kha'ak.

[↑ Contents](#toc)

### Account

`<account amount="..."/>` gives the faction a money account of its own. In vanilla only the player has one, starting at 0; every other faction uses a dummy account with a large random sum, which is what `faction.money` reports for them and why an NPC faction never runs out of money. The script property `hasownaccount` tells the two apart.

[↑ Contents](#toc)

### Build rules

`<buildrules method="..."/>` overrides the production method the faction's stations use, when it should differ from the race's default. The methods are those `wares.xml` defines for its production entries: `default`, the race names, `closedloop` and `recycling`.

[↑ Contents](#toc)

## Tags

The `tags` attribute is a space separated list. Some tags are read by the game and some by the scripts, and the script side exposes most of them as properties of the faction:

| Tag | Read as | What it does |
| --- | --- | --- |
| `economic` | `iseconomic` | The faction takes part in the economy: `get_factions_by_tag tag="tag.economic"` is how the vanilla scripts collect the factions that trade, build and get drained |
| `police` | `ispolice` | The faction can act as police; required on a faction named as `policefaction` |
| `protective` | `isprotective` | Its ships intervene when third parties are attacked nearby |
| `aggressive` | `isaggressive` | Attacks on sight; vanilla gives it to the Kha'ak |
| `claimspace` | `willclaimspace` | The faction claims and contests sectors through stations that grant ownership |
| `noresupply` | `doesresupply` is false | Its ships do not resupply at docks |
| `standard` | `hastag.standard` | The main factions; the vanilla setup and station scripts use it to pick them |
| `pirate`, `plunder` | `hastag.pirate` | The pirate factions; `plunder` is read by the patrol missions and `loadoutrules.xml` |
| `hidden` | `hastag.hidden` | Not shown to the player: the criminal, outlaw, smuggler, civilian, ownerless and visitor factions |
| `notradeoffer`, `nobuildunits`, `nodiplomacyselection` | `hastag.<tag>` | No trade offers, no built units, not selectable in diplomacy; the Xenon and the Kha'ak |
| `watchdoguser` | `hastag.watchdoguser` | Read by `loadoutrules.xml` |
| `publicship`, `privateship`, `publicloadout`, `privateloadout` | `hastag.<tag>` | Whether the faction's ships and loadouts are public or its own |
| `visitor` | `isvisitor` | The online visitor faction |

Any other word is accepted and readable through `hastag.{$tag}`, so an extension can tag its own factions for its own scripts.

[↑ Contents](#toc)

## How the expansions change it

Each expansion ships a `libraries/factions.xml` that is a diff with two kinds of change. One `<add sel="/factions">` carries its new factions in full: Split Vendetta adds the Zyarth Patriarchy, the Free Families, the Court of Curbs and the Fallen Families; Cradle of Humanity the Terran Protectorate, the Segaris Pioneers and the Yaki; Kingdom End the Boron; Tides of Avarice the Riptide Rakers and the Vigor Syndicate; Timelines the Quettanauts. Then one `<add sel="/factions/faction[@id='...']/relations">` per existing faction gives that faction its relation to the newcomers, so that both sides of every pair exist, and a few `<add ... /licences>` lines give the player and some factions licences from the new ones.

That is the pattern for an extension too: the faction itself, and a line in every existing faction it has a relation with.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `faction.<id>` | The faction; `faction.player` is the player |
| `.name`, `.shortname`, `.prefixname`, `.spacename`, `.homespacename`, `.description` | The texts |
| `.primaryrace`, `.policefaction`, `.defaultpolicefaction`, `.headquarters`, `.representative` | The race, the police faction as it is now and as defined, the headquarters station, the representative |
| `.isactive`, `.knowntoplayer` | The `active` and `known` state |
| `.relationto.{$faction}`, `.defaultrelationto.{$faction}` | The relation now, and the one the file defines |
| `.hasrelation.<range>.{$faction}`, `.hasrelation.<range>.{$component}` | Whether the relation to a faction, or to an object's owner, is in a range |
| `.relation.<range>.min`, `.mid`, `.max` | The bounds of a range for this faction |
| `.relation.{$value}.uivalue` | A relation value as the interface shows it |
| `.mayattack.{$faction}`, `.ishostileto.{$faction}` | Whether the kill ranges allow an attack, and whether either side may attack |
| `.isrelationlocked` | The `locked` state |
| `.licences`, `.heldlicences`, `.licence.<type>`, `.haslicence.<type>.{$faction}`, `.canholdlicence.<type>.{$faction}` | The licences granted, held, one by type, and whether a licence is held or could be |
| `.tags`, `.hastag.<tag>`, `.iseconomic`, `.ispolice`, `.isprotective`, `.isaggressive`, `.willclaimspace`, `.doesresupply` | The tags |
| `.money`, `.hasownaccount` | The account |
| `.mood.<type>`, `.isdiplomacyactive` | The diplomacy state of 9.00 |
| `set_faction_relation`, `add_faction_relation` | Set a relation, or change it by an amount; `add_faction_relation` takes a `reason` |
| `set_relation_boost`, `reset_relation_boost` | A temporary change laid over the relation |
| `set_faction_relation_locked` | Lock or unlock a faction's relations |
| `add_licence`, `remove_licence` | Grant or take a licence |
| `set_faction_active`, `set_faction_known`, `set_faction_police`, `set_faction_headquarters`, `set_faction_identity` | Activate a faction, reveal it, change its police faction, its headquarters, or its name and colours |
| `get_factions_by_tag`, `get_factions_by_relation` | Collect factions by tag, or by relation to another |
| `event_faction_relation_changed`, `event_player_relation_changed`, `event_faction_relation_range_changed` | A relation changed, the player's relation changed, a relation crossed a range boundary |
| `event_faction_activated`, `event_faction_deactivated`, `event_player_licence_added`, `event_player_licence_lost` | A faction was activated or deactivated, the player gained or lost a licence |

The vanilla uses give the scale of things: `add_faction_relation` appears in almost fifty scripts, mostly mission rewards and penalties of a few thousandths; `set_faction_relation` in ten, the diplomacy script and the story scripts among them; `set_faction_known` in the generic missions, where the client's faction is revealed when the mission is accepted.

[↑ Contents](#toc)

## Adding a faction from an extension

A new faction needs a diff on `libraries/factions.xml` and the texts. Giving it anything in space is the business of other files: stations through `god.xml`, ships through `jobs.xml`, ship selection through `ships.xml` and `shipgroups.xml`, crews through `people.xml`. The example below is the faction alone, for a fictional extension `example_faction`: a Teladi trading guild, friendly with the Teladi Company, on bad terms with the Scale Plate Pact, neutral to the rest.

`libraries/factions.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/factions">
    <faction id="example_guild" name="{1234567,1}" description="{1234567,2}" shortname="{1234567,3}" prefixname="{1234567,4}"
             spacename="{1234567,5}" homespacename="{1234567,6}" primaryrace="teladi" behaviourset="default"
             tags="economic standard privateship privateloadout" policefaction="ministry">
      <color r="80" g="200" b="120" glow="0.7" />
      <icon active="faction_teladi" inactive="faction_teladi" />
      <licences>
        <licence type="generaluseship" name="{1234567,11}" minrelation="-0.01" tags="basic" />
        <licence type="generaluseequipment" name="{1234567,12}" minrelation="-0.01" tags="basic" />
        <licence type="ceremonyfriend" name="{1234567,13}" minrelation="0.01" />
        <licence type="militaryship" name="{1234567,14}" minrelation="0.01" precursor="ceremonyfriend" />
        <licence type="generaluseship" factions="teladi ministry" />
        <licence type="generaluseequipment" factions="teladi ministry" />
      </licences>
      <relations>
        <relation faction="teladi" relation="0.5" />
        <relation faction="ministry" relation="0.5" />
        <relation faction="scaleplate" relation="-0.32" />
        <relation faction="khaak" relation="-1" />
        <relation faction="xenon" relation="-1" />
      </relations>
    </faction>
  </add>
  <add sel="/factions/faction[@id='teladi']/relations">
    <relation faction="example_guild" relation="0.5" />
  </add>
  <add sel="/factions/faction[@id='ministry']/relations">
    <relation faction="example_guild" relation="0.5" />
  </add>
  <add sel="/factions/faction[@id='scaleplate']/relations">
    <relation faction="example_guild" relation="-0.32" />
  </add>
  <add sel="/factions/faction[@id='khaak']/relations">
    <relation faction="example_guild" relation="-1" />
  </add>
  <add sel="/factions/faction[@id='xenon']/relations">
    <relation faction="example_guild" relation="-1" />
  </add>
  <add sel="/factions/faction[@id='player']/licences">
    <licence type="generaluseship" factions="example_guild" />
    <licence type="generaluseequipment" factions="example_guild" />
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example faction" descr="" voice="no">
    <t id="1">Teladi Trading Guild</t>
    <t id="2">A guild of independent Teladi traders operating under Company licence.</t>
    <t id="3">TTG</t>
    <t id="4">Guild</t>
    <t id="5">Guild Space</t>
    <t id="6">Guild Home</t>
    <t id="11">Guild General Use Ship Licence</t>
    <t id="12">Guild General Use Equipment Licence</t>
    <t id="13">Guild Friendship Ceremony</t>
    <t id="14">Guild Military Ship Licence</t>
  </page>
</language>
```

Some points about the example:

- **Both sides of every relation are written.** The guild's own list and one line in each of the five factions it has a relation with. The player is left at neutral, so no line is needed on either side.
- **The colour is inline**, so no change to `colors.xml` is needed. The icons reuse the Teladi ones; an icon of the faction's own is a diff on `libraries/icons.xml`, and `active` and `inactive` are required.
- **The player holds the guild's general use licences from the start**, as with every vanilla government, which is what lets the player buy its small ships and equipment at once.
- **The Ministry polices the guild's space**, which is why `policefaction` names it and the guild does not carry the `police` tag itself.
- **The relations in the file apply at game start**, as the file's own comment says. In a running game the scripts set them, with `set_faction_relation`.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) is where a faction gets its stations and [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) its ships; both select by faction id. [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) shows how a game start overrides relations for the player.

[↑ Contents](#toc)

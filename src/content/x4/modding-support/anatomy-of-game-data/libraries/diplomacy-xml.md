---
title: diplomacy.xml
description: How libraries/diplomacy.xml defines the diplomacy system of 9.00 - the agent actions with their agent, costs, rewards, timing, success chance and targets, the diplomatic events with their options, the gifts, the experience and rank tables, the influence cost curve and the ship bonus curves, how the expansions add to it, the script side, and how an extension adds an action of its own.
---

# diplomacy.xml

Version 9.00 adds diplomacy to the game. The player headquarters gets an embassy, the factions send diplomats, and the player hires **agents** and sends them on **actions** against another faction: gather influence, improve relations, negotiate a discount, steal a blueprint, spy on a station. An action costs influence, credits and inventory items, takes time, succeeds or fails, and can cost the agent an injury or their life. Two factions can also be drawn into a **diplomatic event** with several possible outcomes, with an agent sent to tilt it. Every action and event, with its costs, chances, texts and rewards, the gifts the factions like, the experience and rank tables of the agents, the influence cost curve and the bonus an agent's ship gives, is defined in `libraries/diplomacy.xml`. The script `md/diplomacy.xml` runs what the file defines.

This article covers the format, what each part means and how the game uses it, how the expansions add to it, the script side and how an extension adds an action of its own. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Agent**: a character hired at the embassy of the player headquarters and sent on actions. An agent has two experience values, negotiation and espionage, and their sum is the agent's rank.
- **Influence**: a single number the player holds, gained by a few actions and spent by most. The file's own comment names its levels: none at 0, very low at 1, low at 2, low-medium at 4, medium at 7, medium-high at 12, high at 20 and very high at 33.
- **Action**: one entry of `<actions>`, something an agent can be sent to do. Starting one creates an **operation**, the running instance the menu and the scripts deal with.
- **Event**: one entry of `<events>`, a situation between two factions with two or three **options**, one of which becomes the outcome when the event ends. Its running instance is an event operation.
- **Gift**: an inventory ware handed over with an action to sway the target faction, called a bribe in the file. The `<gifts>` table says which factions like which ware.
- **Risk**: how dangerous an action or an option is for the agent, from none to very high. A failed action, or an event that ends against the player's choice, can injure or kill the agent.

[↑ Contents](#toc)

## From the menu to the script

A diplomacy action passes between the game and the script, and knowing which side does what explains most of the file.

1. **The menu lists the actions.** The agent view of the Diplomacy menu shows every action of the file that is not hidden, grouped by category, with the name, the descriptions, the recommended agent experience and risk, the costs, the chance and the texts the file gives. For the chosen action the player picks an agent, the target its `<params>` ask for, and a gift if the cost allows one. The game checks whether the action may start: a unique action runs once at a time, a faction-exclusive one once per faction, and a cooling-down one not at all.
2. **The game creates the operation.** It carries the action, the agent, the chosen parameters, the gift and a duration, which the game derives from the action's duration, the player's influence and the agent's ship. The script receives it as `event_diplomacy_action_operation_started`.
3. **The script runs the operation.** Vanilla's `md/diplomacy.xml` has one cue per action. It deducts the influence, the credits, the required wares and the gift, decides success or failure at the start with a seeded roll, so that reloading changes nothing, sends the agent off, waits the operation's duration, and at the end applies the reward, grants experience, rolls the agent's fate after a failure, writes a logbook entry and calls `complete_diplomacy_action_operation`. The game then archives the operation and starts the cooldown.
4. **Events are created by the script.** `create_diplomacy_event_operation` names the event, the two factions and the agent. Vanilla creates one as the reward of the interference action, or at intervals between random factions once Protocol Null is enabled. The event view of the menu shows the options; the player picks one and an agent, which commits the option's cost. When the event's duration ends, the game evaluates the outcome from the options' weights and the agent's rank, and the script applies the outcome's relation between the two factions.

The split matters for anyone adding to the file. The game reads the file and keeps the operations; the effects are the script's. An action added to the file appears in the menu and can be started, and then nothing happens until a script picks the operation up. The example at the end does that.

[↑ Contents](#toc)

## The file

### Layout

```xml
<diplomacy>
  <actions>
    <action id="cultivate_influence" category="negotiation" name="{20235,10101}" description="{20235,10102}" shortdescription="{20235,10103}" unique="true" hidden="false">
      <agent experience="0" type="negotiation" risk="none"/>
      <cost money="5000" maxinfluencefactor="20"/>
      <reward influence="4" text="{20235,10131}"/>
      <time duration="900" cooldown="1200" maxinfluencefactor="10"/>
      <icon active="diplomacy_negotiation" image="diplomacy_banner_gatherinfluence"/>
      <success chance="100" text="{20235,10121}"/>
      <params>
        <param name="station" text="{20235,101}" type="object" isfactionexclusive="true" isagenttarget="true">
          <input_param name="stationtype" value="[stationtype.tradingstation, stationtype.shipyard, stationtype.wharf, stationtype.equipmentdock]"/>
          <input_param name="inrelationrange" value="'dock'"/>
          <input_param name="notinrelationrange" value="'self'"/>
        </param>
      </params>
    </action>
    ...
  </actions>
  <events>
    <event id="friend_diplomatic_insult" name="{20236,30101}" description="{20236,30102}" shortdescription="{20236,30103}" duration="10800">
      <icon image="diplomacy_banner_friend"/>
      <options>
        <option id="friend_diplomatic_insult_cooperation" name="{20236,30111}" description="{20236,30112}" menuposition="-1">
          <agent risk="low"/>
          <cost influence="20" money="500000">
            <wares>
              <ware ware="inv_microbrewdrink" amount="2"/>
              <ware ware="inv_nividiumjewel" amount="1"/>
            </wares>
          </cost>
          <conclusion text="{20236,30151}"/>
          <relation value="0.75"/>
          <result text="{20236,30161}"/>
          <success weight="30" selectionweightbonus="70"/>
        </option>
        ...
      </options>
    </event>
    ...
  </events>
  <gifts>
    <defaults negative="-5" positive="10"/>
    <gift ware="inv_finemeal" faction="[alliance, antigone, argon, hatikvah]"/>
    ...
  </gifts>
  <experience>
    <level value="0" name="{1046,6011}"/>
    ...
  </experience>
  <rank>
    <level value="0" name="{1046,7011}" eventbonus="1.0" icon="diplomacy_agent_recruit"/>
    ...
  </rank>
  <influencecostcurve>
    <influence position="0" value="1"/>
    ...
  </influencecostcurve>
  <ship>
    <bonuses>
      <actions maxdurationreduction="0.5" maxdurationbenefitincrease="1.5"/>
      <curves>
        <dpscurve> ... </dpscurve>
        <prestigecurve> ... </prestigecurve>
        <speedcurve> ... </speedcurve>
      </curves>
    </bonuses>
  </ship>
</diplomacy>
```

The schema, `libraries/diplomacy.xsd`, documents every element and attribute. It includes `aiscripts.xsd`, which is where the parameter types and the lookups come from. `<actions>` and `<events>` are optional in the schema; the other five sections are required. The base file holds the vanilla actions and events, the gifts, the two level tables, the curve and the ship bonus. The expansions touch only the gifts.

Texts are `{page,id}` references: the actions' on page 20235, the events' on page 20236, the level names on page 1046. The file's `text` attributes feed the menu directly, so a new action needs a text for every one it sets.

[↑ Contents](#toc)

### An action, part by part

The `<action>` element:

| Attribute | Meaning |
| --- | --- |
| `id` | The action's identifier, used by the scripts and the menu |
| `category` | `negotiation`, `espionage` or `interference`; the menu groups by it |
| `name`, `description`, `shortdescription` | The texts shown in the menu |
| `hidden` | Whether the action starts out hidden from the menu. A script shows or hides it with `set_diplomacy_action_hidden`. Vanilla starts with Cultivate Influence alone visible and reveals the rest when the agent introduction is done; the Protocol Null pair and the story action are shown and hidden as the story goes |
| `unique` | One operation of this action at a time, whatever the target. The menu says so when a second agent is offered it |
| `triggersevent` | Marks an action that leads to a diplomatic event. Vanilla sets it on Initiate Diplomatic Interference, whose script creates the event as the reward |
| `friendgroup` | Actions sharing a group block each other as one: while one runs or cools down, the others cannot start if either is unique or the target faction is the same. Vanilla's two Improve Relations actions share a group |
| `icon`, `image`, `video` | Shorthand for the `<icon>` child; when `icon` is set the child is ignored |

Its children:

| Element | Meaning |
| --- | --- |
| `<agent experience type risk text>` | The recommended experience of the relevant type, `negotiation` or `espionage`, and the risk to the agent: `none`, `low`, `medium`, `high` or `veryhigh`. The type decides which of the agent's two experience values counts, and the gap between the agent's level and the recommended one moves the success chance |
| `<cost influence money maxinfluencefactor>` | What starting the action takes. `maxinfluencefactor` lets the money cost grow with the influence the player holds, along the cost curve, up to this factor at maximum influence. Vanilla uses it on Cultivate Influence, so gathering influence gets dearer the more one has |
| `<cost><wares tags="..."/>` | A gift may be added, chosen from the inventory wares with this tag. Vanilla uses `bribe`, which the eleven luxury inventory wares of the gift table carry. `<ware ware amount>` children inside are required items on top, taken from the headquarters inventory first and the player's own second |
| `<reward influence money text>` | What success gives. Vanilla pays influence on three actions and writes every other reward in the script: a discount, a blueprint, an inventory item, revealed information. `text` is the reward summary the menu shows. `<wares>` and `<unlocks><unlock id>` children name wares and `unlocks.xml` entries; vanilla's Negotiate Trade Deal names `diplomaticdiscount` |
| `<time duration cooldown durationisbeneficial maxinfluencefactor>` | Seconds. The duration is how long the agent is away, the cooldown how long the action rests after it completes. `durationisbeneficial` marks an action where a longer run is better, the vanilla information and spying actions; the ship bonus then lengthens the run instead of shortening it. `maxinfluencefactor` scales the duration with influence as it does the money cost |
| `<icon active inactive selected image video>` | The icon in the action list and the banner image of its page; the ids are entries of `libraries/icons.xml`. Vanilla sets `active` and `image` only |
| `<success chance text>`, `<failure text>` | The base chance in percent, default 100, and the texts for either outcome. Vanilla's run from 100 on the safe actions down to 30 on the hardest thefts |
| `<params>` | What the player has to pick, below |

How `maxinfluencefactor` and the curve combine: the curve maps the influence held to a multiplier, and the attribute is the multiplier's ceiling for this action, reached at maximum influence. What the multiplier is between the two ends is not documented in the data.

[↑ Contents](#toc)

### Parameters

`<params>` holds either one `<factionpair>` or `<param>` elements, one per value the player picks. The schema declares a single `<param>`; vanilla's three acquire-item actions carry two, a station and a ware, and the game reads both.

| Attribute of `<param>` | Meaning |
| --- | --- |
| `name` | The parameter's name; a script reads the chosen value as `operation.action.$<name>` |
| `type` | One of the order parameter types; vanilla uses `object` for a station or ship and `ware` for an inventory item |
| `text` | The label in the menu |
| `isagenttarget` | The chosen object is where the agent goes, and it is marked on the map with the agent icon |
| `isfactionexclusive` | The chosen object's owner is the action's target faction, and the action cannot run again against that faction until the cooldown ends |
| `warecostfactor` | For a ware parameter, the ware's average price times this factor is added to the money cost. Vanilla's three acquire-item actions use 1.5, 1 and 0.3 against baskets of rising value |

`<input_param name value>` children narrow what the menu offers, with the names order parameters use; the value is an expression. Vanilla uses `class` (a list of classes), `stationtype` (a list of station types), `isfactionhq` (the faction headquarters), `inrelationrange` and `notinrelationrange` (a relation range name as a string: `'dock'`, `'enemy'`, `'killmilitary'`, `'self'`), `excludeanyfactiontags` (`tag.nodiplomacyselection`, which the Kha'ak and the Xenon carry in `factions.xml`) and `warebasket` (a basket id from `libraries/baskets.xml`).

`<factionpair>` asks for two factions instead, named under `<first>` and `<second>` and read by the script as `faction1` and `faction2`. Vanilla uses it for the interference action.

[↑ Contents](#toc)

### The vanilla actions

| Action | Category | Agent | Chance | Influence | Target |
| --- | --- | --- | --- | --- | --- |
| Cultivate Influence `cultivate_influence` | negotiation | negotiation 0, no risk | 100 | 0, rewards 4 | an infrastructure station (trading station, shipyard, wharf or equipment dock) of a faction the player may dock with |
| Improve relations (Low) `improve_relations_low` | negotiation | negotiation 0, no risk | 100 | 1 | the faction headquarters |
| Improve relations (Medium) `improve_relations_medium` | negotiation | negotiation 10, low | 70 | 4 | the faction headquarters |
| Armistice `negotiate_ceasefire` | negotiation | negotiation 50, medium | 40 | 20 | the headquarters of a faction at war with the player |
| Active Station Information `active_station_information` | negotiation | negotiation 10, low | 100 | 2 | any station of a dockable faction; a longer run is better |
| Active Ship Information `active_ship_information` | negotiation | negotiation 20, low | 100 | 2 | an L or XL ship of a dockable faction; a longer run is better |
| Negotiate Trade Deal `negotiate_trade_deal` | negotiation | negotiation 10, no risk | 70 | 2 | a factory, shipyard or wharf; rewards the `diplomaticdiscount` unlock |
| War Declaration `declare_war` | negotiation | negotiation 0, no risk | 100 | 0, rewards 12 | the faction headquarters |
| Build Intelligence Network `build_intelligence_network` | espionage | espionage 12, medium | 50 | 0, rewards 12 | an infrastructure station |
| Steal Equipment Blueprint `steal_blueprint_equipment` | espionage | espionage 20, medium | 50 | 7 | an equipment dock |
| Steal Module Blueprint `steal_blueprint_module` | espionage | espionage 100, high | 30 | 12 | the faction headquarters |
| Steal S/M Ship Blueprint `steal_blueprint_ship_sm` | espionage | espionage 50, medium | 50 | 7 | a wharf |
| Steal L/XL Ship Blueprint `steal_blueprint_ship_lxl` | espionage | espionage 100, very high | 30 | 20 | a shipyard |
| Spy on Station `spy_station` | espionage | espionage 50, high | 70 | 7 | a station of an enemy faction; a longer run is better |
| Spy on Ship `spy_ship` | espionage | espionage 100, high | 70 | 12 | an L or XL ship of an enemy faction; a longer run is better |
| Acquire common, uncommon, rare item `acquire_inventory_item_low`, `_medium`, `_high` | espionage | espionage 20, 50, 100; risk none, low, medium | 80, 50, 30 | 2, 4, 7 | a station, plus a ware from the matching basket |
| Initiate Diplomatic Interference `initiate_diplomatic_interference` | interference | espionage, no risk | 100 | 12 | two factions |
| Enable Protocol Null `enable_protocol_null` | interference | espionage 50, no risk | 100 | 7 | none |
| Disable Protocol Null `disable_protocol_null` | interference | espionage 0, no risk | 100 | 0 | none |
| Fate of Heretic's End `enable_factionlogic_hereticsend` | interference | negotiation 0, no risk | 100 | 0 | none; a story action |

Money costs run from nothing to millions on the ship blueprint thefts, and the required wares, where there are any, are the security and luxury inventory items. Every action with a chance below 100 has a `<failure>` text. Three actions without a target are the Protocol Null pair and the story action; their script does the work on its own.

The success roll, as vanilla's script makes it: a chance of 100 always succeeds; otherwise the agent's relevant experience and the recommended experience are each placed in a band (below 10, 20, 50, 100, 200 and above), ten percent per band of difference is added or taken, the gift's effect is added, the sum is capped at 99 and rolled once at the start. The bands are the thresholds of the `<experience>` table, but the script carries them as numbers of its own, so a changed table does not move them.

[↑ Contents](#toc)

### An event, part by part

The `<event>` element carries `id`, the texts `name`, `description` and `shortdescription`, a `duration` in seconds, and an `icon`, `image` and `video` or an `<icon>` child like an action's. A `<conclusion text>` on the event itself is allowed; vanilla writes one per option instead. The options sit under `<options>`:

| Element of `<option>` | Meaning |
| --- | --- |
| `id`, `name`, `description` | The option's identifier and texts |
| `menuposition` | Where the option sits in the event page: -1 left, 0 centre, 1 right |
| `<agent risk>` | The risk to the agent of backing this option |
| `<cost influence money><wares>` | What backing it costs; the wares are required items |
| `<conclusion text>`, `<result text>` | The texts shown when this option becomes the outcome |
| `<relation value>` | The relation the two factions are set to if this option wins |
| `<success weight selectionweightbonus text>` | The option's weight in the draw, default 100, and the bonus added to it when the player backs this option, default 20, scaled by the agent's rank `eventbonus`. `guaranteed` makes the backed option the outcome whatever the other weights |

Vanilla has sixteen events in five groups named by their prefix: ally, friend, neutral, enemy and hostile. The script picks the group from the relation between the two factions: an enemy relation gives a hostile event when they are in the kill range and an enemy event otherwise, a friendly relation an ally event when they are in the member range and a friend event otherwise, anything else a neutral event, and then one event of the group at random. Ally and hostile events have two options, the others three: cooperation on the left, status quo in the centre, escalation on the right. Every status quo option is `guaranteed` when backed; cooperation and escalation carry a bonus against weights that favour the status quo. The relation values used are 0.75, 0.032, 0, -0.11 and -0.66, one in each of the ally, friend, neutral, enemy and kill ranges that [factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) defines.

How vanilla's script runs an event: while the event is open the faction pair is excluded from further events with `set_faction_diplomacy_exclusion`, and released at the end. The player's option is committed on `event_diplomacy_event_operation_option_chosen`, which is when its cost is taken; the agent can be swapped until then. After the duration `evaluate_diplomacy_event_operation_outcome` gives the winning option, and the script applies its relation with `set_faction_relation` only when it moves the two factions into another relation range. An agent backing an option that lost rolls for injury and death by the option's risk: fifteen, twenty-five, forty and seventy percent to be injured and nought, five, twenty and thirty to be killed, for low to very high. An injured agent is out for a while; a killed one is removed with their ship.

Where events come from: vanilla creates one as the reward of Initiate Diplomatic Interference, between the two factions the player chose, and, once Enable Protocol Null has run, one at intervals between two random factions that may feature in events, with no agent attached until the player sends one. Nothing else in vanilla creates an event, and no event in the file names the factions it is for; the script supplies them.

[↑ Contents](#toc)

### Gifts

`<gifts>` says how a gift changes an action's success chance. `<defaults negative positive>` gives the percentages when the ware is not in the receiving faction's taste and when it is; vanilla has -5 and +10. Each `<gift ware faction>` lists the factions that like the ware, as one id or a list, with `<faction faction>` children adding more; `negative` and `positive` on a gift override the defaults. A ware not in the table at all has no gift effect, and the menu only offers wares with the tag the action's `<cost><wares>` names.

The base table, which the expansions extend:

| Ware | Liked by |
| --- | --- |
| `inv_spacedyepizza` | alliance |
| `inv_finemeal` | alliance, antigone, argon, hatikvah |
| `inv_aquaponicvegetable` | alliance |
| `inv_microbrewdrink` | antigone, argon |
| `inv_infusedbeverage` | buccaneers |
| `inv_neuralstimulator` | paranid, holyorder, ministry, trinity, teladi |
| `inv_harmonicresonator` | antigone |
| `inv_nividiumjewel` | buccaneers, teladi |
| `inv_majaglit` | paranid, holyorder, ministry, trinity |
| `inv_rareartefact` | alliance |
| `inv_xenotext` | alliance, antigone, argon, paranid, hatikvah, holyorder, trinity, teladi |

A comment above the live entries holds the full table with every faction, expansions included; the live entries keep the base factions and each expansion adds its own. The menu shows a gift's effect on the chosen faction only once it is known: a question mark before, an arrow up or down after. A script marks it known with `set_diplomacy_gift_known`; vanilla does so when an action with a gift completes.

[↑ Contents](#toc)

### Experience and rank

`<experience>` names the levels an agent's experience value is shown as, one `<level value name>` per step, and `<rank>` the levels of the agent's rank, the sum of both values, each with an `icon` and an `eventbonus`:

| Experience | Name | | Rank | Name | Event bonus |
| --- | --- | --- | --- | --- | --- |
| 0 | Unskilled | | 0 | Recruit | 1.0 |
| 10 | Novice | | 20 | Apprentice | 1.1 |
| 20 | Competent | | 50 | Asset | 1.3 |
| 50 | Proficient | | 100 | Operative | 1.6 |
| 100 | Experienced | | 200 | Handler | 2.0 |
| 200 | Expert | | 400 | Spymaster | 2.5 |

The agent list shows each agent's two experience names and their rank with its icon. The event bonus multiplies an option's `selectionweightbonus` when the agent backs it, so a Spymaster tilts an event two and a half times as hard as a Recruit. The experience values themselves live on the agent as script variables, `$diplomacy_exp_negotiation` and `$diplomacy_exp_espionage`, and vanilla's script adds to them after every completed action and event: a roll by the risk taken, from one to eight for a safe action up to five to fifteen for a very risky one, all of it to the action's agent type and a fifth to the other, or split equally after an event.

[↑ Contents](#toc)

### The influence cost curve

`<influencecostcurve>` is a set of points, `<influence position value>`, with the influence the player holds on one axis and a multiplier on the other. Vanilla's rises from 1 at no influence through 3 at medium, 8 at high and 13 at very high to 20 at 54. An action with `maxinfluencefactor` on its cost or its time is scaled along it, so the few actions that gather influence slow down and get dearer as the stock grows.

[↑ Contents](#toc)

### The ship bonus

An agent can be given a ship, from the agent list or by script with `assign_diplomacy_ship`; a ship docked at the headquarters is stored for the purpose and handed to the civilian faction. `<ship><bonuses>` says what it is worth. The three curves under `<curves>` each map one property of the ship to a score: `<dpscurve>` its damage per second, `<prestigecurve>` its prestige, `<speedcurve>` its top travel speed. Vanilla's reach 0.25 each for damage and speed and 0.5 for prestige, and the schema says the scores combine into one that tops out at 1.0. `<actions maxdurationreduction maxdurationbenefitincrease>` is what a full score does to an action's duration: vanilla's 0.5 halves it, and for an action with `durationisbeneficial` the 1.5 lengthens it by half instead.

[↑ Contents](#toc)

## How the expansions change it

Every expansion ships a `<diff>` on the file, and all five do the same thing: `<add>` a `<faction>` child to the gift entries for the expansion's own factions, Boron for Kingdom End, scavenger and loanshark for Tides of Avarice, split, freesplit and court for Split Vendetta, pioneers, terran and yaki for Cradle of Humanity, kaori for Timelines. The pairs the designers decided against are left in the diff as comments, so each file shows the whole choice. No expansion adds an action or an event, and none changes the tables or the curves.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `diplomacy.action.{$id}.<property>` | The file's data for an action: `exists`, `name`, `description`, `shortdescription`, `successtext`, `failuretext`, `rewardtext`, `ishidden`, `isunique`, `successchance`, `duration`, `cooldown`, `agent.experience`, `agent.type`, `agent.risk`, `cost.influence`, `cost.money`, `cost.wares`, `cost.gifttags`, `reward.influence`, `reward.money`, `reward.wares`, `reward.unlocks` |
| `diplomacy.event.{$id}.<property>` | The same for an event: `name`, `description`, `shortdescription`, `conclusiontext`, `duration`, `options`, and `option.{$optionid}` with `weight`, `relation`, `agent.risk`, `cost.influence`, `cost.money`, `cost.wares`, `conclusiontext`, `resulttext` |
| `diplomacy.actions.list`, `diplomacy.events.list` | Every action or event id |
| `diplomacy.actions.gifteffect.{$ware}.{$faction}` | The gift table's percentage for a ware and a faction |
| `diplomacy.influence.{$value}` | The influence level a value falls in, with `name`, `min` and `max` |
| `player.influence` | The influence the player holds |
| `player.agents.list`, `.capacity`, `.free`, `.max`, `.research.{$n}` | The player's agents, how many fit now and at most, and the research ware that unlocks a given number of slots |
| `$faction.isdiplomacyactive`, `.arediplomacyeventsallowed`, `.isdiplomacyexcluded.{$other}` | Whether a faction takes part in diplomacy, may feature in events, and is currently locked against another faction |
| An action operation | `action.id`, `action.gift`, `action.$<param>` for each parameter, `agent`, `agentresult`, `duration`, `starttime`, `owner` |
| An event operation | `event.id`, `faction`, `otherfaction`, `agent`, `source` (the action operation that caused it), `option` (the backed one), `outcome` |
| `event_diplomacy_action_operation_created`, `..._started`, `..._completed`, `..._aborted` | An action operation's life; `param` is the operation. The menu starts operations, so a script meets them at `..._started` |
| `event_diplomacy_event_operation_created`, `..._started`, `..._option_chosen`, `..._completed`, `..._aborted` | An event operation's life; `param2` of `option_chosen` is the option id |
| `event_player_influence_updated` | The influence changed: `param` the old value, `param2` the new |
| `complete_diplomacy_action_operation operation success agentresult` | Ends an action operation with its result; the game archives it and starts the cooldown |
| `create_diplomacy_action_operation`, `start_diplomacy_action_operation` | Create and start an action operation from script, with `<param>` children for its parameters; unused in vanilla, where the menu does it |
| `create_diplomacy_event_operation`, `start_diplomacy_event_operation` | Create an event operation for an event, two factions, an agent and optionally a `source` action operation, and start it |
| `evaluate_diplomacy_event_operation_outcome`, `complete_diplomacy_event_operation` | Draw the winning option from the weights, the backed option and the agent's rank, then end the operation with it |
| `set_diplomacy_action_hidden action hidden` | Show or hide an action in the menu |
| `set_diplomacy_gift_known faction ware` | Make a gift's effect on a faction visible in the menu |
| `set_faction_diplomacy_active`, `set_faction_diplomacy_events_allowed` | Let a faction take part in diplomacy, and feature in events |
| `set_faction_diplomacy_exclusion`, `clear_faction_diplomacy_exclusion` | Lock and unlock diplomacy between two factions for a flagged reason |
| `recruit_diplomacy_agent`, `dismiss_diplomacy_agent` | Make an entity one of the player's agents, and release one |
| `assign_diplomacy_ship`, `unassign_diplomacy_ship` | Give an agent a ship, and take it back |
| `set_player_influence`, `apply_player_influence` | Set the influence, or add to it; both keep it in the valid range |

Which factions take part at all is the script's decision: vanilla's `md/diplomacy.xml` activates them one by one with `set_faction_diplomacy_active` and `set_faction_diplomacy_events_allowed` as the story reaches them, and the expansion setup scripts lock some pairs with `set_faction_diplomacy_exclusion` until their stories allow it. The agents themselves are characters that `md/npc_agent.xml` recruits at the embassy with `recruit_diplomacy_agent` and places with its `Update_AgentPlacement` cue.

[↑ Contents](#toc)

## Adding an action from an extension

A new action is a diff on `libraries/diplomacy.xml`, a text page, and a script that runs its operations. The example below, for a fictional extension `example_diplomacy`, adds a negotiation action that sells a trade route survey to a factory of a faction the player may dock with: it costs a little influence and money, allows a gift, takes twenty minutes, succeeds seven times in ten, and pays credits and a point of influence. The same diff also adds a faction to one gift entry, the way the expansions do.

`libraries/diplomacy.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/diplomacy/actions">
    <action id="example_survey_contract" category="negotiation" name="{1234567,1}" description="{1234567,2}" shortdescription="{1234567,3}" unique="false" hidden="false">
      <agent experience="10" type="negotiation" risk="low"/>
      <cost influence="1" money="25000">
        <wares tags="bribe"/>
      </cost>
      <reward influence="1" money="200000" text="{1234567,31}"/>
      <time duration="1200" cooldown="1800"/>
      <icon active="diplomacy_negotiation" image="diplomacy_banner_assignagent"/>
      <failure text="{1234567,11}"/>
      <success chance="70" text="{1234567,21}"/>
      <params>
        <param name="station" text="{1234567,101}" type="object" isfactionexclusive="true" isagenttarget="true">
          <input_param name="stationtype" value="[stationtype.factory]"/>
          <input_param name="inrelationrange" value="'dock'"/>
          <input_param name="notinrelationrange" value="'self'"/>
          <input_param name="excludeanyfactiontags" value="tag.nodiplomacyselection"/>
        </param>
      </params>
    </action>
  </add>
  <add sel="/diplomacy/gifts/gift[@ware='inv_finemeal']">
    <faction faction="teladi"/>
  </add>
</diff>
```

`md/example_diplomacy.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Diplomacy" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="SurveyContract" instantiate="true" namespace="this">
      <conditions>
        <event_diplomacy_action_operation_started/>
        <check_value value="event.param.action.id == 'example_survey_contract'"/>
      </conditions>
      <actions>
        <set_value name="$Operation" exact="event.param"/>
        <set_value name="$ActionID" exact="$Operation.action.id"/>
        <set_value name="$Agent" exact="$Operation.agent"/>
        <set_value name="$Station" exact="$Operation.action.$station"/>
        <set_value name="$Faction" exact="$Station.owner"/>
        <run_actions ref="md.Diplomacy.CostDeduction_DiplomaticAction">
          <param name="Operation" value="$Operation"/>
        </run_actions>
        <run_actions ref="md.Diplomacy.Success_Evaluation" result="$Result">
          <param name="ActionID" value="$ActionID"/>
          <param name="Agent" value="$Agent"/>
          <param name="Bribe" value="$Operation.action.gift"/>
          <param name="Faction" value="$Faction"/>
        </run_actions>
        <set_value name="$Success" exact="$Result.{1}"/>
        <set_value name="$AgentOutcome" exact="$Result.{3}"/>
        <signal_cue_instantly cue="md.NPC_Agent.Update_AgentPlacement" param="[$Agent, ['on_mission']]"/>
      </actions>
      <cues>
        <cue name="Countdown">
          <delay exact="$Operation.duration"/>
          <actions>
            <signal_cue cue="Finish"/>
          </actions>
        </cue>
        <cue name="Aborted">
          <conditions>
            <event_diplomacy_action_operation_aborted operation="$Operation"/>
          </conditions>
          <actions>
            <cancel_cue cue="Countdown"/>
            <signal_cue_instantly cue="md.NPC_Agent.Update_AgentPlacement" param="[$Agent, ['hq_available']]"/>
            <cancel_cue cue="parent"/>
          </actions>
        </cue>
        <cue name="Finish">
          <conditions>
            <event_cue_signalled/>
          </conditions>
          <actions>
            <do_if value="$Success">
              <reward_player money="diplomacy.action.{$ActionID}.reward.money"/>
              <apply_player_influence influence="diplomacy.action.{$ActionID}.reward.influence"/>
              <do_if value="$Operation.action.gift">
                <set_diplomacy_gift_known faction="$Faction" ware="$Operation.action.gift"/>
              </do_if>
            </do_if>
            <do_elseif value="$AgentOutcome != agentresult.survived">
              <run_actions ref="md.Diplomacy.Risk_EvaluateOutcome" result="$AgentOutcome">
                <param name="AgentOutcome" value="$AgentOutcome"/>
                <param name="Agent" value="$Agent"/>
              </run_actions>
            </do_elseif>
            <do_if value="$AgentOutcome == agentresult.survived">
              <run_actions ref="md.Diplomacy.AgentExperience_RewardEvaluation">
                <param name="ActionID" value="$ActionID"/>
                <param name="Risk" value="diplomacy.action.{$ActionID}.agent.risk"/>
                <param name="Agent" value="$Agent"/>
              </run_actions>
              <signal_cue_instantly cue="md.NPC_Agent.Update_AgentPlacement" param="[$Agent, ['hq_available']]"/>
            </do_if>
            <complete_diplomacy_action_operation operation="$Operation" success="$Success" agentresult="$AgentOutcome"/>
            <cancel_cue cue="parent"/>
          </actions>
        </cue>
      </cues>
    </cue>
  </cues>
</mdscript>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example diplomacy" descr="" voice="no">
    <t id="1">Negotiate Survey Contract</t>
    <t id="2">The agent offers a factory a survey of the trade routes around it. The owner pays for the report and remembers who delivered it.</t>
    <t id="3">Sell a trade route survey to a factory.</t>
    <t id="11">The factory manager had no budget for outside reports.</t>
    <t id="21">The survey was accepted and paid for.</t>
    <t id="31">Credits and a little influence</t>
    <t id="101">Factory</t>
  </page>
</language>
```

Some points about the example:

- **The file entry is the menu's part, the script is the rest.** With the diff alone the action shows up, takes an agent and a factory, and can be started; the cost would stay unpaid and the operation would run forever. The script picks the operation up at `event_diplomacy_action_operation_started`, keyed on the action id, and ends it with `complete_diplomacy_action_operation`.
- **Vanilla's libraries do the bookkeeping.** `md/diplomacy.xml` keeps its cost deduction, success roll, agent risk and experience award in libraries, which the example calls as `md.Diplomacy.<name>`, the form vanilla uses for a library of another script, and `md.NPC_Agent.Update_AgentPlacement` is the cue vanilla itself signals to move an agent out of the embassy and back. Reusing them keeps the new action in step with the vanilla ones: the same seeded roll, the same experience bands, the same injury rules, the gift marked known.
- **The reward is the script's to pay.** The entry's `<reward>` is read back through `diplomacy.action.{$ActionID}.reward.money` and `.reward.influence`, so the numbers stay in the data file where they can be tuned.
- **`hidden="false"`** shows the action from the start. Vanilla's generic actions are hidden until the agent introduction has run; a new action can follow that pattern by starting hidden and being revealed with `set_diplomacy_action_hidden` from a cue that waits for the same point.
- **`isfactionexclusive`** on the station parameter makes the action's target faction the station's owner, which is what the success library compares the gift against, and keeps a second agent off the same faction until the cooldown ends.
- **Left out**: what vanilla adds around each action, the agent clone that travels to the target, the abort when the target is destroyed, and the logbook entry. The script is the smallest complete one, not the fullest.
- **The id and the texts** are the extension's own: the action id must not collide with another extension's, and page 1234567 stands for the extension's page.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) defines the relation ranges the events' outcomes and the parameters' relation filters refer to, and the `nodiplomacyselection` tag. [unlocks.xml](/x4/modding-support/anatomy-of-game-data/libraries/unlocks-xml/) holds the `diplomaticdiscount` entry that Negotiate Trade Deal rewards. [stats.xml](/x4/modding-support/anatomy-of-game-data/libraries/stats-xml/) has the counters the diplomacy script writes.

[↑ Contents](#toc)

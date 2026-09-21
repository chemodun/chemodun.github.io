---
title: XML diff patching
description: The patch format X4 uses to change data it already defines - add, replace and remove, what sel really accepts, pos, conditional patches with if, silent, and how to write a selection that survives a game update.
order: 1
wiki: XML diff patching
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# XML diff patching

Changing a value the game already defines means editing a file that belongs to the game. Shipping an edited copy would work exactly once, until the next update changed the original and the copy silently reverted every other change in it.

A patch avoids that. Instead of a new file, an extension ships a list of edits to apply to whatever is there when it loads. A game update that moves something the patch does not mention changes nothing about the patch. A patch is also the only way two extensions can change the same file and both survive.

This page is the reference for that format. It follows on from [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/), which covers where patch files go and when a patch is needed at all.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## What a patch file is

A patch is an ordinary XML file whose root element is `<diff>`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/wares/ware[@id='ice']/price/@average">32</replace>
</diff>
```

**The file's path decides what it patches.** A patch at `libraries/wares.xml` inside an extension patches the game's `libraries/wares.xml`. There is no attribute naming the target; position in the tree is the whole connection. A patch in the wrong place does not fail loudly, it simply never runs.

**The operations run in document order**, top to bottom. A later operation sees the result of an earlier one, so a patch can add an element and then select into it.

**The root element is the only thing that marks a file as a patch.** The same path with `<wares>` as its root is a whole file and behaves completely differently, as [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/#how-a-file-joins-the-game) describes.

The format is modelled on [RFC 5261](https://datatracker.ietf.org/doc/html/rfc5261), and the game validates it against `libraries/diff.xsd`, which ships with the game data and is the authority for everything on this page.

[↑ Contents](#toc)

## The three operations

### add

Inserts new content at the selection.

```xml
<add sel="/wares">
  <ware id="inv_example_datachip" name="{9999001,101}" transport="inventory" volume="1">
    <price min="800" average="1000" max="1200" />
  </ware>
</add>
```

`sel` selects the element to add **into**, and everything between the tags is inserted as its child. With no `pos` attribute the new content is appended as the last child. See [Where new content lands](#where-new-content-lands) for the alternatives.

An `add` may carry any number of children, so several elements can be inserted in one operation.

### replace

Substitutes the selection.

```xml
<replace sel="/wares/ware[@id='ice']/price/@average">32</replace>
```

`replace` takes exactly one thing: one element to stand in for the selected element, or, when the selection is an attribute, the text that becomes its new value.

Replacing an element replaces it entirely, including its children. To change one attribute, select the attribute rather than the element.

### remove

Deletes the selection, and takes no content:

```xml
<remove sel="/gamestarts/gamestart[@id='x4ep1_gamestart_tutorial2']/player/blueprints/ware[@ware='module_par_pier_l_01']" silent="true"/>
```

The selection may be an element, with all of its children, or a single attribute.

[↑ Contents](#toc)

## sel, and why it is not XPath

Every operation selects with `sel`, and `sel` looks like XPath. It is not XPath. It is a deliberately small subset, and the schema rejects the rest. Expressions that any XPath tool would evaluate happily are simply not part of the format.

Knowing the boundary saves a great deal of time, because the failure is not a helpful error about an unsupported function. Everything here is taken from the grammar in `libraries/diff.xsd`.

### What is accepted

| Form | Example | Notes |
|---|---|---|
| Absolute path | `/wares/ware` | From the document root |
| Descendant search | `//ware` | At any depth |
| Wildcard step | `/wares/*` | Any element name |
| Attribute predicate | `ware[@id='ice']` | Single or double quotes |
| Child-value predicate | `ware[name='Ice']` | Matches on a child element's text |
| Self-value predicate | `t[.='Ice']` | Matches on the element's own text |
| Position predicate | `ware[3]` | 1-based |
| Several predicates | `ware[@id='ice'][@transport='solid']` | Applied in order, and this is how most robust selections are written |
| Attribute target | `ware[@id='ice']/@volume` | `replace` and `remove` only, see below |
| Function predicate | `ware[not(price)]` | The function set below, at most one, and last in the step |
| Node tests | `text()`, `comment()`, `processing-instruction()` | With an optional position, as in `text()[2]` |
| `id()` | `id('something')` | At the start of a path |

The function set is exactly: `not()`, `boolean()`, `true()`, `false()`, `name()`, `root()`, `position()`, `last()`.

### What is not accepted

The absences that cost the most time:

- **No `and` or `or`.** There is no way to write a single predicate matching two alternatives. Several predicates on one step are combined as *and*, and there is no equivalent for *or*.
- **No string functions.** `contains()`, `starts-with()`, `substring()` and the rest are not in the grammar.
- **No comparison operators.** `[@volume>8]` is not expressible, only equality.
- **No parent or sibling axes.** No `..`, no `following-sibling`, no `ancestor`. A path goes downward only. The one axis that exists is `namespace::`.
- **No arithmetic, no variables, no union with `|`.**

The practical consequence is that a selection is built from names, positions and equality tests, and nothing else. That is usually enough, because the data is heavily attributed and almost everything worth selecting has an `id`.

### A restriction specific to add

`add` cannot select an attribute. The schema gives `add` a different, narrower type for `sel` than `replace` and `remove` get, and it stops the path at an element or a node test.

This is not an oversight, and it is not a limitation either: adding an attribute is done with [the `type` attribute](#adding-an-attribute) instead.

### Coming from the forum guide

The long-standing [XML Patch Guide](https://forum.egosoft.com/viewtopic.php?t=354310) on the Egosoft forum covers this format and predates X4. Two things in the surrounding discussion do not apply here. A `ws` attribute on `remove` and an `msel` attribute for selecting several nodes are both absent from X4's schema and appear nowhere in the shipped game data. Neither is available.

[↑ Contents](#toc)

## Working with attributes

### Changing an attribute

End the path at the attribute, and put the new value in the element's text:

```xml
<replace sel="/defaults/dataset[@class='ship_xl']/properties/hull/@max">42000</replace>
```

### Removing an attribute

The same selection, with `remove`:

```xml
<remove sel="/defaults/dataset[@class='ship_xl']/properties/hull/@max" />
```

### Adding an attribute

Because `add` cannot select an attribute, it names the attribute separately. `sel` selects the **element**, `type` names the attribute, and the element's text is the value:

```xml
<add sel="//cue[@name='Place_DataVaults_Unlocked1']/conditions/check_any" type="@chance">50</add>
```

The `@` in `type` is required.

Adding an attribute that already exists is not how to change it. Use `replace` on the attribute for that.

[↑ Contents](#toc)

## Where new content lands

`add` takes an optional `pos`, and it has exactly three values:

| `pos` | Effect |
|---|---|
| *(omitted)* | Appended inside the selection, as its last child |
| `prepend` | Inserted inside the selection, as its first child |
| `before` | Inserted as the selection's preceding sibling |
| `after` | Inserted as the selection's following sibling |

There is no `append`; leaving `pos` out is how appending is expressed.

Note what the selection means in each case. With `prepend` or no `pos`, `sel` names the **parent** to insert into. With `before` or `after`, `sel` names a **sibling** to insert next to.

```xml
<add sel="/materiallibrary" pos="prepend">
  <collection name="example">...</collection>
</add>
```

Order rarely matters in the data tables, where entries are looked up by id. It matters a great deal in scripts, where cues and actions run in the order they appear, and in files where the first match wins.

[↑ Contents](#toc)

## Conditional patching

Any of the three operations may carry an `if`, and the operation is skipped unless the condition holds. This is how one package adapts to what else the player has installed, and it is the least known part of the format despite being used throughout the shipped expansions.

The condition is normally an existence test: a path holds when it selects something.

```xml
<add sel="/factions/faction[@id='alliance']/relations" if="not(//faction[@id='terran'])">
  <relation faction="terran" relation="0.25" />
</add>
```

That is from the Timelines expansion, and it reads directly: define this relation only when nothing else has defined the Terran faction. When the Terran expansion is installed it defines that faction, and its own relations, and this operation stands aside.

The full range of real conditions in the shipped expansions is small, and all four are existence tests:

```none
if="//station[@id='torus_maze']"
if="/wares/production/method[@id='closedloop']"
if="/wares/production/method[@id='terran']"
if="not(//faction[@id='terran'])"
```

`if` accepts a path, a path wrapped in `not()`, or a bare function such as `last()`. Note the asymmetry with predicates: `not()` in an `if` takes a whole path, while `not()` inside a predicate takes only a plain element name.

The condition is evaluated against the document being patched, so it can only test what is in that file. To test whether an extension is installed, test for something that extension puts in the same file, which is exactly what the Terran example does.

[↑ Contents](#toc)

## When a patch does not apply

A patch whose `sel` matches nothing is reported in the game log. That is the right default: it is how a patch that broke in an update gets noticed.

When the selection is *expected* to be absent sometimes, `silent` suppresses the report:

```xml
<remove sel="/gamestarts/gamestart[@id='x4ep1_gamestart_tutorial2']/player/blueprints/ware[@ware='module_par_pier_l_01']" silent="true" />
```

`silent` is available on all three operations, and accepts `true`/`false` or `1`/`0`.

It is worth being strict about when to use it. `silent` is right when the absence is a legitimate state, such as removing an entry another extension may already have removed, or patching a DLC file for players who may not own the DLC. It is wrong as a way to quieten a log full of warnings, because that is the mechanism that tells an author their extension broke.

`if` and `silent` solve different halves of the same problem and are often better together. `if` decides whether an operation should run; `silent` accepts that it may find nothing when it does.

[↑ Contents](#toc)

## The one-node rule

**`sel` must identify exactly one node** for `replace` and `remove`. A selection matching several is an error, not an invitation to change them all. There is no multi-node operation in the format, and repeating the operation once per target is the only way to reach several.

`add` is under the same requirement for the element it adds into.

Two failure modes follow, and they look nothing alike.

**Matching nothing** is reported in the log and the operation is skipped. Everything else in the file still applies, so the symptom is usually one setting that did not take effect while the rest of the extension works.

**Matching several** is the more confusing one, because the selection worked when it was written. A path such as `//ware[@transport='inventory']` is unique in no version of the game for long.

[↑ Contents](#toc)

## Writing a selection that survives

A patch is only as durable as its `sel`. The difference between a patch that outlives several game updates and one that breaks on the next is almost entirely in how the selection is written.

**Select on an id, not on a position.** `/wares/ware[15]` names whatever happens to be fifteenth today. `/wares/ware[@id='ice']` names the same thing next year. Position predicates exist for the files that have nothing else to select on, and are a last resort everywhere else.

**Anchor to the shallowest thing that is unique.** A path spelling out every level breaks when any one of them is reorganised. Where an id makes a descendant search unambiguous, `//ware[@id='ice']` is more durable than the full path to it.

**Add a second predicate rather than a longer path.** `ware[@id='ice'][@transport='solid']` stays unique without depending on the tree's shape.

**Do not select on text a player might see.** Anything displayed is a text reference that can be re-pointed, and translations change.

**Patch the smallest thing that achieves the change.** Replacing a whole element to change one attribute quietly reverts every other change in that element, including changes made by other extensions. Attribute-level operations are what make two extensions able to modify the same entry.

That last point is the one that decides how well an extension coexists with others. Two extensions replacing the same element conflict, and the one loaded later wins. Two extensions replacing two different attributes of it do not conflict at all.

Load order is set by dependencies, as described in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/#dependencies). It is worth knowing that it decides who wins a genuine conflict, and worth not relying on, because it is not something an author controls on a player's machine.

[↑ Contents](#toc)

## Debugging a patch

Patch failures are reported in the game log, which is not on by default. Turning it on is the single most useful thing to do before writing patches, because the alternative is guessing why a change did nothing.

The failures worth recognising:

- **Nothing in the log and no effect.** The file is almost certainly in the wrong place, or its root element is not `<diff>`, so it was never treated as a patch at all.
- **A reported selection failure.** The path does not match. The usual causes are a level of the tree that does not exist, a typo in an id, or a predicate on an attribute the element does not carry.
- **A validation error on load.** The `sel` expression is outside the accepted grammar. Check it against [What is accepted](#what-is-accepted); an `and`, a `contains()` or a `..` is the usual culprit.
- **The patch applies but something else is wrong.** Another extension is patching the same thing, or a whole file elsewhere is contributing a competing entry.

Two habits make the rest straightforward. Build a patch one operation at a time, confirming each before adding the next, because a file of twenty operations gives no clue which one failed. And read the original file first, in the form the game actually has it, rather than from memory or from an older version.

Unpacking the game's own catalogs to read them is covered by [X Catalog Tool](/x4/modding-support/x-catalog-tool/).

[↑ Contents](#toc)

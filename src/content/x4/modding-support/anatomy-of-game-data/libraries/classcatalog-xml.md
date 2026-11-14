---
title: classcatalog.xml
description: What libraries/classcatalog.xml holds - a catalog of names per component class, in vanilla the background scenes of the clusters and the cluster macros - how the names relate to the component index and the map files, how the expansions add their own, how complete the list is, and what it means for an extension that brings a cluster background of its own.
---

# classcatalog.xml

`libraries/classcatalog.xml` is a catalog: for a component class it lists names, the **templates** and the **macros** of that class. In vanilla it has two blocks. One lists the background scenes of the clusters, the components that hold a cluster's planets, sun, nebulae and lighting. The other lists the cluster macros. It is a short file with nothing but names, and of all the files in `libraries/` it is the one with the least visible effect: no script, menu or other data file refers to it.

This article covers the format, what the names stand for, how the expansions extend the file and how far the list goes. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Component**: the definition of a model with its parts and connections, a file under `assets/`, found by its name through `index/components.xml`.
- **Macro**: a configured use of a component, found by its name through `index/macros.xml` or defined in a map file.
- **Class**: the kind of a component or macro, such as `celestialbody` or `cluster`.
- **Template**: the catalog's word for a component name.
- **Cluster background**: a component of class `celestialbody` that a cluster macro places as its content: everything seen in the distance of that cluster's sectors.

[↑ Contents](#toc)

## The file

### Layout

```xml
<catalogs>
  <catalog class="celestialbody">
    <template name="bg_viewer_nolight"/>
    <template name="bg_viewer_onelight"/>
    ...
    <template name="cluster_01"/>
    <template name="cluster_02"/>
    ...
  </catalog>
  <catalog class="cluster">
    <macro name="cluster_01_macro"/>
    <macro name="cluster_02_macro"/>
    ...
  </catalog>
</catalogs>
```

| Element | Attribute | Meaning |
| --- | --- | --- |
| `<catalog>` | `class` | The class the block lists names for, required. There is at least one block |
| `<template>` | `name` | A template name, required |
| `<macro>` | `name` | A macro name, required |

A block may hold any number of `<macro>` and `<template>` entries. The schema, `libraries/classcatalog.xsd`, defines no more than this. Its own description of the root calls the file a macro catalog.

[↑ Contents](#toc)

### What the names stand for

The **templates** of the `celestialbody` block are component names. Each has an entry in `index/components.xml`:

- `cluster_01`, `cluster_02` and the rest are the background scenes of the clusters, under `assets/environments/cluster/`. A cluster macro in the map's `clusters.xml` places its scene in the `content` connection, as `<component connection="space" ref="Cluster_01"/>`.
- The `bg_viewer_*` names are scenes under `assets/system/`, named after the lights they hold: none, one, two or three. `cluster_black` and its variants are, by their names, black backgrounds with or without a light.
- Names with a suffix, such as `cluster_23b` or `cluster_713_v2`, are further scenes for the same cluster number.

The **macros** of the `cluster` block are the cluster macros of the map, `cluster_01_macro` and on, the macros `maps/xu_ep2_universe/clusters.xml` defines.

[↑ Contents](#toc)

### How far the list goes

The catalog is not a full list of what the game has, and the game does not depend on it being one:

- **The base map has clusters the catalog does not list.** The newest cluster macros of the base `clusters.xml` have no `<macro>` entry, and several background components that are in the component index, among them newer variants, have no `<template>` entry. Those clusters are in the game like any other.
- **Nothing in the data files reads the catalog.** No MD or AI script, no interface file and no other library names it or takes a name from it.

What the game needs to find a background scene is the component's entry in `index/components.xml` and the cluster macro that refers to it. What the game itself does with the catalog is not visible in its data.

[↑ Contents](#toc)

## How the expansions change it

Every story expansion ships a `libraries/classcatalog.xml` of its own: a whole file with the same two blocks, holding the background scenes and the cluster macros of that expansion's part of the map. The files are gathered with the base one. Each names the base schema by a relative path, `..\..\..\libraries\classcatalog.xsd`.

Timelines lists its scenario clusters there as well, the macros with the `tcluster_` prefix.

[↑ Contents](#toc)

## The script side

There is none. The catalog has no keyword, property or action on the script side, and the names in it are reached the usual way: a macro by `macro.<name>`, a component through the macro that uses it.

[↑ Contents](#toc)

## Listing a background from an extension

An extension that adds a cluster with a background scene of its own can list both the way the expansions do, with a whole file that holds only its own names. The example is for a fictional extension `example_backgrounds` with one scene and one cluster.

`libraries/classcatalog.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<catalogs xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="classcatalog.xsd">
  <catalog class="celestialbody">
    <template name="example_cluster_01"/>
  </catalog>
  <catalog class="cluster">
    <macro name="example_cluster_01_macro"/>
  </catalog>
</catalogs>
```

Some points about the example:

- **The file is not what makes the scene work.** The scene needs its component file, an entry for `example_cluster_01` in the extension's `index/components.xml`, and a cluster macro that places it in its `content` connection. With those the cluster shows its background whether the catalog lists it or not, as the unlisted vanilla clusters do.
- **A whole file follows the expansions.** Every expansion adds to the catalog with a plain file under the same root, so that is the form shown here; a diff that adds the same entries to the base blocks is the other way a library file is extended.
- **The names match the definitions exactly**: the template is the component's name, the macro is the cluster macro's name.

The extension itself, its folder, `content.xml` and index files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/).

[↑ Contents](#toc)

## Reading on

[Anatomy of game data](/x4/modding-support/anatomy-of-game-data/) maps the data tree, with the `index/` folder that resolves component and macro names and the `maps/` folder that holds the cluster macros.

[↑ Contents](#toc)

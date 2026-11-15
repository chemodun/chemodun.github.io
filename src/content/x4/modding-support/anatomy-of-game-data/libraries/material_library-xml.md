---
title: material_library.xml
description: How libraries/material_library.xml and material_library_1.xml define the materials of the game - collections, the shader and blend mode of a material, its texture, number and colour properties, materials derived from another - how a component names a material, where the shader's own parameters are, which library files refer to materials, how the expansions add theirs, and how an extension adds a collection or changes a vanilla material.
---

# material_library.xml

A model of the game carries no textures of its own. Each of its surfaces names a **material**, and the material, defined in `libraries/material_library.xml`, says how the surface is drawn: which shader, which textures, how strong each of them is, how it blends with what is behind it. One material serves many models, so the hull texture of a ship line or the glow of an ad sign is defined once.

This article covers the two files and their format, the properties of a material and where they come from, how models and other library files refer to a material, and how an extension adds or changes one. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Material**: one `<material>` entry, a shader with a set of values for it.
- **Collection**: a named group of materials. A material is referred to as `collection.material`.
- **Shader**: the program that draws a surface. A material names one and fills in its parameters.
- **Property**: one value a material gives to its shader: a texture, a number or a colour.
- **Blend mode**: how the drawn surface is combined with what is behind it: opaque, transparent, added as light.

[↑ Contents](#toc)

## How a material is used

The chain from a model to a pixel has three links:

1. **A component** lists the materials of each part of its model, by number, and names each as `collection.material`.
2. **The material library** gives the material: a shader, a blend mode and the properties.
3. **The shader definition** lists every parameter the shader has, with a default. The material overrides the ones it sets.

In a component file the list sits in each level of detail of a part:

```xml
<part name="part_main" wreck="part_main_wreck">
  <lods>
    <lod index="0">
      <materials>
        <material id="1" ref="generic.generic_p1_hulltexture"/>
        <material id="2" ref="generic.generic_p1_fx"/>
      </materials>
    </lod>
    ...
  </lods>
</part>
```

The `id` numbers the materials of the part, and the `ref` is the name in the library.

[↑ Contents](#toc)

## The files

### Two files, one library

The base game has two files with the same root and the same schema, `libraries/material_library.xml` and `libraries/material_library_1.xml`. Together they are one library: a component refers to a material of either the same way. The first, much the larger, holds the collections whose names begin with `p1` and the ones without a prefix; the second holds the `p2...` collections, a later generation of materials with shaders of their own such as `p2_complex_surface`.

The schema of both is `libraries/material_library.xsd`.

[↑ Contents](#toc)

### Layout

```xml
<materiallibrary>
  <collection name="p1ads">
    <material name="adsbackgrounds_01" shader="p1_complex_unlit" blendmode="ALPHA8" preview="none" priority="-2">
      <properties>
        ...
      </properties>
    </material>
    <material name="steam" shader="p1_complex_unlit" blendmode="ADDITIVE" preview="none" priority="1">
      <properties>
        <property type="BitMap" name="diffuse_map" value="assets\fx\textures\smoke4.tga"/>
        <property type="Float" name="diffuseStr" value="1.0"/>
        ...
      </properties>
    </material>
    ...
  </collection>
  <collection name="p1characters">
    ...
  </collection>
  ...
</materiallibrary>
```

The root `<materiallibrary>` holds the `<collection>` entries, each with a `name` and a list of `<material>` entries. A material has one `<properties>` with its `<property>` entries; the schema also allows a `<variations>` and an `<areas>` after it, which are empty wherever vanilla has them.

[↑ Contents](#toc)

### Collections

A collection is a namespace. The name of a material has to be unique only inside its collection, and vanilla has the same material name in more than one collection.

The vanilla collections are sorted by subject: by race (`argon`, `p1paranid`, `p2split`), by kind of object (`p1ads`, `p1interiors`, `asteroids`, `planets`, `characters_heads`), by purpose (`effects`, `enginefxp1`, `lensflares`, `map`, `p1paint`). The `generic` and `p2generic` collections hold the hull textures most models share.

A collection does not have to be written in one piece. Two `<collection>` elements with the same name, in the same file or in different ones, give one collection; this is how the expansions put new materials into `p1ads` or `p2generic`, as shown in [How the expansions change it](#how-the-expansions-change-it).

[↑ Contents](#toc)

### The material

| Attribute | Meaning |
| --- | --- |
| `name` | The name of the material, unique in its collection. Required |
| `shader` | The shader, by the name of its definition. Required |
| `blendmode` | The blend mode, one of a fixed list. Required |
| `priority` | An integer, set on a small share of the materials, most of them blended. Where layers of one object lie over each other the values differ: the background of an ad sign has `-2`, its symbols and trims `1` |
| `tags` | A list of `glass`, `glassinside` and `noenvmap`. Vanilla marks the cockpit glass and a few other materials with them |
| `ref` | A source material of the same collection, see [Derived materials](#derived-materials) |
| `preview` | `none` on every vanilla material |

[↑ Contents](#toc)

### Properties

A `<property>` has a `type`, a `name` and a value. The name is a parameter of the shader; the type says what kind of value it is:

| `type` | Value | Example |
| --- | --- | --- |
| `BitMap` | A texture, by its path in `value` | `<property type="BitMap" name="normal_map" value="assets\textures\generic\generic_p1_hulltexture_01_normal"/>` |
| `Float` | A number in `value` | `<property type="Float" name="normalStr" value="1.0"/>` |
| `Integer` | A whole number in `value`. A few entries write `Int` | `<property type="Integer" name="dblend1" value="1"/>` |
| `Color` | A colour in `r`, `g`, `b` and `a`, each 0 to 255. Vanilla also writes a `value` of the form `(color 255 255 255)` | `<property type="Color" name="color_emissive" r="255" g="255" b="255" a="255" value="(color 255 255 255)"/>` |

The properties of a material come in families that follow the layers of the shader. A layer usually has a texture and a strength, and often a tiling: `diffuse_map` with `diffuseStr`, `normal_map` with `normalStr`, `diffuse_detail_map` with `diffuse_detailStr`, `diffuse_detail_tiling` and `diffuse_detail_tiling_v`. Beside the layers stand plain numbers such as `Smoothness`, `Metallness` and `environmentStr`.

A hull material of the newer models shows the usual set:

```xml
<material name="gen_p2_hulltexture_01" shader="p2_complex_surface" blendmode="NONE" preview="none">
  <properties>
    <property type="BitMap" name="smooth_map" value="assets\textures\generic\generic_p1_hulltexture_01_smooth"/>
    <property type="BitMap" name="metal_map" value="assets\textures\generic\generic_p1_hulltexture_01_metal"/>
    <property type="BitMap" name="diffuse_map" value="assets\textures\generic\generic_p1_hulltexture_01_diff"/>
    <property type="BitMap" name="normal_map" value="assets\textures\generic\generic_p1_hulltexture_01_normal"/>
    <property type="BitMap" name="color_dirt_map" value="assets\textures\generic\gen_p2_dirt_02_diff"/>
    <property type="Float" name="diffuseStr" value="1.0"/>
    <property type="Float" name="normalStr" value="1.0"/>
    <property type="Float" name="color_dirt_tiling" value="5.0"/>
    <property type="Float" name="color_dirtStr" value="1.0"/>
    <property type="Float" name="Smoothness" value="1.0"/>
    <property type="Float" name="Metallness" value="1.0"/>
    ...
  </properties>
</material>
```

Two more attributes appear on texture properties. `preload="1"` is set on a small share of them, such as the star background and the highway tube. `language` holds a language number; vanilla has it only on font textures, with the numbers of Japanese, Korean and the two Chinese languages.

[↑ Contents](#toc)

### Textures

A texture is named by its path from the game folder, with backslashes and without an extension. The files the game ships are `.gz` or `.dds`, under `assets/textures/` and beside the models. Some older entries write a `.tga` extension in the value; the file shipped for them is the `.gz` of the same name.

The end of a texture name tells its role by convention: `_diff` for colour, `_normal` or `_bump` for the surface relief, `_smooth`, `_metal` and `_spec` for how the surface reflects.

[↑ Contents](#toc)

### Derived materials

A material with a `ref` takes the properties of another material of its collection and lists only what differs. The schema requires the source to stand earlier in the file.

```xml
<material name="env_ast_ice_base" shader="p1_asteroid_pom" blendmode="NONE" preview="none">
  <properties>
    <property type="BitMap" name="diffuse_map" value="assets\textures\environments\asteroids\icepattern_02_new_diff"/>
    <property type="BitMap" name="normal_map" value="assets\textures\environments\asteroids\icepattern_bump"/>
    <property type="Float" name="diffuseStr" value="1.0"/>
    ...
  </properties>
</material>
<material name="env_ast_ice_l_03" ref="env_ast_ice_base" shader="p1_asteroid_pom" blendmode="NONE" preview="none">
  <properties>
    <property type="BitMap" name="translucency_map" value="assets\textures\environments\asteroids\translucency\env_ast_ice_l_03_trans_v4_diff"/>
  </properties>
</material>
```

Each ice asteroid has its own translucency texture and shares the rest. The derived material still states its `shader` and `blendmode`, which are required. The base game uses `ref` in two places only, the ice asteroids and the coloured crystals; elsewhere a variation of a material is a full copy.

[↑ Contents](#toc)

## Shaders

The `shader` attribute is the name of a shader definition, an XML file in the `shadergl/ogl/` folder of the game data: `p1_complex_surface` is `shadergl/ogl/p1_complex_surface.xml`. The definition names the shader programs and lists the parameters, each with its default:

```xml
<properties>
  ...
  <samp   name="diffuse_map"/>
  <float  name="diffusestr"       value="1.0"/>
  <float4 name="diffuse_color"    r="1.0" g="1.0" b="1.0" a="1.0"/>
  <float  name="diffuse_tiling"   value="1.0"/>
  <float  name="diffuse_tiling_v" value="1.0"/>
  <float4 name="color_emissive"   r="1.0" g="1.0" b="1.0" a="1.0"/>
  ...
</properties>
```

This is the list to read when writing a material: the property names a shader takes are the parameter names of its definition, a `samp` for a `BitMap`, a `float` for a `Float`, an `int` for an `Integer`, a `float4` for a `Color`. For a property the material leaves out, the definition has the default. The names differ in letter case between the two files, `diffusestr` here and `diffuseStr` in the materials.

The shader names show three families, `p1_...`, `p2_...` and `xu_...`. Surfaces that are lit use the `..._surface` shaders, surfaces that only glow, such as ad signs and effects, the `..._unlit` ones; characters, planets, glass and the interface have shaders of their own.

[↑ Contents](#toc)

## Blend modes

`blendmode` takes one value of a list in the schema. The schema does not describe the values; the names follow common rendering terms, and the table shows where vanilla uses the ones that carry most of its materials:

| Blend mode | Vanilla use |
| --- | --- |
| `NONE` | Opaque surfaces: hulls, interiors, asteroids. The largest group |
| `ADDITIVE` | Surfaces that add light: weapon fire and other effects, ad signs, highway streams. The second largest group |
| `ALPHA8`, `ALPHA1` | Transparent surfaces, such as the background of an ad sign |
| `SCREEN`, `MULTIPLY` | Layers that brighten or darken what is behind them |
| `ALPHA8_SINGLE`, `ADDITIVE_SINGLE` | Cockpit glass, distant galaxies of the sky |
| `DISTORTION` | The distortion materials of the effects collections |
| `PLANET_ATMOSPHERE` | Planets |

The rest of the list are special cases: the `..._ANARK` modes of the interface, the `..._OVERLAY` and `WIREFRAME...` modes, `HAIR`, and the two `FSR_MASK_...` modes.

[↑ Contents](#toc)

## Who refers to a material

| Where | How | What for |
| --- | --- | --- |
| Components under `assets/` | `<material id="..." ref="collection.material"/>` in the `<materials>` of a part's level of detail | Nearly every reference: ships, stations, interiors, props, asteroids, effects, cutscenes |
| `libraries/parameters.xml` | `material`, `boxmaterial`, `ringmaterial` and similar attributes | The map (sector borders, grids, range rings, slots), the docking guidance, the first person guidance line, the weapon pointer |
| `libraries/highwayconfigurations.xml` | `material` on a `<tubeconfiguration>` | The road of a highway |
| `libraries/stardust_library.xml` | `material` on the `<configuration>` | The stardust around a moving ship |

All of them use the `collection.material` form. [parameters.xml](/x4/modding-support/anatomy-of-game-data/libraries/parameters-xml/) covers the map and guidance sections that name materials.

Scripts and the UI Lua have no access to materials: no script element and no Lua function reads or changes one.

[↑ Contents](#toc)

## How the expansions change it

Every expansion ships a `libraries/material_library.xml`, a `<diff>` with a single operation that adds whole collections at the start of the library:

```xml
<diff>
  <add sel="/materiallibrary" pos="prepend">
    <collection name="p1ads">
      <material name="ads_cheltmeat" shader="p1_complex_unlit" blendmode="ADDITIVE" preview="none" priority="1">
        <properties>
          ...
        </properties>
      </material>
    </collection>
    <collection name="planetsv2">
      ...
    </collection>
  </add>
</diff>
```

Two things are worth noting:

- **A new collection and a known name are added the same way.** The expansions add collections with names of their own (`p1terran`, `piratecharacters`, `planetsv8`) and collections named like a base one (`p1ads`, `p1characters`, `p2generic`). In the second case the materials join the base collection: the Split ad sign above is referred to as `p1ads.ads_cheltmeat`. None of the added names repeats a material the base collection has.
- **The diff is on `material_library.xml` even for a `p2...` collection.** Timelines adds to `p2generic` and `p2paint`, which the base game defines in `material_library_1.xml`, from its diff on the first file. No expansion ships a `material_library_1.xml`.

The textures of an expansion are named with its path in front: `extensions\ego_dlc_timelines\assets\textures\...`.

[↑ Contents](#toc)

## Adding materials from an extension

The example below, for a fictional extension `example_materials`, adds a collection with an ad sign material and a dimmer variant derived from it, and halves the brightness of one vanilla material.

`libraries/material_library.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/materiallibrary" pos="prepend">
    <collection name="example_signs">
      <material name="sign_base" shader="p1_complex_unlit" blendmode="ADDITIVE" preview="none" priority="1">
        <properties>
          <property type="BitMap" name="diffuse_map" value="extensions\example_materials\assets\textures\sign_01_diff"/>
          <property type="Color" name="color_emissive" r="255" g="255" b="255" a="255" value="(color 255 255 255)"/>
          <property type="Float" name="diffuseStr" value="1.0"/>
        </properties>
      </material>
      <material name="sign_dim" ref="sign_base" shader="p1_complex_unlit" blendmode="ADDITIVE" preview="none" priority="1">
        <properties>
          <property type="Float" name="diffuseStr" value="0.4"/>
        </properties>
      </material>
    </collection>
  </add>
  <replace sel="/materiallibrary/collection[@name='p1ads']/material[@name='steam']/properties/property[@name='diffuseStr']/@value">0.5</replace>
</diff>
```

The component of the extension's own model then names the materials:

```xml
<materials>
  <material id="1" ref="example_signs.sign_base"/>
  <material id="2" ref="example_signs.sign_dim"/>
</materials>
```

The texture is `assets/textures/sign_01_diff`, a `.gz` or `.dds` file, in the folder of the extension.

Some points about the example:

- **A collection of its own keeps the names apart.** The extension could add its materials to `p1ads` the way the expansions do, but a name it picks there could meet a material of the game or of another extension. In its own collection only the collection name has to be unique.
- **The texture path starts at the game folder.** A texture of an extension is named with `extensions\<folder>\` in front, without the file extension.
- **The property names are the shader's.** `diffuse_map`, `diffuseStr` and `color_emissive` are parameters of `p1_complex_unlit`; the definition of the shader is the place to check a name.
- **The source of a derived material stands before it.** `sign_dim` follows `sign_base` in the same collection and repeats the required `shader` and `blendmode`.
- **A vanilla material is selected by collection and name.** The material name alone is not unique in the library, so the `<replace>` names both. It changes one attribute of one property and leaves the rest of the material to the game and to other extensions. The change reaches every model that uses the material.
- **The diff goes on `material_library.xml`** for a new collection, as the expansions have it.
- **A material is only seen on a model.** The library alone shows nothing in the game: the new materials need a component that refers to them, while the changed vanilla material shows on the models that already use it.

The extension itself, its folder and `content.xml`, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/), and the diff operations in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[Anatomy of game data](/x4/modding-support/anatomy-of-game-data/) covers where the models, textures and shaders are in the game's data.

[parameters.xml](/x4/modding-support/anatomy-of-game-data/libraries/parameters-xml/) covers the sections of the map and the guidance lines that name materials.

[colors.xml](/x4/modding-support/anatomy-of-game-data/libraries/colors-xml/) covers the named colours of the interface, which are separate from the colour properties of a material.

[↑ Contents](#toc)

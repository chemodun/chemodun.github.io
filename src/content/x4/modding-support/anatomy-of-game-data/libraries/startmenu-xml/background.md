---
title: Start menu background
description: How a background scene of the X4 start menu is put together - the black galaxy and the background cluster, the cutscene, the scene object with its camera, ships and stations, regions in a start menu - and how an extension adds a background scene of its own.
order: 1
---

# Start menu background

Behind the start menu runs a 3D scene: a planet, a gate, ships flying past, a station, the X4 logo. It is a small universe of its own. A cluster provides the sky, regions can add asteroids and fog, and a scene object holds the camera, the lights and everything that moves. [startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) lists the scenes and how each entry ties these parts together, and the player picks one in the settings.

This article covers the parts a scene is made of and how an extension adds a scene with all its files. It describes version 9.00. The idea for this article, and many of the facts in it, come from a Discord discussion in which **Hih**, **Lc4Hunter**, **Rothank**, **Land** and **Nistur** worked out how a mod author can create and manage a start menu scene.

The intro animations a gamestart plays in this scene are described in [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/#cutscene-and-intro).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Scene entry**: one `<scene>` in `libraries/startmenu.xml`. It names the cutscene the scene plays, the background cluster whose sky it shows, the music played with it, and the regions placed around it.
- **Background cluster**: the cluster content that gives the scene its sky: the skybox, planets, nebulae and the sun's light.
- **Scene object**: a macro of class `cutsceneanchor` with its component, holding the camera, the lights, and the dummies everything in the scene is attached to.
- **Dummy**: an invisible part of the scene object. A ship, a station module or an asteroid is attached to a dummy, and moves with it.

[↑ Contents](#toc)

## The map and the background

Every vanilla scene is built in the black galaxy, `maps/blackgalaxy/`: one cluster, `Cluster_black_macro`, with one sector and two empty zones. The cutscene places the scene object in `tzonecluster_black_sector01_zone_macro`.

The `background` attribute of `<cluster>` names a macro of class `celestialbody`, whose component is the space content of a cluster: the skybox, the planets and the nebula. The scene shows the sky of that cluster. The vanilla background macros are short:

```xml
<macro name="cluster_sm_pir_macro" class="celestialbody">
  <component ref="cluster_sm500_background" />
</macro>
```

`cluster_sm_basegame_background_macro` points at the same component as `cluster_sm3_background_macro`, and the Pirate one at `cluster_sm500_background`, the content of a game map cluster. A new background macro can point at the content component of any cluster in the game the same way, and a copy of an existing cluster with small changes makes a background of its own.

A background macro is an asset macro like any other. The base game keeps its background macros in `assets/environments/cluster/macros/<name>_macro.xml` and their components in `assets/environments/cluster/<name>.xml`; an expansion keeps them under its own folder, such as `extensions/ego_dlc_pirate/assets/environments/cluster/macros/`. Each macro has an entry in `index/macros.xml`, and each component one in `index/components.xml`:

```xml
<entry name="cluster_sm_pir_macro" value="extensions\ego_dlc_pirate\assets\environments\cluster\macros\cluster_sm_pir_macro" />
```

An extension's own background macro follows the same pattern: the macro file in the extension's `assets/` tree, and a diff on `index/macros.xml` adding its entry.

The vanilla background macros:

| Macro | From |
|---|---|
| `cluster_sm3_background_macro` | base game, used by the default scenes |
| `cluster_sm2_background_macro` | base game |
| `cluster_sm_basegame_background_macro` | base game |
| `cluster_sm_split_macro` | Split Vendetta |
| `cluster_sm_ter_macro` | Cradle of Humanity |
| `cluster_sm_pir_macro` | Tides of Avarice |
| `cluster_sm602_background_macro`, `cluster_sm605_background_macro`, `cluster_sm606_background_macro` | Kingdom End |
| `cluster_708_sm_macro` | Timelines |

[↑ Contents](#toc)

## The cutscene

A start menu cutscene is a short file in `cutscenes/`. All vanilla ones have the same content apart from the key and the scene object:

```xml
<cutscene xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cutscenes.xsd">
  <director key="startmenu_pir_background" />
  <environments>
    <environment_plot name="scenezone">
      <anchor name="startmenu_pirate_final2_macro" />
      <teleport zone="tzonecluster_black_sector01_zone_macro">
        <offset>
          <position x="0" y="0" z="0" />
        </offset>
      </teleport>
    </environment_plot>
  </environments>
  <presentation>
    <actions>
      <sequence name="start_menutest" start="0">
        <shot name="TestShot" environment="scenezone" duration="onevent:stopscene">
          <camera_animated reference="animobject">
          </camera_animated>
        </shot>
      </sequence>
    </actions>
  </presentation>
</cutscene>
```

`<director key>` is the name the scene entry's `cutscene` refers to. `<anchor>` names the scene object's macro. The shot lasts until the scene is stopped, and the camera follows the animated camera of the scene object.

Two vanilla cutscenes can use the same scene object: after the Terran diff, the default cutscene and `startmenu_ter_background` both show `startmenu_terran_final_macro`, with different backgrounds from their scene entries.

[↑ Contents](#toc)

## The scene object

### The macro

The base game keeps the scene object's macro in `assets/cutscenecore/macros/<name>_macro.xml`; an expansion keeps it under its own folder, such as `extensions/ego_dlc_pirate/assets/cutscenecore/macros/startmenu_pirate_final_macro.xml`. The macro has an entry in `index/macros.xml`:

```xml
<entry name="startmenu_pirate_final_macro" value="extensions\ego_dlc_pirate\assets\cutscenecore\macros\startmenu_pirate_final_macro" />
```

The macro has class `cutsceneanchor`. It names its component and fills the component's connections with objects:

```xml
<macro name="startmenu_pirate_final_macro" class="cutsceneanchor">
  <component ref="startmenu_pirate_final" />
  <connections>
    <connection ref="ConnectionFor_ship_pir_s_fighter_01_a_macro">
      <macro ref="ship_pir_s_fighter_01_a_macro" connection="position" />
    </connection>
    <connection ref="ConnectionFor_props_gates_anc_gate_macro">
      <macro ref="props_gates_anc_gate_macro" connection="position" />
    </connection>
    <connection ref="ConnectionFor_landmarks_gen_piratestation_02_macro">
      <macro ref="landmarks_gen_piratestation_02_macro" connection="position" />
    </connection>
    ...
  </connections>
</macro>
```

Each connection holds an ordinary game macro: a ship, a gate, a station module, an asteroid, or, in the Pirate scenes, a whole landmark station. Because the scene names a ship by its macro, the game fits the ship's equipment, weapons and shields itself and matches the engine flames to the ship's speed, so none of it has to be built into the scene. A ship can also be given a macro made for the start menu only, for a particular loadout.

**A scene object has to include a playable ship**, or the start menu loads blank. Every vanilla scene object has small player-class ships among its connections: `ship_arg_s_scout_01_a_macro`, `ship_arg_s_fighter_02_a_macro` and `ship_par_s_fighter_01_a_macro` in all of them but the Timelines one, which has `ship_gen_s_racer_01_a_macro`.

### The component

The component lives in `assets/cutscenecore/<name>.xml`, or under an expansion's folder, such as `extensions/ego_dlc_pirate/assets/cutscenecore/startmenu_pirate_final.xml`, with an entry in `index/components.xml`. It holds:

- **Lights**, in `<layers><layer><lights>`: an omni light with a `lenseffect` for the sun, more omni lights for colour, and an ambient light.
- **The camera**: `<camera name="Camera01" fov="90"/>` on a connection with the part `anim_anchor`. That connection carries the animations: `cutsceneloop`, the loop shown in the menu, and `gamestart1`, `gamestart3`, `gamestart4` and, in later scenes, `gamestart5`, the intros a gamestart can play. The Timelines scene uses names of its own (`startmenu_begin`, `startmenu_diorama1` to `startmenu_diorama6`) and has none of these.
- **Dummies**: parts with the material `dummy.transparent`, animated along their own paths, each carrying one or more objects through connections named `ConnectionFor_<macro>`:

  ```xml
  <connection name="ConnectionFor_ship_arg_s_fighter_02_a_macro" tags="ship_s iklink" parent="ShipDummy01"/>
  ```

  The tags say what fits: `ship_s`, `ship_l` and so on for ships, `station`, `gate`, and for station modules their kind.
- **The logo**: a part shaped like the X4 logo, and a child part `logo_bg` whose material fills the letters: `p1effects.logo_parallax` in the base game scene, `p2effects.logo_bor` in the Kingdom End scenes. The Timelines scene has no logo.
- **Other connections**: `PlayerConnection01` with the tag `player`, a `lensflare` connection, and an event at frame 12000, `playNext` with the cutscene `startmenu_background` as its parameter, in every vanilla scene except the Timelines one.

The positions of the dummies, objects and camera, and the animation keys, come from the 3D tool the scene was built in. The export tools available to modders cannot export a camera, so the camera connection is written into the XML by hand. Text of a scene's own under the logo is a modelled part exported like any other geometry. The start menu also applies level-of-detail rules like the game does, so objects far from the camera can show their low-detail models, and some objects may need changes for it.

### A station made of modules

Vanilla scenes build their stations from single modules, one connection per module. The Kingdom End scene's station is over twenty modules, every one on its own connection with the same parent dummy, so the station moves as one piece:

```xml
<connection name="ConnectionFor_hab_bor_m_01_macro1" tags="habitation iklink" parent="stationdummy">
  <offset>
    <position x="-690.8397" y="-3.051758E-05" z="399.0464"/>
    <quaternion qx="-0" qy="-0.5" qz="-0" qw="0.8660254"/>
  </offset>
</connection>
```

The macro fills each one with `<macro ref="hab_bor_m_01_macro" connection="space"/>`. No vanilla scene uses a construction plan. A large station of a scene's own is easiest in the same layout: parent the modules to one central dummy, so that their positions are in metres from the station's centre rather than in the scene's kilometres, and take those positions from the 3D tool. A construction plan stores its modules in the same kind of coordinates, each with a position in metres from the station's centre and a rotation in degrees, while the scene writes the rotation as a quaternion.

The other vanilla way is the Pirate one: a whole station as a single macro, `landmarks_gen_piratestation_02_macro`, on one connection tagged `station`.

[↑ Contents](#toc)

## Regions

Asteroid fields, fog and nebulae come from regions, as they do in the game map. Kingdom End, Tides of Avarice and Timelines put regions into their scenes. Three files are involved.

**The definition**, in the extension's `libraries/region_definitions.xml`. The expansions ship this as a file of their own with a `<regions>` root, not as a diff. A start menu region is defined like any other; the Kingdom End scenes use copies of their map regions with an `sm` suffix, and the Pirate scenes use their map regions as they are. A start menu copy of a map region can differ from it in size only.

**A macro for the region**, of `standardregion`, naming the definition:

```xml
<macros>
  <macro name="sm_bs_region_macro">
    <component connection="cluster" ref="standardregion" />
    <properties>
      <region ref="c602s1_region1sm" />
    </properties>
  </macro>
</macros>
```

A region in the game map is defined inline in its cluster's connection; a start menu scene names it by macro, so the macro needs a file of its own. The expansions keep these macros in `libraries/macro.xml`, structured as a plain `<macros>` file, not a diff.

**An index entry** in `index/macros.xml`, pointing the macro name at that file:

```xml
<entry name="sm_bs_region_macro" value="extensions\ego_dlc_boron\libraries\macro" />
```

The scene entry then places the region by its macro name:

```xml
<regions>
  <region name="sm_bs_region_macro">
    <position x="0" y="-20000" z="0"/>
  </region>
</regions>
```

The position is where the region's boundary starts, and the shape decides what that means:

- **A cylinder** starts at its position and extends upward by its `linear` size. To centre it on the scene, place it at minus half its `linear`: Kingdom End's `c605s1_region1sm`, with `linear="100000"`, sits at `y="-50000"`.
- **A sphere** is centred on its position, so `y="0"` puts it exactly on the scene.

Vanilla follows this for every start menu cylinder, sometimes with a small extra offset: the Pirate cylinders sit 2 km lower than the half, the Timelines one 5 km.

Two things make the game load the region macros correctly: `libraries/macro.xml` is a plain `<macros>` file like the base game's, not a diff, and the index entry points at that file. When the game reads the region definitions as a macro file instead, the log fills with lines like these, one for each element of the definitions:

```text
LookupKeyName::LookupName(): The key name "step" is not recognized in lookup ComponentXML. Originated from: extensions\...\libraries\region_definitions(.xml|.xml.gz)
Error loading component macro: Invalid component macro XML file 'extensions\...\libraries\region_definitions'
```

[↑ Contents](#toc)

## Adding a background from an extension

The example below is a complete background scene for a fictional extension `example_startmenu`. It reuses the base game's scene object, `startmenu_final_macro`, with its camera, ships, station and logo, puts it under the sky of `cluster_sm2_background_macro`, and adds an asteroid field of its own.

`cutscenes/example_startmenu_background.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<cutscene xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cutscenes.xsd">
  <director key="example_startmenu_background" />
  <environments>
    <environment_plot name="scenezone">
      <anchor name="startmenu_final_macro" />
      <teleport zone="tzonecluster_black_sector01_zone_macro">
        <offset>
          <position x="0" y="0" z="0" />
        </offset>
      </teleport>
    </environment_plot>
  </environments>
  <presentation>
    <actions>
      <sequence name="start_menutest" start="0">
        <shot name="TestShot" environment="scenezone" duration="onevent:stopscene">
          <camera_animated reference="animobject">
          </camera_animated>
        </shot>
      </sequence>
    </actions>
  </presentation>
</cutscene>
```

`libraries/startmenu.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/startmenu/background">
    <scene cutscene="example_startmenu_background" music="music_menu_main_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm2_background_macro" />
      <regions>
        <region name="example_sm_asteroids_macro">
          <position x="0" y="-2500" z="0" />
        </region>
      </regions>
    </scene>
  </add>
</diff>
```

`libraries/region_definitions.xml`, a smaller copy of the vanilla `p1_40km_asteroid_field`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<regions>
  <region name="example_sm_asteroids" density="4.5" rotation="0">
    <boundary class="cylinder">
      <size r="15000" linear="5000" />
    </boundary>
    <falloff>
      <lateral>
        <step position="0.0" value="0.0" />
        <step position="0.1" value="1.0" />
        <step position="0.9" value="1.0" />
        <step position="1.0" value="0.0" />
      </lateral>
      <radial>
        <step position="0.0" value="1.0" />
        <step position="0.5" value="0.9" />
        <step position="1.0" value="0.0" />
      </radial>
    </falloff>
    <fields>
      <asteroid groupref="asteroid_ore_l" densityfactor="2.75" rotation="360" rotationvariation="4" noisescale="1500" seed="2001" minnoisevalue="0.6" maxnoisevalue="1" />
      <asteroid groupref="asteroid_ore_m" densityfactor="1" rotation="360" rotationvariation="8" noisescale="1500" seed="2001" minnoisevalue="0.6" maxnoisevalue="1" />
      <asteroid groupref="asteroid_ore_s" densityfactor="2" rotation="360" rotationvariation="16" noisescale="1500" seed="2001" minnoisevalue="0.5" maxnoisevalue="1" />
    </fields>
  </region>
</regions>
```

`libraries/macro.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<macros>
  <macro name="example_sm_asteroids_macro">
    <component connection="cluster" ref="standardregion" />
    <properties>
      <region ref="example_sm_asteroids" />
    </properties>
  </macro>
</macros>
```

`index/macros.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/index">
    <entry name="example_sm_asteroids_macro" value="extensions\example_startmenu\libraries\macro" />
  </add>
</diff>
```

Some points about the example:

- **The scene appears under the extension's name** in Settings, Game, "Start Menu Background Scene". It does not replace the default; a scene that should is a `replace` of the default entry, as the expansions do, and then it competes with the expansions that replace the same entry.
- **A vanilla region** can be placed instead of a new one: the macro names a vanilla definition in `ref`, and `region_definitions.xml` is not needed.
- **The index path** is the extension's folder name and the file without its extension.
- **A scene object of its own** replaces `startmenu_final_macro` in the cutscene with a macro of the extension's, of class `cutsceneanchor`, with its component and the geometry exported for it, both in the extension's `assets/` tree with entries added to `index/macros.xml` and `index/components.xml`. It has to include a playable ship, as the vanilla ones do. The cutscene and the scene entry stay as they are.
- **The region's position** is minus half its `linear`, so the cylinder is centred on the scene.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

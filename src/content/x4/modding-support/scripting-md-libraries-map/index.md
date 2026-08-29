---
title: Scripting/MD/Libraries/Map
description: The Mission Director and the AI script engine, and the command vocabulary both of them share.
order: 1
wiki: ScriptingMD
wikiName: Scripting/MD/Libraries/Map
---

# Scripting/MD/Libraries/Map

Most of what a mod does to the running game is done from a script. There are two engines and they are closer than they look: the Mission Director drives the plots, the economy and everything that happens to the universe at large, while AI scripts drive a single object - what a ship does with its orders, how a station reacts to what it sees.

They are separate schemas with separate documents, but the vocabulary in the middle is shared. Well over half of the commands either engine accepts are declared once, in `common.xsd`, and behave identically on both sides. That shared middle is what the reference below is about.

{{children}}

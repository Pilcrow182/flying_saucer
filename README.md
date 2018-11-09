# Flying Saucer

version 0.9, © 2018 by Pilcrow182

-------------------------------------------------------------------------------

### Screenshot:

![image](https://raw.githubusercontent.com/Pilcrow182/flying_saucer/master/screenshot.png)

-------------------------------------------------------------------------------

## Downloads: [GitHub](https://github.com/Pilcrow182/flying_saucer), [zip](https://github.com/Pilcrow182/flying_saucer/archive/master.zip), [tar.gz](https://github.com/Pilcrow182/flying_saucer/archive/master.tar.gz)

-------------------------------------------------------------------------------

### Introduction:

This mod adds a flying saucer vehicle to the Minetest game, using the same basic concept as the [cars mod](https://forum.minetest.net/viewtopic.php?t=13988) by cheapie: it changes the player character's model and movement ability/controls rather than spawning a new entity and attaching the player to it. Theoretically, this means less lag. This mod was originally intended to become a drop-in replacement for the [helicopter mod](https://forum.minetest.net/viewtopic.php?f=11&t=6183) by Pavel_S, but was later changed to a flying saucer. The 3D model was taken from Zeg9's [UFOs mod](https://forum.minetest.net/viewtopic.php?f=11&t=4086), though none of our code or textures are shared, and our controls are nothing alike.

Please report any issues at the [Flying Saucer GitHub page](https://github.com/Pilcrow182/flying_saucer) or the [Release thread on the Minetest forums](https://forum.minetest.net/viewtopic.php?f=9&t=21330).

-------------------------------------------------------------------------------

### Controls:

Wielding the Saucer and clicking the left mouse button (to 'use' the item) sets the player to 'saucer mode'. Then he/she can move left, right, forward, or back without being affected by gravity, and use Space to go up or Shift to go down (NOTE: By default, the Saucer doesn't stop when you let go of space/shift. Use the special/aux1 button, 'e' by default, to stop. This setting can be changed by editing the `minetest.conf` file and setting `flying_saucer_passive_stop` to `true`).

-------------------------------------------------------------------------------

### Depends:

None (though the [crafting recipe](https://raw.githubusercontent.com/Pilcrow182/flying_saucer/master/crafting.png) uses items from Default)

-------------------------------------------------------------------------------

### Known bugs:

Holding shift cuts the player's horizontal movement to 1/3 speed. This is a side-effect of using the player entity's controls, since shift is normally used for 'sneaking' (which is *supposed* to slow the player's movement). If anyone can figure out how to disable this feature during saucer mode, I'd be happy to hear it. 

Unlike horizontal movement (which is managed client-side), the vertical movement is dependent on server cycles. This means if there is anything causing excessive lag, it may negatively affect the user's ability to move up/down (or to *stop* moving, regardless of the `flying_saucer_passive_stop` setting).

-------------------------------------------------------------------------------

### Credits:

Code by Pilcrow182

Textures by Pilcrow182, inspired by Melkor's textures for Zeg9's [UFOs mod](https://forum.minetest.net/viewtopic.php?f=11&t=4086)

Model by Melkor

-------------------------------------------------------------------------------

### Licenses:

code -- [ISC](https://opensource.org/licenses/ISC)

textures -- [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

model -- originally released with Zeg9's UFOs as [WTFPL](http://www.wtfpl.net/txt/copying/)

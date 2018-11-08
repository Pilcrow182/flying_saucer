Flying Saucer mod by Pilcrow182, version 0.9

Introduction:
This mod adds a flying saucer vehicle to the Minetest game, using the same
basic concept as the cars mod by cheapie: it changes the player character's
model and movement ability/controls rather than spawning a new entity and
attaching the player to it. Theoretically, this means less lag. This mod was
originally intended to become a drop-in replacement for the helicopter mod by
Pavel_S, but was later changed to a flying saucer. Model taken from Zeg9's ufos
mod, though none of the code was shared, and our controls are nothing alike.

Please report any issues at the Flying Saucer github page:
https://github.com/Pilcrow182/flying_saucer

Depends:
None (though the crafting recipies use items from Default)

How to install:
Unzip the archive and place it in "minetest-base-directory/mods/" if you have
a windows client or a linux run-in-place client. If you have a linux
system-wide instalation, place the mod's folder in "~/.minetest/mods/"
If you want to install this mod in a single world, create the folder
"worldmods" in your world's base directory and put the mod folder in there.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
Wielding the Saucer and clicking the left mouse button (to 'use' the item) sets
the player to 'saucer mode'. Then he/she can move left, right, forward, or back
without being affected by gravity, and use Space to go up or Shift to go down
(NOTE: By default, the Saucer doesn't stop when you let go of space/shift. Use
the special/aux1 button, 'e' by default, to stop. This setting can be changed
by editing minetest.conf and setting flying_saucer_passive_stop to true).

===============================================================================

Known bugs:

Holding shift cuts the player's horizontal movement to 1/3 speed. This is a
side-effect of using the player entity's controls, since shift is normally used
for 'sneaking' (which is *supposed* to slow the player's movement). If anyone
can figure out how to disable this feature during saucer mode, I'd be happy to
hear it.

Unlike horizontal movement (which is managed client-side), the vertical
movement is dependant on server cycles. This means if there is anything causing
excessive lag, it may negatively affect the user's ability to move up/down (or
to *stop* moving, regardless of the flying_saucer_passive_stop setting).

===============================================================================

Credits:
Code by Pilcrow182
Textures by Pilcrow182, inspired by Melkor's textures for Zeg9's ufos mod
Model by Melkor

===============================================================================

Licenses:
code -- ISC
see LICENSE.txt

textures -- CC BY 4.0
https://creativecommons.org/licenses/by/4.0/

model -- originally released by Melkor as WTFPL
http://www.wtfpl.net/txt/copying/

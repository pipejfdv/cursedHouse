Pixel Weather Overlays (Free)
=============================
Version 2.0. Made for 16x16 games.

7 weather, sky and ambience overlays for pixel-art games. Every overlay is one seamless loop that tiles in
every direction: lay it over the whole screen and play it forever. Particles are drawn for the tile size (1 px rain
at 16 px, 2 px at 32 px), never scaled, with two depth layers, a few hard alpha levels and dithered fog.
Stack a few and you get real weather: see recipes/.

OVERLAYS
  Rain           rain_light       16 frames @ 16 fps
  Snow and cold  snow_light       48 frames @ 12 fps
  Fog and mist   fog_thin         64 frames @ 10 fps
  Seasons        leaves_autumn    48 frames @ 12 fps
  Ambient        fireflies        48 frames @ 12 fps
  Sky and wind   cloud_shadows    64 frames @ 10 fps  NEW
  Sky and wind   wind             32 frames @ 12 fps  NEW

FOLDERS
  overlays/<group>/<overlay>_<size>px.png    frame sheet: frames left to right, wrapping after 16 columns
  overlays/<group>/<overlay>_<size>px.json   width, height, frames, fps, columns, rows, tiles_x/tiles_y,
                                              blend ("mix" or "add" for glowing ones), colours
  overlays/<group>/<overlay>_<size>px.gif    preview, tiled 2 x 2
  extras/lightning_bolt_<n>_<size>px.png     1 lightning strikes to play once over a storm (not tiled;
                                              anchor bottom centre, strike frames listed in the .json)
  recipes/weather_recipes.json               7 ready-made weather stacks (layers bottom to top, a tint, lightning)
                                              plus the screen tints for dawn, dusk, night, storm and more
  preview.html                                every overlay playing in your browser
  godot/weather_overlay.gdshader             Godot 4 shader: tiles and plays any overlay sheet (with intensity
                                              and fade)
  godot/weather_overlay.gd                   Godot 4 script: point it at one PNG and it sets everything up
  godot/weather_controller.gd                Godot 4 script: plays whole recipes with crossfades, tint and lightning

SIZES
  The size in the file name is the map tile the overlay is drawn for (16 px tiles -> 128 x 128 overlay = 8 x 8
  tiles). Use the 16 px files with 16x16 tilesets, the 32 px files with 32x32 tilesets.

RECIPES
  hailstorm       cloud_shadows + rain_light, storm tint
  light_rain      rain_light
  snowfall        snow_light, fog tint
  light_snow      snow_light
  autumn_wind     cloud_shadows + leaves_autumn + wind
  summer_night    fireflies, night tint
  winter_night    snow_light, night tint

USING THEM
  Any engine: draw the current frame (frame = floor(time * fps) % frames; cell = (frame % columns, frame //
  columns)) tiled across the screen, on top of the world, at the same zoom as your tiles. Glowing overlays
  (fireflies, embers, sparkles, spores, sunbeams, aurora, shooting stars) look best with additive blending
  (.json "blend": "add"). Want it heavier? Draw the same overlay twice, shifted by about a third of a tile.
  Tints: multiply your world by the tint colour (night, storm...) and keep the overlays on top, untinted.
  Godot 4, whole weather: add a CanvasLayer above your world, attach godot/weather_controller.gd, set Pack Dir to
  this folder and Recipe to "thunderstorm" (or any recipe). Change it from code: set_weather("snowfall", 2.0).
  Godot 4, one overlay: add a ColorRect covering the screen (anchors full rect, Mouse Filter Ignore), attach
  godot/weather_overlay.gd, set Overlay Png. Set the PNGs' import Filter to Nearest. Pixel Scale = your zoom.
  Unity: import Filter Point, Compression None, Wrap Clamp; tile the cell yourself (a small shader like the
  Godot one), or slice the sheet and play it on a tiled UI image.
  mist_band and aurora tile only sideways: place them along the ground or across the sky.

ASSET LICENCE

Thank you for downloading! This licence covers the free and paid versions of every pack.

YOU MAY
- Use these assets in any number of games, apps, videos, streams and other projects, commercial or
  non-commercial, on any platform.
- Edit, recolour, cut up and combine them with other art or sound.
- Release your project without crediting us. Credit is appreciated but not required.

YOU MAY NOT
- Resell, share, re-upload or give away the assets themselves, in whole or in part, edited or not,
  on their own or inside another asset pack, template, tileset, sound library or art collection.
- Use the assets, or anything made from them, to train, fine-tune or test AI or machine-learning
  models, or include them in datasets for that purpose.
- Mint or sell the assets as NFTs.
- Claim that you made the original assets.

A team working on one project may share the files among its members for that project.

Questions or a licence that fits a special case: contact us through the itch.io page.


// Tiles one weather overlay sheet across the node and plays it. Put it on a ColorRect (or any CanvasItem)
// covering the screen, set the sheet texture (Filter: Nearest, Repeat: Disabled) and the numbers from its .json.
// weather_overlay.gd and weather_controller.gd fill all of this in for you.
shader_type canvas_item;

uniform sampler2D sheet : filter_nearest;
uniform int columns = 16;            // .json "columns"
uniform int rows = 1;                // .json "rows"
uniform int frames = 16;             // .json "frames"
uniform vec2 tile_px = vec2(128.0);  // .json "width", "height"
uniform float fps = 12.0;            // .json "fps"
uniform vec2 scroll = vec2(0.0);     // optional extra drift, px per second (wind)
uniform float pixel_scale = 1.0;     // match your game's zoom so overlay pixels match tile pixels
uniform int intensity : hint_range(1, 3) = 1;   // 2 or 3 lays extra shifted copies: heavier weather, same file
uniform float opacity : hint_range(0.0, 1.0) = 1.0;  // fade in and out (the controller tweens this)

vec4 cell(vec2 p, int f) {
    vec2 c = vec2(float(f % columns), float(f / columns));
    vec2 local = floor(mod(p, tile_px)) + 0.5;       // whole pixels, wrapped: the overlay tiles seamlessly
    return texture(sheet, (c * tile_px + local) / (tile_px * vec2(float(columns), float(rows))));
}

void fragment() {
    int f = int(floor(TIME * fps)) % frames;
    vec2 p = FRAGCOORD.xy / pixel_scale + scroll * TIME;
    vec4 col = cell(p, f);
    if (intensity > 1) {
        vec4 c2 = cell(p + tile_px * vec2(0.37, 0.61), (f + frames / 3) % frames);
        col = c2.a > col.a ? c2 : col;
    }
    if (intensity > 2) {
        vec4 c3 = cell(p + tile_px * vec2(0.71, 0.23), (f + 2 * frames / 3) % frames);
        col = c3.a > col.a ? c3 : col;
    }
    COLOR = vec4(col.rgb, col.a * opacity);
}

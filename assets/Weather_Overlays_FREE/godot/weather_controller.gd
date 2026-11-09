# Weather controller: plays whole weather recipes from weather_recipes.json (layers bottom to top, a time-of-day
# tint, lightning) and crossfades between them.
#
#   1. Add a CanvasLayer to your level (layer 5 or so, above the world, below the UI) and attach this script.
#   2. Set Pack Dir to the folder you unzipped the pack into (the one with overlays/ and recipes/).
#   3. Pick a Recipe ("rainy", "thunderstorm", "summer_night"...) and press Play.
#   From code: $Weather.set_weather("blizzard", 2.0)  # 2 second crossfade.   $Weather.set_weather("")  clears it.
extends CanvasLayer

@export_dir var pack_dir: String = "res://weather"
@export_enum("16", "32") var tile_size: String = "16"
@export var recipe: String = "rainy"
@export var pixel_scale: float = 1.0          # your game's zoom, so overlay pixels match tile pixels
@export_range(1, 3) var intensity: int = 1
@export var fade_time: float = 1.5
@export var use_tint: bool = true             # tints the world below with a CanvasModulate
@export var lightning_every: Vector2 = Vector2(4.0, 11.0)   # seconds between strikes (min, max)

var _recipes: Dictionary = {}
var _tints: Dictionary = {}
var _layers: Array[ColorRect] = []
var _flash: ColorRect
var _bolt: Sprite2D
var _tint: CanvasModulate
var _timer: Timer
var _shader_path: String

func _ready() -> void:
	_shader_path = get_script().resource_path.get_base_dir() + "/weather_overlay.gdshader"
	var data = JSON.parse_string(FileAccess.get_file_as_string(pack_dir + "/recipes/weather_recipes.json"))
	_recipes = data.get("recipes", {})
	_tints = data.get("tints", {})
	_flash = ColorRect.new()
	_flash.color = Color(0.95, 0.97, 1.0, 0.0)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_flash)
	_bolt = Sprite2D.new()
	_bolt.visible = false
	_bolt.centered = false
	_bolt.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_bolt)
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_strike)
	add_child(_timer)
	if use_tint:
		_tint = CanvasModulate.new()
		get_parent().add_child.call_deferred(_tint)
	set_weather(recipe, 0.0)

func set_weather(name: String, fade: float = -1.0) -> void:
	if fade < 0.0:
		fade = fade_time
	for old in _layers:
		var tw := create_tween()
		tw.tween_property(old.material, "shader_parameter/opacity", 0.0, max(fade, 0.01))
		tw.tween_callback(old.queue_free)
	_layers.clear()
	_timer.stop()
	var r: Dictionary = _recipes.get(name, {})
	for v in r.get("layers", []):
		var png := "%s/%s_%spx.png" % [pack_dir, r["files"][v], tile_size]
		if not ResourceLoader.exists(png):
			continue                                   # the free pack has fewer overlays: skip what isn't there
		var rect := ColorRect.new()
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		rect.material = preload("weather_overlay.gd").make_material(_shader_path, png, pixel_scale, Vector2.ZERO, intensity)
		rect.material.set_shader_parameter("opacity", 0.0)
		add_child(rect)
		move_child(rect, _flash.get_index())          # under the flash and the bolt
		create_tween().tween_property(rect.material, "shader_parameter/opacity", 1.0, max(fade, 0.01))
		_layers.append(rect)
	if _tint:
		var c := Color(_tints.get(r.get("tint", "day"), "#ffffff"))
		create_tween().tween_property(_tint, "color", c, max(fade, 0.01))
	if r.get("lightning", false):
		_timer.start(randf_range(1.0, lightning_every.x))

func strike() -> void:
	_strike()

func _strike() -> void:
	var tw := create_tween()
	tw.tween_property(_flash, "color:a", 0.6, 0.03)
	tw.tween_property(_flash, "color:a", 0.0, 0.12)
	tw.tween_property(_flash, "color:a", 0.45, 0.04)
	tw.tween_property(_flash, "color:a", 0.0, 0.5)
	var bolts := []
	for i in range(1, 4):
		var p := "%s/extras/lightning_bolt_%d_%spx.png" % [pack_dir, i, tile_size]
		if ResourceLoader.exists(p):
			bolts.append(p)
	if bolts.size() > 0:
		var png: String = bolts.pick_random()
		var meta = JSON.parse_string(FileAccess.get_file_as_string(png.get_basename() + ".json"))
		_bolt.texture = load(png)
		_bolt.hframes = int(meta["frames"])
		_bolt.scale = Vector2(pixel_scale, pixel_scale)
		var view := get_viewport().get_visible_rect().size
		_bolt.position = Vector2(randf_range(0.1, 0.8) * view.x, randf_range(0.0, 0.25) * view.y)
		_bolt.visible = true
		var bt := create_tween()
		bt.tween_method(func(f: int): _bolt.frame = f, 0, int(meta["frames"]) - 1, int(meta["frames"]) / float(meta["fps"]))
		bt.tween_callback(func(): _bolt.visible = false)
	_timer.start(randf_range(lightning_every.x, lightning_every.y))

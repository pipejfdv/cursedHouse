# Attach to a ColorRect that covers the screen. Set `overlay_png`; the script reads the .json beside it and sets up
# the weather_overlay shader. Example: overlay_png = "res://weather/overlays/rain/rain_heavy_16px.png"
# For whole weather recipes (rain + splashes + cloud shadows + lightning, crossfades), use weather_controller.gd.
extends ColorRect

@export_file("*.png") var overlay_png: String
@export var pixel_scale: float = 1.0
@export var scroll: Vector2 = Vector2.ZERO
@export_range(1, 3) var intensity: int = 1

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader_path: String = get_script().resource_path.get_base_dir() + "/weather_overlay.gdshader"
	material = make_material(shader_path, overlay_png, pixel_scale, scroll, intensity)

# Builds the material for one overlay (the controller uses this too).
static func make_material(shader_path: String, png: String, zoom: float = 1.0, drift: Vector2 = Vector2.ZERO,
		heavy: int = 1) -> ShaderMaterial:
	var meta = JSON.parse_string(FileAccess.get_file_as_string(png.get_basename() + ".json"))
	var mat := ShaderMaterial.new()
	var shader: Shader = load(shader_path)
	if meta.get("blend", "mix") == "add":
		shader = shader.duplicate()
		shader.code = shader.code.replace("shader_type canvas_item;", "shader_type canvas_item;\nrender_mode blend_add;")
	mat.shader = shader
	mat.set_shader_parameter("sheet", load(png))
	mat.set_shader_parameter("columns", int(meta["columns"]))
	mat.set_shader_parameter("rows", int(meta["rows"]))
	mat.set_shader_parameter("frames", int(meta["frames"]))
	mat.set_shader_parameter("tile_px", Vector2(meta["width"], meta["height"]))
	mat.set_shader_parameter("fps", float(meta["fps"]))
	mat.set_shader_parameter("pixel_scale", zoom)
	mat.set_shader_parameter("scroll", drift)
	mat.set_shader_parameter("intensity", heavy)
	return mat

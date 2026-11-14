extends Node
## Provider for input binding glyphs.
##
## Part of SV Options. Use this to get the glyph that visually represents a
## particular input. Automatically adjusts glyph based on the current device.

var _joy_device_override := ""
var _current_joy_device := ""

var _generic_glyphs: GlyphSet
var _unique_glyphs: Dictionary[String, GlyphSet]


# Override
func _ready() -> void:
	OptionsConfigProvider.config_changed.connect(_on_options_config_provider_config_changed)


# Override
func _exit_tree() -> void:
	if OptionsConfigProvider.config_changed.is_connected(_on_options_config_provider_config_changed):
		OptionsConfigProvider.config_changed.disconnect(_on_options_config_provider_config_changed)


## Gets the glyph for the given input. Returns null if there is no glyph.
func get_glyph(event: InputEvent) -> Texture2D:
	var device_name := get_current_joy_device_name()
	
	if _unique_glyphs.keys().has(device_name):
		var glyph = _unique_glyphs[device_name].get_glyph(event)
		if glyph != null:
			return glyph
	
	return _generic_glyphs.get_glyph(event)


## Overrides joy device tracking so this service returns glyphs for the given
## device instead.
func set_joy_device_override(device_name: String) -> void:
	_joy_device_override = device_name


## Clears override set by [method set_joy_device_override]. Returns to displaying
## glyphs appropriate for the most recent joy device.
func clear_joy_device_override() -> void:
	_joy_device_override = ""


## Get the device name of the joypad currently being used for glyphs.
func get_current_joy_device_name() -> String:
	return _current_joy_device if _joy_device_override.is_empty() else _joy_device_override


# Signal connection
func _on_options_config_provider_config_changed(new_value: OptionsConfig) -> void:
	_generic_glyphs = new_value.generic_glyphs
	_unique_glyphs = new_value.unique_glyphs

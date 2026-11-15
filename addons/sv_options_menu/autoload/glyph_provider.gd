extends Node
## Provider for input binding glyphs.
##
## Part of SV Options. Use this to get the glyph that visually represents a
## particular input. Automatically adjusts glyph based on the current device.

var _joy_device_override := ""
var _current_joy_device_name := ""
var _current_joy_device_id := -1

var _generic_glyphs: GlyphSet
var _unique_glyphs: Dictionary[String, GlyphSet]

## Emitted whenever the provider detects a joy device change OR the override has
## changed. You should connect to this so you know when to get new glyphs.
##
## Note that some glyphs may not change between devices due to generic
## glyph fallbacks, or because they're not for a joypad device (e.g. mouse).
signal joy_device_changed


# Override
func _ready() -> void:
	OptionsConfigProvider.config_changed.connect(_on_options_config_provider_config_changed)
	Input.joy_connection_changed.connect(_on_input_joy_connection_changed)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var connected_devices := Input.get_connected_joypads()
	if connected_devices.size() > 0:
		_current_joy_device_name = Input.get_joy_name(connected_devices[0])
		_current_joy_device_id = connected_devices[0]
		joy_device_changed.emit()


# Override
func _input(event: InputEvent) -> void:
	if event.device == _current_joy_device_id:
		return # No change
	
	if not ((event is InputEventJoypadButton) or (event is InputEventJoypadMotion)):
		return # Not a joypad
	
	_current_joy_device_name = Input.get_joy_name(event.device)
	_current_joy_device_id = event.device
	if _joy_device_override.is_empty():
		joy_device_changed.emit()
	
	# Do not set as handled. We are only listening to see what controller is
	# currently being used, but the player is likely doing something else with
	# their inputs.


# Override
func _exit_tree() -> void:
	if OptionsConfigProvider.config_changed.is_connected(_on_options_config_provider_config_changed):
		OptionsConfigProvider.config_changed.disconnect(_on_options_config_provider_config_changed)
	
	if Input.joy_connection_changed.is_connected(_on_input_joy_connection_changed):
		Input.joy_connection_changed.disconnect(_on_input_joy_connection_changed)


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
##
## Usually you should do this on platforms where only one type of controller is
## ever expected. e.g. you might leave the override clear on PC to support a
## range of controllers, but set the override on steam deck so you always
## show glyphs that meet steam deck verified requirements.
func set_joy_device_override(device_name: String) -> void:
	_joy_device_override = device_name
	if _current_joy_device_name != _joy_device_override:
		joy_device_changed.emit()


## Clears override set by [method set_joy_device_override]. Returns to displaying
## glyphs appropriate for the most recent joy device.
func clear_joy_device_override() -> void:
	var override_before_clear = _joy_device_override
	_joy_device_override = ""
	if _current_joy_device_name != override_before_clear:
		joy_device_changed.emit()


## Get the device name of the joypad currently being used for glyphs.
func get_current_joy_device_name() -> String:
	return _current_joy_device_name if _joy_device_override.is_empty() else _joy_device_override


# Signal connection
func _on_options_config_provider_config_changed(new_value: OptionsConfig) -> void:
	_generic_glyphs = new_value.generic_glyphs
	_unique_glyphs = new_value.unique_glyphs


# Signal connection
func _on_input_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		if not _current_joy_device_name.is_empty():
			return
		var new_name := Input.get_joy_name(device)
		if new_name != _current_joy_device_name:
			_current_joy_device_name = new_name
			_current_joy_device_id = device
			if _joy_device_override.is_empty():
				joy_device_changed.emit()
	else:
		for id in Input.get_connected_joypads():
			if Input.get_joy_name(id) == _current_joy_device_name:
				# Current joy device was not disconnected. Ignore.
				return
		_current_joy_device_name = ""
		_current_joy_device_id = -1
		if _joy_device_override.is_empty():
			joy_device_changed.emit()
	

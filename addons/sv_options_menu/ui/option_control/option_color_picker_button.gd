class_name OptionColorPickerButton
extends ColorPickerButton
## [ColorPickerButton] linked to an option in SV Options.
##
## This `ColorPickerButton` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## The [Color] is stored on the [GameOptions] as an HTML [String]. See [method Color.to_html].
##
## Note that changing the color in a way that does not emit [signal color_changed]
## will not forward the change to the option as it relies on signals to detect
## when toggled.

## Path of option to link to. See [GameOptions].
@export var option_path := "":
	set(value):
		option_path = value
		if _accessor != null:
			_accessor.option_path = value
	get:
		return option_path

## Set to `true` if the option specified by [member option_path] is found on
## cloud options instead of local options.
@export var cloud := false:
	set(value):
		cloud = value
		if _accessor != null:
			_accessor.cloud = value
	get:
		return cloud


@export_group("Color Picker")
## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_can_add_swatches := true:
	set(value):
		get_picker().can_add_swatches = value
	get:
		return get_picker().can_add_swatches

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_color_mode: ColorPicker.ColorModeType = ColorPicker.ColorModeType.MODE_RGB:
	set(value):
		get_picker().color_mode = value
	get:
		return get_picker().color_mode

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_color_modes_visible := true:
	set(value):
		get_picker().color_modes_visible = value
	get:
		return get_picker().color_modes_visible

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_deferred_mode := false:
	set(value):
		get_picker().deferred_mode = value
	get:
		return get_picker().deferred_mode

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_hex_visible := true:
	set(value):
		get_picker().hex_visible = value
	get:
		return get_picker().hex_visible

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_picker_shape: ColorPicker.PickerShapeType = ColorPicker.PickerShapeType.SHAPE_HSV_RECTANGLE:
	set(value):
		get_picker().picker_shape = value
	get:
		return get_picker().picker_shape

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_presets_visible := true:
	set(value):
		get_picker().presets_visible = value
	get:
		return get_picker().presets_visible

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_sampler_visible := true:
	set(value):
		get_picker().sampler_visible = value
	get:
		return get_picker().sampler_visible

## Pass-through for [ColorPicker]. Provided here because [ColorPickerButton]
## currently doesn't provide exported properties for these (last checked in
## Godot 4.7).
@export var color_picker_sliders_visible := true:
	set(value):
		get_picker().sliders_visible = value
	get:
		return get_picker().sliders_visible

var _accessor: OptionAccessor


# Override
func _ready() -> void:
	_accessor = OptionAccessor.new()
	add_child(_accessor)
	
	_accessor.option_path = option_path
	_accessor.cloud = cloud
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	color_changed.connect(_on_color_changed)
	
	var starting_value := _accessor.get_value()
	if starting_value is String:
		color = Color.from_string(starting_value, Color.WHITE)
	else:
		push_error("Cannot set OptionColorPickerButton starting value because linked option was not a String.")


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if color_changed.is_connected(_on_color_changed):
		color_changed.disconnect(_on_color_changed)


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if new_value is String:
		color = Color.from_string(new_value, Color.WHITE)
	else:
		push_error("Cannot set OptionColorPickerButton value because linked option was not a String.")


# Signal connection
func _on_color_changed(color: Color) -> void:
	_accessor.set_value(color.to_html())

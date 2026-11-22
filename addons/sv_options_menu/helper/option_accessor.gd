class_name OptionAccessor
extends Node
## A [Node] that controls access to an option in SV Options.
##
## `OptionsAccessor` listens for and emits changes to a configured option as a
## signal, and also can be used to change that option. It is a kind of two-way
## sync.

## Path of option to link to. See [GameOptions].
@export var option_path := ""

## Set to `true` if the option specified by [member option_path] is found on
## cloud options instead of local options.
@export var cloud := false

# TODO: Doesn't currently emit when options is swapped out on OptionsProvider
## Emitted when the linked option is changed.
signal option_modified(new_value: Variant)


var _local_options: GameOptions:
	set(value):
		var old := _local_options
		if old != null:
			if old.option_modified.is_connected(_on_local_options_option_modified):
				old.option_modified.disconnect(_on_local_options_option_modified)
		_local_options = value
		if value != null:
			if not value.option_modified.is_connected(_on_local_options_option_modified):
				value.option_modified.connect(_on_local_options_option_modified)
	get:
		return _local_options
var _cloud_options: GameOptions:
	set(value):
		var old := _cloud_options
		if old != null:
			if old.option_modified.is_connected(_on_cloud_options_option_modified):
				old.option_modified.disconnect(_on_cloud_options_option_modified)
		_cloud_options = value
		if value != null:
			if not value.option_modified.is_connected(_on_cloud_options_option_modified):
				value.option_modified.connect(_on_cloud_options_option_modified)
	get:
		return _cloud_options


# Override
func _ready() -> void:
	OptionsProvider.local_options_changed.connect(_on_options_provider_local_options_changed)
	OptionsProvider.cloud_options_changed.connect(_on_options_provider_cloud_options_changed)
	
	_local_options = OptionsProvider.get_local_options()
	_cloud_options = OptionsProvider.get_cloud_options()


# Override
func _exit_tree() -> void:
	if OptionsProvider.local_options_changed.is_connected(_on_options_provider_local_options_changed):
		OptionsProvider.local_options_changed.disconnect(_on_options_provider_local_options_changed)
	
	if OptionsProvider.local_options_changed.is_connected(_on_options_provider_cloud_options_changed):
		OptionsProvider.local_options_changed.disconnect(_on_options_provider_cloud_options_changed)
	
	# Disconnects signals
	_local_options = null
	_cloud_options = null


## Sets the linked option to the given value.
func set_option(value: Variant) -> void:
	var options = _cloud_options if cloud else _local_options
	if options == null:
		push_error("OptionAccessor cannot set option because options resource is null.")
		return
	
	options.set_option(option_path, value)


## Gets the current value of the linked option.
func get_option() -> Variant:
	var options = _cloud_options if cloud else _local_options
	if options == null:
		push_error("OptionAccessor cannot get option because options resource is null. Returning default of null.")
		return null
	
	return options.get_option(option_path)


# Signal connection
func _on_options_provider_local_options_changed(new_value: GameOptions) -> void:
	_local_options = new_value


# Signal connection
func _on_options_provider_cloud_options_changed(new_value: GameOptions) -> void:
	_cloud_options = new_value


# Signal connection
func _on_local_options_option_modified(path: String, new_value: Variant) -> void:
	if cloud:
		return
	
	if path != option_path:
		return
	
	option_modified.emit(new_value)


# Signal connection
func _on_cloud_options_option_modified(path: String, new_value: Variant) -> void:
	if not cloud:
		return
	
	if path != option_path:
		return
	
	option_modified.emit(new_value)

class_name _OptionComboSlider
extends _ComboSlider
## [_ComboSlider] linked to an option in SV Options.
##
## This `ComboSlider` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## Note that changing the value by calling [method set_value_no_signal]
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

@onready var _accessor: OptionAccessor = $OptionAccessor


# Override
func _ready() -> void:
	super()
	
	# Propagate pass-throughs to accessor
	option_path = option_path
	cloud = cloud
	
	var starting_value: Variant = _accessor.get_value()
	if (starting_value is float) or (starting_value is int):
		set_value_no_signal(starting_value)
	else:
		push_error("Cannot set starting value of OptionComboSlider because it was wrong type.")
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	value_changed.connect(_on_value_changed)


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if value_changed.is_connected(_on_value_changed):
		value_changed.disconnect(_on_value_changed)
	
	super()


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if (new_value is float) or (new_value is int):
		value = new_value
	else:
		push_error("Cannot set OptionComboSlider to new option value as it is the wrong type.")


# Signal connection
func _on_value_changed(to: float) -> void:
	_accessor.set_value(to)

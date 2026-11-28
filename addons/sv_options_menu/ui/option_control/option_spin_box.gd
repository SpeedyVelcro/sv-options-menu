class_name OptionSpinBox
extends SpinBox
## [SpinBox] linked to an option in SV Options.
##
## This `SpinBox` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## Note that changing the value by calling [method set_value_no_signal]
## will not forward the change to the option as it relies on signals to detect
## when changed.
# TODO: Exported property to always cast to integer (using roundi()) when saving
# to options.

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

var _accessor: OptionAccessor


# Override
func _ready() -> void:
	_accessor = OptionAccessor.new()
	add_child(_accessor)
	
	_accessor.option_path = option_path
	_accessor.cloud = cloud
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	value_changed.connect(_on_value_changed)
	
	var starting_value := _accessor.get_value()
	if (starting_value is float) or (starting_value is int):
		set_value_no_signal(starting_value)
	else:
		push_error("Cannot set OptionSpinBox starting value because linked option was wrong type.")


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if value_changed.is_connected(_on_value_changed):
		value_changed.disconnect(_on_value_changed)


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if (new_value is float) or (new_value is int):
		set_value_no_signal(new_value)
	else:
		push_error("Cannot set OptionSpinBox value because linked option was wrong type.")


# Signal connection
func _on_value_changed(new_value: float) -> void:
	_accessor.set_value(new_value)

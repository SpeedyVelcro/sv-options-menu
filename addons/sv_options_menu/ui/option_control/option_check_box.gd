class_name OptionCheckBox
extends CheckBox
## [CheckBox] linked to an option in SV Options.
##
## This `CheckButton` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## Note that changing the toggle status by calling [method set_pressed_no_signal]
## will not forward the change to the option as it relies on signals to detect
## when toggled.
# NB: This is mostly a duplicate of OptionCheckButton. A necessary evil, since
# CheckBox has different inheritance.

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
	toggled.connect(_on_toggled)
	
	var starting_value := _accessor.get_option()
	if starting_value is bool:
		set_pressed_no_signal(starting_value)
	else:
		push_error("Cannot set OptionCheckBox starting toggle status because linked option was not a bool.")


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if toggled.is_connected(_on_toggled):
		toggled.disconnect(_on_toggled)


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if new_value is bool:
		set_pressed_no_signal(new_value)
	else:
		push_error("Cannot set OptionCheckBox toggle status because linked option was not a bool.")


# Signal connection
func _on_toggled(toggled_on: bool) -> void:
	_accessor.set_option(toggled_on)

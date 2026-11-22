class_name OptionLineEdit
extends LineEdit
## [LineEdit] linked to an option in SV Options.
##
## This `LineEdit` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## Note that changing the text by setting [member text]
## will not forward the change to the option as it relies on signals to detect
## when toggled.

## Possible values for [member modify_option_on].
enum ModifyOptionCondition {
	## When [signal text_changed] is emitted.
	TEXT_CHANGED,
	## When [signal editing_toggled] is emitted on switching out of edit mode.
	EDITING_TOGGLED_OFF,
	## When [signal text_submitted] is emitted, which usually happens when
	## the player presses enter.
	TEXT_SUBMITTED
}

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

## Condition for submitting the modified text. The linked option will be modified
## when this condition is met. By default, the option is modified when editing
## is toggled off.
@export var modify_option_on: ModifyOptionCondition = ModifyOptionCondition.EDITING_TOGGLED_OFF

var _accessor: OptionAccessor


# Override
func _ready() -> void:
	_accessor = OptionAccessor.new()
	add_child(_accessor)
	
	_accessor.option_path = option_path
	_accessor.cloud = cloud
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	editing_toggled.connect(_on_editing_toggled)
	text_changed.connect(_on_text_changed)
	text_submitted.connect(_on_text_submitted)
	
	var starting_value := _accessor.get_option()
	if starting_value is String:
		text = starting_value
	else:
		push_error("Cannot set OptionLineEdit starting value because linked option was not a String.")


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if editing_toggled.is_connected(_on_editing_toggled):
		editing_toggled.disconnect(_on_editing_toggled)
	
	if text_changed.is_connected(_on_text_changed):
		text_changed.disconnect(_on_text_changed)
	
	if text_submitted.is_connected(_on_text_submitted):
		text_submitted.disconnect(_on_text_submitted)


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if new_value is String:
		text = new_value
	else:
		push_error("Cannot set OptionLineEdit value because linked option was not a String.")


# Signal connection
func _on_editing_toggled(toggled_on: bool) -> void:
	if modify_option_on != ModifyOptionCondition.EDITING_TOGGLED_OFF:
		return
	
	if not toggled_on:
		_accessor.set_option(text)


# Signal connection
func _on_text_changed(new_text: String) -> void:
	if modify_option_on != ModifyOptionCondition.TEXT_CHANGED:
		return
	
	_accessor.set_option(new_text)


# Signal connection
func _on_text_submitted(new_text: String) -> void:
	if modify_option_on != ModifyOptionCondition.TEXT_SUBMITTED:
		return
	
	_accessor.set_option(new_text)

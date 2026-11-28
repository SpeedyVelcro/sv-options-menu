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

@export_group("Option Update")
## Modify option when [signal text_changed] is emitted. Affected by [member update_debounce].
@export var update_on_text_changed := true

## Modify option when [signal editing_toggled] is emitted on switching out of edit mode.
##
## This modifies the option immediately, skipping any debounce.
@export var update_on_editing_toggled_off := true

## Modify option when [signal text_submitted] is emitted, which usually happens
## when the player presses enter.
##
## This modifies the option immediately, skipping any debounce.
@export var update_on_text_submitted := true

## Debounce option modifications caused by text changing. See [member update_on_text_changed].
## The debounce time is set by [member update_debounce_time_secs].
##
## Any debounce is skipped by certain higher-priority events. See
## [member modify_on_editing_toggled_off] and [member update_on_text_submitted].
@export var update_debounce := true:
	set(value):
		update_debounce = value
		if _debounce_timer == null:
			return
		if not update_debounce:
			if not _debounce_timer.is_stopped():
				_debounce_timer.stop()
				update_option()
	get:
		return update_debounce

## Time to debounce if [member update_debounce] is [code]true[/code].
@export var update_debounce_time_secs: float = 1.0

var _accessor: OptionAccessor
var _debounce_timer: Timer


# Override
func _ready() -> void:
	_accessor = OptionAccessor.new()
	add_child(_accessor)
	
	_debounce_timer = Timer.new()
	add_child(_debounce_timer)
	
	_accessor.option_path = option_path
	_accessor.cloud = cloud
	
	_debounce_timer.one_shot = true
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	_debounce_timer.timeout.connect(_on_debounce_timer_timeout)
	editing_toggled.connect(_on_editing_toggled)
	text_changed.connect(_on_text_changed)
	text_submitted.connect(_on_text_submitted)
	
	var starting_value := _accessor.get_value()
	if starting_value is String:
		text = starting_value
	else:
		push_error("Cannot set OptionLineEdit starting value because linked option was not a String.")


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if _debounce_timer.timeout.is_connected(_on_debounce_timer_timeout):
		_debounce_timer.timeout.disconnect(_on_debounce_timer_timeout)
	
	if editing_toggled.is_connected(_on_editing_toggled):
		editing_toggled.disconnect(_on_editing_toggled)
	
	if text_changed.is_connected(_on_text_changed):
		text_changed.disconnect(_on_text_changed)
	
	if text_submitted.is_connected(_on_text_submitted):
		text_submitted.disconnect(_on_text_submitted)
	
	if not _debounce_timer.is_stopped():
		_debounce_timer.stop()
		update_option()


## Updates the option specified by [member option_path] to the value of [member text].
## This happens automatically depending on how you've set this node's exported
## properties.
func update_option(to := text) -> void:
	if not _debounce_timer.is_stopped():
		_debounce_timer.stop()
	
	_accessor.set_value(to)


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if new_value is String:
		text = new_value
	else:
		push_error("Cannot set OptionLineEdit value because linked option was not a String.")


# Signal connection
func _on_debounce_timer_timeout() -> void:
	update_option()


# Signal connection
func _on_editing_toggled(toggled_on: bool) -> void:
	if not update_on_editing_toggled_off:
		return
	
	if toggled_on:
		return
	
	update_option()


# Signal connection
func _on_text_changed(new_text: String) -> void:
	if not update_on_text_changed:
		return
	
	if update_debounce:
		_debounce_timer.start(update_debounce_time_secs)
	else:
		update_option(new_text)


# Signal connection
func _on_text_submitted(new_text: String) -> void:
	if not update_on_text_submitted:
		return
	
	update_option(new_text)

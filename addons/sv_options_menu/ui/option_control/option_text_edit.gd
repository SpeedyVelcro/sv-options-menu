class_name OptionTextEdit
extends TextEdit
## [TextEdit] linked to an option in SV Options.
##
## This `TextEdit` will update itself to reflect a configured option, and
## modify that option when changed by the user.

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
## Modify option when [signal lines_edited_from] is emitted. Affected by [member update_debounce].
@export var update_on_lines_edited_from := false

## Modify option when [signal text_changed] is emitted. Affected by [member update_debounce].
@export var update_on_text_changed := true

## Modify option when [signal text_set] is emitted. Affected by [member update_debounce].
@export var update_on_text_set := false

## Debounce option modifications caused by text changing. See [member update_on_text_changed],
## [member update_on_text_set], and [member update_on_lines_edited_from].
## The debounce time is set by [member update_debounce_time_secs].
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
	lines_edited_from.connect(_on_lines_edited_from)
	text_changed.connect(_on_text_changed)
	text_set.connect(_on_text_set)
	
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
	
	if lines_edited_from.is_connected(_on_lines_edited_from):
		lines_edited_from.disconnect(_on_lines_edited_from)
	
	if text_changed.is_connected(_on_text_changed):
		text_changed.disconnect(_on_text_changed)
	
	if text_set.is_connected(_on_text_set):
		text_set.disconnect(_on_text_set)
	
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
		var original_caret_lines: Array[int] = []
		var original_caret_columns: Array[int] = []
		var original_carets_at_end_of_text: Array[bool] = []
		var original_caret_count: int = 0
		
		for i in range(get_caret_count()):
			original_caret_count += 1
			
			var line := get_caret_line(i)
			var column := get_caret_column(i)
			
			original_caret_lines.append(get_caret_line(i))
			original_caret_columns.append(get_caret_column(i))
			original_carets_at_end_of_text.append(line >= get_line_count() - 1 \
					and column >= get_line(i).length() ) # Not -1 because caret can be after final character of line
		
		text = new_value
		
		for i in range(original_caret_count):
			var original_line := original_caret_lines[i]
			var original_column := original_caret_columns[i]
			var end_of_text := original_carets_at_end_of_text[i]
			var line: int
			var column: int
			
			if end_of_text or original_line > get_line_count() - 1:
				line = get_line_count() - 1
				column = get_line(get_line_count() - 1).length()
			else:
				line = original_line
				if original_column > get_line(line).length():
					column = get_line(line).length()
				else:
					column = original_column
			
			if i >= get_caret_count():
				add_caret(line, column)
			else:
				set_caret_line(line, true, true, -1, i)
				set_caret_column(column, true, i)
	else:
		push_error("Cannot set OptionLineEdit value because linked option was not a String.")


# Signal connection
func _on_debounce_timer_timeout() -> void:
	update_option()


# Signal connection
func _on_lines_edited_from(from_line: int, to_line: int) -> void:
	if not update_on_lines_edited_from:
		return
	
	if update_debounce:
		_debounce_timer.start(update_debounce_time_secs)
	else:
		update_option()


# Signal connection
func _on_text_changed() -> void:
	if not update_on_text_changed:
		return
	
	if update_debounce:
		_debounce_timer.start(update_debounce_time_secs)
	else:
		update_option()


# Signal connection
func _on_text_set() -> void:
	if not update_on_text_set:
		return
	
	if update_debounce:
		_debounce_timer.start(update_debounce_time_secs)
	else:
		update_option()

extends HBoxContainer
## Editor UI for a single input event
##
## Modifies or deletes a single input event for use by an action of the input
## map.

## Current [InputEvent] that is set. Null if no input event is currently set
## (generally only the case when listening for an input event as typically
## deleting is the only way to unset the event)
# TODO: modify input map on update (or should this be done further up the node tree?)

@export var input_event: InputEvent = null:
	set(value):
		input_event = value
		if not _listening:
			_update_text_to_input_event()
	get:
		return input_event
## True if the input event is locked and uneditable.
@export var locked: bool = false:
	set(value):
		locked = value
		if locked:
			_listening = false
		if _binding_button != null:
			_binding_button.disabled = locked if not _listening else _listening
		if _delete_button != null:
			_delete_button.visible = not locked
	get:
		return locked

@onready var _binding_button: Button = $BindingButton
@onready var _delete_button: Button = $DeleteButton
@onready var _listening_visual_timer: Timer = $ListeningVisualTimer

## True if the input event editor is listening for input to change the input
## event.
var _listening: bool = false:
	set(value):
		if not locked:
			if _binding_button != null:
				_binding_button.disabled = value
				_binding_button.toggle_mode = value
		if value and not _listening: # Don't want to interrupt existing listening animation
			_listening_visual_timer.start(0.5)
			_update_listening_text()
		elif (not value) and _listening:
			_listening_visual_timer.stop()
			_update_text_to_input_event()
		_listening = value
	get:
		return _listening


# Override
func _ready() -> void:
	# Because export setters were called before ready, they couldn't affect child nodes yet:
	locked = locked
	
	_listening_visual_timer.timeout.connect(_update_listening_text)


# Override
func _exit_tree() -> void:
	_listening_visual_timer.timeout.disconnect(_update_listening_text)


func _input(event: InputEvent) -> void:
	const JOYPAD_AXIS_THRESHOLD = 0.5
	
	if not _listening:
		return
	
	# Guard against event types that should not be bindable
	if event is InputEventKey:
		match event.keycode:
			Key.KEY_SHIFT, Key.KEY_CTRL, Key.KEY_ALT, Key.KEY_META:
				if event.is_pressed():
					# Need to wait in-case it is being used as a modifier for
					# another key. If the player is actually trying to bind a modifier
					# key on its own, we can take it when it's released
					return
			_:
				if event.is_released():
					return
	elif event is InputEventMouse or event is InputEventJoypadButton:
		if event.is_released():
			return
	elif event is InputEventJoypadMotion:
		if event.axis_value < JOYPAD_AXIS_THRESHOLD:
			return
	else:
		return
	
	var saved_event = event.duplicate_deep()
	
	if saved_event is InputEventJoypadMotion:
		saved_event.axis_value = JOYPAD_AXIS_THRESHOLD # We do not need to record the actual pressure
	
	if saved_event is InputEventFromWindow:
		saved_event.window_id = 0 # Irrelevant info, just set to the default window
	
	if saved_event is InputEventKey:
		# If this event is a modifier on its own, we would only get to this point
		# on release (see above guards). So change the binding to pressed.
		saved_event.pressed = true
		# TODO: Handle event.command_or_control_autoremap?
	
	if saved_event is InputEventMouse:
		# Don't record positions, we are just binding mouse buttons.
		saved_event.position = Vector2(0, 0)
		saved_event.global_position = Vector2(0, 0)
	
	input_event = saved_event
	_listening = false
	
	get_viewport().set_input_as_handled()


func _update_text_to_input_event() -> void:
	if input_event == null:
		return
	
	_binding_button.text = InputEventTextBuilder.build_text(input_event)


func _update_listening_text() -> void:
	if _binding_button == null: return
	
	match _binding_button.text:
		".":
			_binding_button.text = ".."
		"..":
			_binding_button.text = "..."
		"...", _:
			_binding_button.text = "."


# Signal connection
func _on_binding_button_pressed() -> void:
	_listening = true


# Signal connection
func _on_delete_button_pressed() -> void:
	queue_free()

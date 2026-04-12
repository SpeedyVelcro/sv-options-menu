extends VBoxContainer
## Editor for an input map action
##
## UI for editing one input map action. Displays the name and allows you to
## modify, add, and delete input events.

## The [InputMap] action that this ActionEditor edits. The value should be
## the same as one of the actions returned by [method InputMap.get_actions].
@export var action: String = "":
	set(value):
		action = value
		_populate_action_editors()
	get:
		return action

@onready var _label: Label = $Label
@onready var _action_container: Control = $HFlowContainer
@onready var _add_button: Button = $HFlowContainer/AddButton

var _input_event_editor_scene = preload("res://addons/sv_options_menu/ui/input_map_settings_ui/action_editor/event_editor/input_event_editor.tscn") 


# Override
func _ready() -> void:
	_populate_action_editors()



func _populate_action_editors():
	var options_config := OptionsConfigProvider.get_config()
	
	if _action_container == null:
		return # Not ready yet. Fail silently because this method will be re-run in _ready() anyway
	
	for node: Node in _action_container.get_children().filter(func (n: Node): return n.name.contains("InputEventEditor")):
		node.queue_free()
	
	if not InputMap.has_action(action):
		push_error("Action %s does not exist on the input map. Action editor will not work." % action)
		_label.text = "INVALID ACTION"
		return
	
	var events := InputMap.action_get_events(action)
	
	var i = 0
	for event: InputEvent in events:
		var _input_event_editor: Control = _input_event_editor_scene.instantiate()
		_input_event_editor.name = "InputEventEditor%d" % (i + 1) if i > 0 else "InputEventEditor"
		_input_event_editor.input_event = event
		if options_config.locked_input_events.has(action):
			if options_config.locked_input_events[action].locked_events.any(func (e: InputEvent): return e.as_text() == event.as_text()):
				_input_event_editor.locked = true # TODO: the string comparison to check if we do this: is it robust enough?
		_action_container.add_child(_input_event_editor)
		
		i += 1
	
	_add_button.get_parent().move_child(_add_button, -1)

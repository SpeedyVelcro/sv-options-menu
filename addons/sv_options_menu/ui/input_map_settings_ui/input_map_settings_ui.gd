extends VBoxContainer
## UI for editing input map
##
## UI for editing all events in [InputMap] that have been declared editable in
## [property OptionsConfig.editable_input_actions]

var _action_editor_scene = preload("res://addons/sv_options_menu/ui/input_map_settings_ui/action_editor/action_editor.tscn") 


# Override
func _ready() -> void:
	_populate_action_editors()


func _populate_action_editors():
	var options_config := OptionsConfigProvider.get_config()
	
	for node: Node in get_children().filter(func (n: Node): return n.name.contains("ActionEditor")):
		node.queue_free()
	
	if not options_config.manage_input_map:
		visible = false
		return
	
	var actions := options_config.editable_input_actions
	
	var i = 0
	for action: String in actions:
		var _action_editor: Control = _action_editor_scene.instantiate()
		_action_editor.name = "ActionEditor%d" % (i + 1) if i > 0 else "ActionEditor"
		_action_editor.action = action
		add_child(_action_editor)
		
		i += 1

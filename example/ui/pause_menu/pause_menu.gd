extends Control
## Pause menu
##
## Pause menu during gampelay

@onready var _options_menu: Control = $OptionsMenu
@onready var _pause_menu_panel: Control = $CenterContainer/PanelContainer


# Override
func _ready() -> void:
	visible = get_tree().paused


# Override
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		_pause_menu_panel.visible = true
		_options_menu.visible = false


# Signal connection
func _on_options_button_pressed() -> void:
	_pause_menu_panel.visible = false
	_options_menu.visible = true


# Signal connection
func _on_exit_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://example/main.tscn")


# Signal connection
func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false


# Signal connection
func _on_options_menu_back_pressed() -> void:
	_options_menu.visible = false
	_pause_menu_panel.visible = true

extends Control
## Example game main menu
##
## Main menu for the example game

@onready var _main_menu_panel: Control = $MarginContainer/MainMenuPanel
@onready var _options_menu: Control = $OptionsMenu

# Signal connection
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://example/level/test_level.tscn")


# Signal connection
func _on_options_button_pressed() -> void:
	_main_menu_panel.visible = false
	_options_menu.visible = true


# Signal connection
func _on_quit_button_pressed() -> void:
	get_tree().quit()


# Signal Connection
func _on_options_menu_back_pressed() -> void:
	_main_menu_panel.visible = true
	_options_menu.visible = false

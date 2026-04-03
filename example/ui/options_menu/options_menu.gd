extends Control
## Example game options menu
##
## User interface containing all options for the example game

## Emitted when the back button is predd
signal back_pressed


# Signal connection
func _on_back_button_pressed() -> void:
	OptionsSaver.save()
	back_pressed.emit()

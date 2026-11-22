extends Camera2D
## Player camera for the example game in SV Options.
##
## This example shows a fairly fragile method of manually connecting to options.
## For most purposes it is fine, however it will not detect that the [GameOptions]
## provided by the [OptionsProvider] has changed if it changes for any reason.

var _options: GameOptions


# Override
func _ready() -> void:
	_options = OptionsProvider.get_local_options()
	_options.option_modified.connect(_on_options_option_modified)
	
	var smoothing_value = _options.get_option("general/camera/smoothing")
	if smoothing_value is bool:
		position_smoothing_enabled = smoothing_value
	else:
		push_error("general/camera/smoothing is not a bool.")


# Override
func _exit_tree() -> void:
	_options.option_modified.disconnect(_on_options_option_modified)


# Signal connection
func _on_options_option_modified(path: String, new_value: Variant) -> void:
	match path:
		"general/camera/smoothing":
			if new_value is not bool:
				push_error("general/camera/smoothing is not a bool.")
				return
			position_smoothing_enabled = new_value

@tool
extends EditorPlugin

## Name of the OptionsConfigProvider autoload
const OPTIONS_CONFIG_PROVIDER_AUTOLOAD_NAME = "OptionsConfigProvider"

# Override
func _enter_tree():
	add_autoload_singleton(OPTIONS_CONFIG_PROVIDER_AUTOLOAD_NAME, "res://addons/sv_options_menu/autoload/options_config_provider.gd")
	
	if not FileAccess.file_exists(OptionsConstants.OPTIONS_CONFIG_PATH):
		var config := OptionsConfig.new()
		ResourceSaver.save(config, OptionsConstants.OPTIONS_CONFIG_PATH)
	


# Override
func _exit_tree():
	remove_autoload_singleton(OPTIONS_CONFIG_PROVIDER_AUTOLOAD_NAME)
	
	# We do not delete the OptionsConfig as that could lead to accidental data loss.

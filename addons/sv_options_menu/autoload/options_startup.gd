extends Node
## Orchestrates startup operations for SV Options Menu
##
## This node should be autoloaded after all other SV Options Menu autoloads. It
## will then perform the setup steps - namely loading files.


# Override
func _ready():
	var options_config = _load_options_config()
	
	OptionsConfigProvider.set_config(options_config)
	OptionsProvider.set_default_options(options_config.default_options)
	OptionsProvider.set_local_options(OptionsRepository.new(options_config.local_options_file_path).load_options())
	OptionsProvider.set_cloud_options(OptionsRepository.new(options_config.cloud_options_file_path).load_options())


func _load_options_config() -> OptionsConfig:
		var options_config = load(OptionsConstants.OPTIONS_CONFIG_PATH)
		assert(options_config is OptionsConfig, "Tried to load OptionsConfig from %s but did not get an OptionsConfig. Maybe it is missing or corrupted?" % OptionsConstants.OPTIONS_CONFIG_PATH)
		return options_config

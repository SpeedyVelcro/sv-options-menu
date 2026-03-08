extends Node
## Provides [OptionsConfig]
##
## Provides the [OptionsConfig] that was configured by the developer

var _options_config: OptionsConfig


# Override
func _init():
	_options_config = load(OptionsConstants.OPTIONS_CONFIG_PATH)
	assert(_options_config is OptionsConfig, "Tried to load OptionsConfig from %s but did not get an OptionsConfig. Maybe it is missing or corrupted?" % OptionsConstants.OPTIONS_CONFIG_PATH)


## Gets the [OptionsConfig]
func get_config():
	return _options_config

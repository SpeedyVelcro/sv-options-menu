extends Node
## AutoLoad service for saving user settings
##
## Provides a method to save all user settings (both local and cloud [GameOptions]).
## Should be autoloaded as "OptionsSaver".

var _local_repository: OptionsRepository
var _cloud_repository: OptionsRepository


# Override
func _ready():
	var options_config := OptionsConfigProvider.get_config()
	
	_local_repository = OptionsRepository.new(options_config.local_options_file_path)
	_cloud_repository = OptionsRepository.new(options_config.cloud_options_file_path)


## Saves both local and cloud options (from [OptionsProvider]) to the
## locations on disk configured by [OptionsConfig].
func save() -> void:
	_local_repository.save_options(OptionsProvider.get_local_options())
	_cloud_repository.save_options(OptionsProvider.get_cloud_options())

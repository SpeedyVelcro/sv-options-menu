class_name OptionsRepository
extends Node
## Orchestrates saving and loading options
##
## Abstraction layer for saving and loading options files from a given file
## path on disk. The path - and the intended fallback options (if any, usually
## some default settings) are injected at construction.

var _path: String
var _fallback: GameOptions


# Override
func _init(path: String, fallback: GameOptions = null):
	_path = path
	_fallback = fallback


## Saves the user-configured options to the file assocsiated with this
## [OptionsRepository]. Does not save any values from fallback.
func save_options(options: GameOptions):
	pass # TODO


## Loads the user-configured options from the file associated with this
## [OptionsRepository], and assigns the fallback, if any.
func load_options() -> GameOptions:
	var options = _read_options_from_disk()
	
	if _fallback != null:
		options.set_fallback(_fallback)
	
	return options


func _read_options_from_disk() -> GameOptions:
	if not FileAccess.file_exists(_path):
		push_warning("Options file did not exist at path \"%s\", using new options instead." % _path)
		return GameOptions.new()
	
	var file := FileAccess.open(_path, FileAccess.READ)
	
	if not file:
		push_error("Failed to read options file at path \"%s\", using new options instead." % _path)
		return GameOptions.new()
	
	var contents := file.get_as_text()
	file.close()
	
	var dict := JSON.parse_string(contents)
	
	if dict is not Dictionary:
		push_error("Failed to parse options file at path \"%s\". Maybe the JSON is malformed? Using new options instead." % _path)
		return GameOptions.new()
	
	var options = GameOptions.deserialize(dict)
	return options

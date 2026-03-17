class_name GameOptions
extends Resource
## User-configured options for the game
##
## Encapsulates a [Dictionary] of user-configured options, with associated
## utility methods for reading and changing these options. The dictionary
## is a dictionary of values and, possibly, nested dictionaries.

var _options: Dictionary[String, Variant]
var _fallback: GameOptions = null


# Override
func _init(dictionary: Dictionary[String, Variant] = {}):
	assert(dictionary.keys().all(func(key: Variant): key is String), "Constructing GameOptions: Source dictionary for GameOptions needs to have all string keys at the top level.")
	
	_options = dictionary


## Returns the option at the given key. Tries to retrieve the option from the
## fallback set by [method set_fallback] if it hasn't been set; otherwise
## returns null.
##
## Options nested multiple dictionaries deep can be retrieved using a path
## formed of forward-slash-separated keys such as [code]"path/to/option"[/code].
func get_option(key_or_path: String) -> Variant:
	var keys := _path_to_keys(key_or_path)
	
	var current_level: Variant = _options
	for key: String in keys:
		if current_level is Dictionary and current_level.has(key):
			current_level = current_level[key]
			continue
		if _fallback != null:
			return _fallback.get_option(key_or_path)
		push_warning("Attempted to access option at path %s in GameOptions, but this did not exist in GameOptions or any fallback. Returning default of null." % key_or_path)
		return null
	
	return current_level


## Sets the option at the given key to the given value. The value needs to be
## serializable to json.
##
## Options can be set nested multiple dictionaries deep by using a path formed
## of forward-slash-separated keys such as [code]"path/to/option"[/code]. Nested
## dictionaries will be created if they don't exist. Note that this may
## overwrite existing options with a dictionary.
func set_option(key_or_path: String, value: Variant) -> void:
	var keys := _path_to_keys(key_or_path)
	var except_last = func (arr: Array) -> Array: return arr.slice(0, -1)
	
	var current_level: Dictionary = _options
	var current_path := ""
	for key: String in except_last.call(keys):
		current_path += key
		
		if not current_level.has(key):
			current_level[key] = {}
		
		if current_level[key] is not Dictionary:
			push_warning("Found existing option at %s while trying to set option at %s. Overwriting." % [current_path, key_or_path])
			current_level[key] = {}
		
		current_level = current_level[key]
		current_path += "/"
	
	current_level[keys.back()] = value


## Sets the fallback to the given [GameOptions]. This will be used to retrieve
## options if [method get_option] can't find it on the current [GameOptions].
func set_fallback(fallback: GameOptions) -> void:
	_fallback = fallback


## Serializes this [GameOptions] to a JSON-compatible [Dictionary]. Note: this
## does not serialize the fallback.
func serialize() -> Dictionary:
	return _options


## Creates a [GameOptions] from a [Dictionary].
static func deserialize(from: Dictionary) -> GameOptions:
	assert(from.keys().all(func(key: Variant): key is String), "Deserializing GameOptions: not all keys at the top level were string keys.")
	
	return GameOptions.new(from)


func _path_to_keys(path: String) -> Array[String]:
	var temp: Array[String]
	temp.assign(path.split("/")) # Workaround to convert PackedStringArray to a typed Array
	return temp

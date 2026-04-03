class_name GameOptions
extends Resource
## User-configured options for the game
##
## Encapsulates a [Dictionary] of user-configured options, with associated
## utility methods for reading and changing these options. The dictionary
## is a dictionary of values and, possibly, nested dictionaries.
# TODO: has_option and has_option_by_keys methods
# TODO: unset_option and unset_options_by_keys methods

var _options: Dictionary
var _fallback: GameOptions = null


# Override
func _init(dictionary: Dictionary = {}):
	_options = dictionary


## Returns the option at the given key. Tries to retrieve the option from the
## fallback set by [method set_fallback] if it hasn't been set; otherwise
## returns null.
##
## Options nested multiple dictionaries deep can be retrieved using a path
## formed of forward-slash-separated keys such as [code]"path/to/option"[/code].
func get_option(key_or_path: String) -> Variant:
	var keys := path_to_keys(key_or_path)
	
	return get_option_by_keys(keys, key_or_path)


## As [member get_option], but provide the path as an array of keys. This is
## useful if you have a non-string key somewhere down the hierarchy.
func get_option_by_keys(keys: Array, log_name := "") -> Variant:
	log_name = log_name if not log_name.is_empty() else var_to_str(keys)
	
	var current_level: Variant = _options
	for key in keys:
		if current_level is Dictionary and current_level.has(key):
			current_level = current_level[key]
			continue
		if _fallback != null:
			return _fallback.get_option_by_keys(keys, log_name)
		push_warning("Attempted to access option at path %s in GameOptions, but this did not exist in GameOptions or any fallback. Returning default of null." % log_name)
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
	var keys := path_to_keys(key_or_path)
	set_option_by_keys(keys, value, key_or_path)

## As [member set_option], but provide the path as an array of keys. This is
## useful if you have a non-string type somewhere down the hierarchy. Otherwise,
## it is recommended to just use the set_option function as it has an easier
## contract.
func set_option_by_keys(keys: Array, value: Variant, log_name := "") -> void:
	log_name = log_name if not log_name.is_empty() else var_to_str(keys)
	
	var except_last = func (arr: Array) -> Array: return arr.slice(0, -1)
	
	var current_level: Dictionary = _options
	var current_path := ""
	for key in except_last.call(keys):
		current_path += str(key)
		
		if not current_level.has(key):
			current_level[key] = {}
		
		if current_level[key] is not Dictionary:
			push_warning("Found existing option at %s while trying to set option at %s. Overwriting." % [current_path, log_name])
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
	return GameOptions.new(from)


## Converts a path in the [code]"path/to/option"[/code] format to an array
## of strings.
static func path_to_keys(path: String) -> Array[String]:
	var temp: Array[String]
	temp.assign(path.split("/")) # Workaround to convert PackedStringArray to a typed Array
	return temp

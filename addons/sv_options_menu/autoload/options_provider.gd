extends Node
## Provides options
##
## Provides the player-configured [GameOptions]. Unless set by the user directly
## on the options, cloud options always falls back on local options, and local
## options always falls back on default options.

var _default_options: GameOptions = GameOptions.new()
var _local_options: GameOptions = GameOptions.new()
var _cloud_options: GameOptions = GameOptions.new()


# Override
func _ready():
	_local_options.set_fallback(_default_options)
	_cloud_options.set_fallback(_local_options)


## Sets the default [GameOptions]. Calling this method causes the other options
## configured by this class to fall back on this one.
func set_default_options(options: GameOptions) -> void:
	_local_options.set_fallback(options)
	_default_options = options


## Gets a deep duplicate of the default [GameOptions]. This is a duplicate
## because the default options should not be changed at runtime.
func get_default_options(options: GameOptions) -> void:
	return _default_options.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)


## Sets the local [GameOptions]. All further calls to [method get_local_options]
## will return this options object. Using this method will also update the
## fallback to the default options, and the fallback of the cloud options to
## the given options.
func set_local_options(options: GameOptions) -> void:
	options.set_fallback(_default_options)
	_cloud_options.set_fallback(options)
	
	_local_options = options


## Returns the local [GameOptions]. This either returns the options set using
## [method set_local_options], or a default GameOptions if nothing has been set.
func get_local_options() -> GameOptions:
	return _local_options


## This sets the cloud options to the given [GameOptions]. The cloud options
## should be the object that contains options safe for cloud synchronization.
## Using this method will set the fallback of the options to local options.
func set_cloud_options(options: GameOptions) -> void:
	options.set_fallback(_local_options)
	_cloud_options = options


## Returns the cloud options, which is the [GameOptions] object that contains
## options that are safe for cloud synchronization.
func get_cloud_options() -> GameOptions:
	return _cloud_options

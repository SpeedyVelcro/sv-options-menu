class_name OptionsConfig
extends Resource
## Configuration for SV Options Menu
##
## When a .tres of OptionsConfig is placed in the root of the project, its
## exported variables will be used to configure the functionality of SV
## Options Menu
# TODO: It's actually possible for plugins to add this kind of stuff to project settings.
# This setup works for now, but in the long run it's probably preferable to do that (will need a major version bump ofc).

## How to set the default resolution on startup. Used for [member default_resolution_handling]
enum DefaultResolutionHandling {
	## Use the default resolution set in [member default_resolution]
	STATIC,
	## Set the default resolution based on current display size. Clamp each
	## dimension according to [member maximum_auto_resolution], with no regard
	## for aspect ratio (unless set in [member force_aspect_ratio], in which
	## case the behaviour is the same as AUTO_DISPLAY_ASPECT_RATIO).
	AUTO_DISPLAY_CLAMPED,
	## Set the default resolution based on current display size. If the current
	## display is larger than [member maximum_auto_resolution], then the default
	## resolution will be the largest possible resolution that respects that
	## maximum but still adheres to the display's aspect ratio (or the aspect
	## ratio in [member force_aspect_ratio] if set)
	AUTO_DISPLAY_ASPECT_RATIO
}

## Player-configured options will be saved to and loaded from the json file at
## this file path. If the file and/or directory structure doesn't exist at
## runtime, they will be created.
##
## Example of a valid value: [code]user://profile/options.json[/code]
@export var local_options_file_path: String = "user://user-settings.json"

## Player-configured options that are marked safe for cloud synchronization will
## be saved and loaded here instead of [member local_options_file_path].
@export var cloud_options_file_path: String = "user://user-settings-cloud.json"

## Default options for use as a fallback that aren't configured elsewhere on
## this class. If this is null, then no custom default options will be used
## (only default options configured elsewhere on this class will be used).
@export var custom_default_options: GameOptions

@export_group("Display")
## Master setting for whether SV Options Menu manages resolution. See the other
## "managed" variables for what exactly the configured resolution affects
@export var manage_resolution: bool

@export var resolution_option_path: String = "display/resolution"

## Resolution settings are used to change the viewport when in windowed mode.
## Only has an effect if [member manage_resolution] is [code]true[/code].
@export var manage_windowed_viewport: bool

## Resolution settings are used to change the viewport when in fullscreen mode.
## Only has an effect if [member manage_resolution] is [code]true[/code].
@export var manage_fullscreen_viewport: bool

## Resolution settings are used to change the window size when in windowed mode.
## Only has an effect if [member manage_resolution] is [code]true[/code].
@export var manage_window_size: bool

## Determines whether SV Options Menu manages window mode of the primary
## game window. The default value will be the one set in project settings.
@export var manage_window_mode: bool

## Path to store window mode in [GameOptions]. Used if [member manage_window_mode]
## is [code]true[/code].
@export var window_mode_option_path: String = "display/window_mode"

## Determines how SV Options Menu determines default resolution on startup.
@export var default_resolution_handling: DefaultResolutionHandling = DefaultResolutionHandling.STATIC

## Default resolution to use if [member default_resolution_handling] is not set
## to auto-configure default resolution. If this is set to (0, 0), the viewport
## size in project settings will be used.
@export var default_resolution: Vector2i = Vector2i(0, 0)

## If this is set to anything other than (0, 0), the aspect ratio will be forced
## to this ratio when determining default resolution.
@export var force_aspect_ratio: Vector2i = Vector2i(0, 0)

## Maximum resolution to be allowed when auto-configuring default resolution.
## If this is set to (0, 0), then there is no maximum.
@export var maximum_auto_resolution: Vector2i = Vector2i(0, 0)

@export_group("Audio")
## Use SV Options Menu to configure volume settings - including muting - for
## audio buses configured in [member editable_buses]
@export var manage_volume: bool = false

## Path to store volume settings in the [GameOptions]. Used if
## [member manage_volume] is set to [code]true[/code].
@export var volume_option_path: String = "audio/volume"

## True if volume settings should be synced to cloud instead of stored locally.
## Only has effect if [member manage_volume] is set to [code]true[/code]. It is
## not recommended to set this, as players are unlikely to want to use the same
## volume settings across different devices.
@export var volume_cloud_sync: bool = false

## Use SV Options Menu to configure the output device used by [AudioServer].
@export var manage_output_device: bool = false

## Path to store output device setting in [GameOptions]. Used if
## [member manage_output_device] is set to [code]true[/code].
@export var output_device_option_path: String = "audio/output_device"

## True if output device setting should be synced to cloud instead of stored
## locally. Only has an effect if [member manage_output_device] is set to
## [code]true[/code]. It is not recommended to set this, as output device
## settings are only really meaningful locally.
@export var output_device_cloud_sync: bool = false

## Use SV Options Menu to configure the input device used by [AudioServer].
@export var manage_input_device: bool = false

## Path to store input device setting in [GameOptions]. Used if
## [member manage_input_device] is set to [code]true[/code].
@export var input_device_option_path: String = "audio/input_device"

## True if input device setting should be synced to cloud instead of stored
## locally. Only has an effect if [member manage_input_device] is set to
## [code]true[/code]. It is not recommended to set this, as output device
## settings are only really meaningful locally.
@export var input_device_cloud_sync: bool = false

## Array of player-editable audio bus configurations. Determines which audio
## buses are editable/managed by SV Options Loader and properties about
## editing them e.g. defaults.
##
## Only has an effect if [member manage_volume] is [code]true[/code].
@export var editable_buses: Array[EditableBusConfig] = [
	EditableBusConfig.new(AudioBusId.new(0), "Master")
]

@export_group("Controls")
# TODO: There should probably be an enable_input_map_cloud_backup variable, then
# you can set input map locally and back it up or restore it with a button. 
# TODO: There should be an option to store input_map as a separate file, as
# it is common to share hotkeys (especially for RTS games).

## Use SV Options Menu to configure input maps
@export var manage_input_map: bool = false

## Path to store input map settings in [GameOptions]. Used if
## [member manage_input_map] is set to [code]true[/code].
@export var input_map_option_path: String = "controls/bindings"

## True if input map should be synced to cloud instead of stored locally. Only
## has an effect if [member manage_input_map] is set to [code]true[/code].
@export var input_map_cloud_sync: bool = false

## Array of user-editable actions. Any action in this array will be configured
## by SV Options Menu.
##
## Only has an effect if [member manage_input_map] is [code]true[/code].
@export var editable_input_actions: Array[String]

## Dictionary of actions and input events to "lock" i.e. override the
## [member editable_input_actions] setting to prevent editing. This allows you
## to prevent unbinding of certain important [InputEvent]s to an action, while
## still allowing users to add extra bindings.
##
## The key is the action name, as defined in [InputMap] and
## [member editable_input_actions], and the value is an [InputEventLocks]
## containing all the [InputEvent]s you want to be un-editable for the given
## action.
@export var locked_input_events: Dictionary[String, InputEventLocks]


## Gets the default options, which include all configured defaults among the
## properties of this object, as well as any bespoke defaults configured in
## [member custom_default_options].
##
## Both local and cloud options will appear on the returned object, as both
## local and cloud options are meant to use the same defaults as a fallback.
func get_default_options() -> GameOptions:
	var default_options: GameOptions = custom_default_options.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) if custom_default_options != null else GameOptions.new()
	
	if manage_volume:
		for bus: EditableBusConfig in editable_buses:
			default_options.set_option_by_keys(get_audio_bus_volume_path(bus.reference), bus.default_volume_linear)
			default_options.set_option_by_keys(get_audio_bus_mute_path(bus.reference), bus.default_mute)
	
	if manage_output_device:
		default_options.set_option(output_device_option_path, "Default") # See AudioServer.output_device
	
	if manage_input_device:
		default_options.set_option(input_device_option_path, "Default") # See AudioServer.input_device
	
	return default_options


## Gets the options path as an [Array] to the volume setting for a particular
## audio bus. This is an array, [i]not[/i] a string, because the audio bus
## reference may be an integer if it's by id.
func get_audio_bus_volume_path(ref: AudioBusReference) -> Array:
	return _audio_bus_to_volume_base_path(ref) + ["level"]

## Gets the options path as an [Array] to the mute setting for a particular
## audio bus. This is an array, [i]not[/i] a string, because the audio bus
## reference may be an integer if it's by id.
func get_audio_bus_mute_path(ref: AudioBusReference) -> Array:
	return _audio_bus_to_volume_base_path(ref) + ["mute"]


func _audio_bus_to_volume_base_path(ref: AudioBusReference) -> Array:
	var bus_key = ref.to_variant()
	return GameOptions.path_to_keys(volume_option_path) + [bus_key]

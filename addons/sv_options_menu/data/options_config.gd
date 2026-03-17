class_name OptionsConfig
extends Resource
## Configuration for SV Options Menu
##
## When a .tres of OptionsConfig is placed in the root of the project, its
## exported variables will be used to configure the functionality of SV
## Options Menu

## Valid settings for [member manage_resolution], specifying in which modes
## SV Options Menu manages resolutions
enum ManageResolutionMode {
	## Do not manage resolutions
	NONE,
	## Manage resolutions in windowed mode only
	WINDOWED,
	## Manage resolutions in both fullscreen and windowed mode
	FULLSCREEN_AND_WINDOWED
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

## Default options. This will be used as a fallback for any options that aren't
## set by the player, or it will be used instead if the options file at
## [member options_file_path] isn't found. If this is null, an empty default
## options will be used.
@export var default_options: GameOptions

@export_group("Video")
## Use SV Options Menu to manage resolutions in the given modes
@export var manage_resolution: ManageResolutionMode = ManageResolutionMode.NONE

@export_group("Audio")
## Use SV Options Menu to configure volume settings - including muting - for
## audio buses configured in [member editable_buses]
@export var manage_volume: bool = false

## Use SV Options Menu to configure the output device used by [AudioServer].
@export var manage_output_device: bool = false

## Use SV Options Menu to configure the input device used by [AudioServer].
@export var manage_input_device: bool = false

## Dictionary of user-editable audio buses. The key is the user-readable name
## of the bus to be shown to the user, and the value is the reference to the
## bus. See [AudioServer] for information on buses.
##
## Has no effect if [member manage_volume] is false.
@export var editable_buses: Dictionary[String, AudioBusReference] = {
	"Master": AudioBusId.new(0)
}

@export_group("Controls")
## Use SV Options Menu to configure input maps
@export var manage_input_map: bool = false

## Array of user-editable actions. Any action in this array will be configured
## by SV Options Menu.
##
## Has no effect if [member use_volume_settings] is false.
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

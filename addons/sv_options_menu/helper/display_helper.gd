class_name OptionsDisplayHelper
extends Object
## Service for SV Options Menu management of display settings.
##
## Provides methods for changing resolution, fullscreen status etc.
# TODO: Rename to OptionsDisplayHelper


## Applies the resolution and window mode according to configuration in [OptionsConfig].
static func apply_window_settings(window_mode: DisplayServer.WindowMode, resolution: Vector2i, options_config: OptionsConfig) -> void:
	if options_config.manage_window_mode:
		_apply_window_mode(window_mode)
	
	if not options_config.manage_resolution:
		return
	
	var actual_window_mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	
	var affects_window_size := false
	var affects_content_size := false
	
	match actual_window_mode:
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED, DisplayServer.WindowMode.WINDOW_MODE_MINIMIZED, DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED:
			affects_window_size = options_config.resolution_affects_windowed_window_size
			affects_content_size = options_config.resolution_affects_windowed_content_size
		DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN, DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			affects_window_size = options_config.resolution_affects_fullscreen_window_size
			affects_content_size = options_config.resolution_affects_fullscreen_content_size
		_:
			push_error("Unknown window mode; not setting window size.")
	
	if affects_window_size:
		_get_window().size = resolution
		_get_window().move_to_center()
	if affects_content_size:
		_get_window().content_scale_size = resolution


## Infers the current resolution from the properties of the main window, by the
## properties that resolution is supposed to affect as determined by [OptionsConfig].
## If it is impossible to infer (e.g. because you forgot to set resolution to affect
## anything at all) then [property OptionsConfig.default_resolution] will be returned.
static func get_current_resolution(options_config: OptionsConfig) -> Vector2i:
	var res := _get_window().size
	
	var use_content_size := false
	var use_window_size := false
	
	match DisplayServer.window_get_mode():
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED, DisplayServer.WindowMode.WINDOW_MODE_MINIMIZED, DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED:
			use_window_size = options_config.resolution_affects_windowed_window_size
			use_content_size = options_config.resolution_affects_windowed_content_size
		DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN, DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			use_window_size = options_config.resolution_affects_fullscreen_window_size
			use_content_size = options_config.resolution_affects_fullscreen_content_size
	
	if use_window_size:
		return _get_window().size
	elif use_content_size:
		return _get_window().content_scale_size
	else:
		return options_config.calculate_default_resolution(DisplayServer.SCREEN_PRIMARY)


## Applies screen
static func apply_screen(screen: int) -> void:
	DisplayServer.window_set_current_screen(screen)


static func _get_window() -> Window:
	return (Engine.get_main_loop() as SceneTree).root.get_window()


static func _apply_window_mode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)

extends Node
## Autoloaded service to synchronize managed game options and engine singletons.
##
## This service enforces consistency engine singleton settings and their
## corresponding settings on [GameOptions] for all those options marked as
## "managed" in [OptionsConfig].


## Updates engine singletons to reflect options configured in [GameOptions] and
## managed by SV Options Loader according to [OptionsConfig]. This is usually
## something done by the options_startup.gd singleton after loading options.
func apply() -> void:
	var config = OptionsConfigProvider.get_config()
	var local_options = OptionsProvider.get_local_options()
	var cloud_options = OptionsProvider.get_cloud_options()
	
	var options_with_volume = cloud_options if config.volume_cloud_sync else local_options
	var options_with_output_device = cloud_options if config.output_device_cloud_sync else local_options
	var options_with_input_device = cloud_options if config.input_device_cloud_sync else local_options
	
	if config.manage_volume:
		var volume_settings = options_with_volume.get_option(config.volume_option_path)
		if volume_settings is Dictionary:
			_apply_volume_settings(volume_settings)
		else:
			push_error("Volume settings configured in options were missing or not a dictionary. Volume settings will not be applied.")
	
	if config.manage_output_device:
		var output_device = options_with_output_device.get_option(config.output_device_option_path)
		if output_device is String and AudioServer.get_output_device_list().has(output_device):
			AudioServer.output_device = output_device
		else:
			push_error("Output device configured in options was missing or not a string or not a valid output device. Output device setting will not be applied.")
	
	if config.manage_input_device:
		var input_device = options_with_input_device.get_option(config.input_device_option_path)
		if input_device is String and AudioServer.get_input_device_list().has(input_device):
			AudioServer.input_device = input_device
		else:
			push_error("Input device configured in options was missing or not a string or not a valid output device. Input device setting will not be applied.")


func _apply_volume_settings(volume_settings: Dictionary) -> void:
	for bus_key in volume_settings.keys():
		var bus_ref: AudioBusReference
		if bus_key is int:
			bus_ref = AudioBusId.new(bus_key)
		elif bus_key is String:
			bus_ref = AudioBusName.new(bus_key)
		else:
			push_error("Volume settings contained an audio bus that wasn't an int or string. Skipping.")
			continue
		
		var bus_settings = volume_settings[bus_key]
		if bus_settings is not Dictionary:
			push_error("Settings for volume bus %s was not a dictionary. Skipping." % bus_key)
			continue
		
		# TODO: Error handling for buses that don't exist. As it stands, I can't see any way in
		# AudioServer of testing that a bus exists.
		
		if bus_settings.has("level") and bus_settings["level"] is float:
			AudioServer.set_bus_volume_linear(bus_ref.get_id(), bus_settings["level"])
		else:
			push_error("Audio bus %s volume level setting was missing or wrong type. Volume level will not be applied for this bus." % bus_key)
		
		if bus_settings.has("mute") and bus_settings["mute"] is float:
			AudioServer.set_bus_mute(bus_ref.get_id(), bus_settings["mute"])
		else:
			push_error("Audio bus %s mute setting was missing or wrong type. Mute will not be applied for this bus." % bus_key)

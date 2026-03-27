class_name TestOptionsConfig
extends GdUnitTestSuite

func test_default_options_empty_when_no_managed_options():
	# Arrange
	var target := OptionsConfig.new()
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	# Top level
	assert_that(result.get_option("audio")).is_null()
	assert_that(result.get_option("controls")).is_null()
	
	# Individual options
	assert_that(result.get_option_by_keys(["audio", "volume", 0, "level"])).is_null()
	assert_that(result.get_option_by_keys(["audio", "volume", 0, "mute"])).is_null()
	assert_that(result.get_option("audio/volume/Master/level")).is_null() # Not actually the default bus but worth checking
	assert_that(result.get_option("audio/volume/Master/mute")).is_null()
	assert_that(result.get_option("audio/output_device")).is_null()
	assert_that(result.get_option("audio/input_device")).is_null()


func test_default_options_manage_volume():
	# arrange
	var target := OptionsConfig.new()
	target.manage_volume = true
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_float(result.get_option_by_keys(["audio", "volume", 0, "level"])).is_equal(1.0)
	assert_bool(result.get_option_by_keys(["audio", "volume", 0, "mute"])).is_false()


func test_default_options_with_custom_editable_buses():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_volume = true
	target.editable_buses = [
		EditableBusConfig.new(AudioBusName.new("foo"), "Some Name"),
		EditableBusConfig.new(AudioBusId.new(123), "Some Other Name")
	]
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_float(result.get_option("audio/volume/foo/level")).is_equal(1.0) # Not actually the default bus but worth checking
	assert_bool(result.get_option("audio/volume/foo/mute")).is_false()
	assert_float(result.get_option_by_keys(["audio", "volume", 123, "level"])).is_equal(1.0)
	assert_bool(result.get_option_by_keys(["audio", "volume", 123, "mute"])).is_false()


func test_default_options_with_custom_volume_path():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_volume = true
	target.volume_option_path = "foo/bar"
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_float(result.get_option_by_keys(["foo", "bar", 0, "level"])).is_equal(1.0)
	assert_bool(result.get_option_by_keys(["foo", "bar", 0, "mute"])).is_false()


func test_default_options_when_managed_output_device():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_output_device = true
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_str(result.get_option("audio/output_device")).is_equal("Default")


func test_default_options_with_custom_output_device_path():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_output_device = true
	target.output_device_option_path = "foo/bar"
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_str(result.get_option("foo/bar")).is_equal("Default")


func test_default_options_when_managed_input_device():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_input_device = true
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_str(result.get_option("audio/input_device")).is_equal("Default")


func test_default_options_with_custom_input_device_path():
	# Arrange
	var target := OptionsConfig.new()
	target.manage_input_device = true
	target.input_device_option_path = "foo/bar"
	
	# Act
	var result := target.get_default_options()
	
	# Assert
	assert_str(result.get_option("foo/bar")).is_equal("Default")

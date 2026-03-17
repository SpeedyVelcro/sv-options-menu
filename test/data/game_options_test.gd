class_name TestGameOptions
extends GdUnitTestSuite


func test_get_options(
	path: String,
	expected_value: Variant,
	_test_parameters := [
		["", "blank_value", false],
		["foo", "foo_value", false],
		["bar", "bar_value", false],
		["null", null],
		["dict/", "nested_blank_value"], # Slash on end means get a blank key, not the entire dictionary
		["dict/foo", "nested_foo_value"],
		["dict/bar", "nested_bar_value"],
		["dict/dict", {"deep": "deep_value"}], # Test that getting a dict directly works,
		["dict/dict/deep", "deep_value"],
		["missing", null],
		["dict/missing", null],
		["missing/missing", null],
		["blank_nest///", "success"]
	]
):
	# Arrange
	var target = _create_test_options()
	
	# Act
	var result = target.get_option(path)
	
	# Assert
	assert_that(result).is_equal(expected_value)


func test_set_options(
	path: String,
	value: Variant,
	_test_parameters := [
		["", "overwrite_blank"],
		["foo", "overwrite_foo"],
		["baz", "new_value"],
		["foo", null],
		["dict", "overwrite_dict"],
		["dict", null],
		["foo", {"new": "dict"}],
		["dict", {"replace": "dict"}],
		["foobar", "new_value_again"],
		["dict/baz", "new_value_deep"],
		["dict/foo", "overwrite_deep"],
		["dict/dict/baz", "new_deeper_value"],
		["dict/dict/deep", "overwrite_deep"],
		["new_dict/foo", "new_nesting"],
		["new_dict/dict/foo", "new_deeper_nesting"],
		["dict/new_dict/foo", "partially_new_nesting"],
		["blank_nest///", "overwrite_blank_nest"],
		["new_dict/////", "new_blank_nesting"]
	]
):
	# Arrange
	var target = _create_test_options()
	
	# Act
	target.set_option(path, value)
	
	# Assert
	var result = target.get_option(path)
	assert_that(result).is_equal(value)


func _create_test_options() -> GameOptions:
	return GameOptions.new({
		"": "blank_value",
		"foo": "foo_value",
		"bar": "bar_value",
		"null": null,
		"dict": {
			"": "nested_blank_value",
			"foo": "nested_foo_value",
			"bar": "nested_bar_value",
			"dict": {
				"deep": "deep_value"
			}
		},
		"blank_nest": {"": {"": {"": "success"}}}
	})

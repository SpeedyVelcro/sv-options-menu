class_name TestResolutionList
extends GdUnitTestSuite


func test_get_resolutions_returns_in_order(
	resolutions: Array[Vector2i],
	expected: Array[Vector2i],
	_test_parameters := [
		# Trivial case
		[
			[],
			[]
		],
		# Singleton case
		[
			[res(1280, 720)],
			[res(1280, 720)]
		],
		# Already ordered
		[
			[res(640, 480), res(1280, 720), res(1920, 1080)],
			[res(640, 480), res(1280, 720), res(1920, 1080)]
		],
		# Reversed order
		[
			[res(1920, 1080), res(1280, 720), res(640, 480)],
			[res(640, 480), res(1280, 720), res(1920, 1080)]
		],
		# Mixed order
		[
			[res(640, 480), res(2560, 1440), res(1920, 1080), res(800, 600), res(1280, 720)],
			[res(640, 480), res(800, 600), res(1280, 720), res(1920, 1080), res(2560, 1440)]
		],
		# Same x
		[
			[res(1280, 800), res(1280, 720), res(1280, 1024), res(1280, 960)],
			[res(1280, 720), res(1280, 800), res(1280, 960), res(1280, 1024)]
		],
		# Same y
		[
			[res(1440, 900), res(1152, 900), res(1600, 900), res(1280, 900)],
			[res(1152, 900), res(1280, 900), res(1440, 900), res(1600, 900)]
		],
		# Sort by x, then y
		[
			[res(1280, 720), res(1440, 900), res(1280, 1024), res(1440, 1080)],
			[res(1280, 720), res(1280, 1024), res(1440, 900), res(1440, 1080)]
		],
		# Remove duplicates
		[
			[res(1920, 1080), res(1280, 720), res(1920, 1080), res(1600, 900), res(1280, 720), res(1600, 900)],
			[res(1280, 720), res(1600, 900), res(1920, 1080)]
		]
]):
	# Arrange
	var target := ResolutionList.new(resolutions)
	
	# Act
	var result := target.get_resolutions()
	
	# Assert
	assert_array(result).is_equal(expected)


func test_combine_with_combines_two_lists(
	target_resolutions: Array[Vector2i],
	other_resolutions: Array[Vector2i],
	expected_resolutions: Array[Vector2i],
	_test_parameters := [
	# Trivial case
	[
		[],
		[],
		[]
	],
	# Individual resolutions
	[
		[res(1280, 720)],
		[],
		[res(1280, 720)]
	],
	[
		[],
		[res(1920, 1080)],
		[res(1920, 1080)]
	],
	# Combines in correct order
	[
		[res(640, 480)],
		[res(1280, 720)],
		[res(640, 480), res(1280, 720)]
	],
	[
		[res(1280, 720)],
		[res(640, 480)],
		[res(640, 480), res(1280, 720)]
	],
	# Interleaves successfully
	[
		[res(640, 300), res(800, 600), res(1920, 1080)],
		[res(640, 480), res(1280, 720), res(2560, 1440)],
		[res(640, 300), res(640, 480), res(800, 600), res(1280, 720), res(1920, 1080), res(2560, 1440)]
	],
	# Doesn't interleave if the order is already correct
	[
		[res(640, 300), res(640, 480), res(800, 600)],
		[res(1280, 720), res(1920, 1080), res(2560, 1440)],
		[res(640, 300), res(640, 480), res(800, 600), res(1280, 720), res(1920, 1080), res(2560, 1440)]
	],
	# Doesn't include duplicates in same list
	[
		[res(800, 600), res(800, 600)],
		[res(1280, 720), res(1280, 720)],
		[res(800, 600), res(1280, 720)]
	],
	# Doesn't include duplicates across lists
	[
		[res(800, 600), res(1280, 720)],
		[res(800, 600), res(1280, 720)],
		[res(800, 600), res(1280, 720)]
	]
]):
	# Arrange
	var target := ResolutionList.new(target_resolutions)
	var other := ResolutionList.new(other_resolutions)
	
	# Act
	var result = target.combine_with(other)
	
	# Assert
	assert_array(result.get_resolutions()).is_equal(expected_resolutions)


func test_combine_combines_several_lists():
	# Arrange
	var lists: Array[ResolutionList] = [
		ResolutionList.new([res(640, 300), res(1920, 1080)]),
		ResolutionList.new([res(1360, 768), res(640, 480)]),
		ResolutionList.new([res(1280, 720), res(2560, 1440), res(800, 600)])
	]
	
	# Act
	var result = ResolutionList.combine(lists)
	
	# Assert
	assert_array(result.get_resolutions()).is_equal([res(640, 300), res(640, 480), res(800, 600), res(1280, 720), res(1360, 768), res(1920, 1080), res(2560, 1440)])

## Helper function simply to make writing out resolution vectors in the test
## parameters less verbose. Instead of [code]Vector2i(1280, 720)[/code], use
## [code]res(1280, 720)[/code]
func res(x: int, y: int) -> Vector2i:
	return Vector2i(x, y)

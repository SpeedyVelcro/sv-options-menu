extends OptionOptionButton

var sprites: Array[Texture2D] = [
	preload("res://example/entity/player/player_pink.png"),
	preload("res://example/entity/player/player_blue.png"),
	preload("res://example/entity/player/player_green.png")
]

var labels: Array[String] = [
	"Pink",
	"Blue",
	"Green"
]


# Override
func _pre_populate() -> void:
	for i in range(sprites.size()):
		add_icon_item(sprites[i], labels[i], i)
		set_item_metadata(i, ResourceUID.path_to_uid(sprites[i].resource_path))

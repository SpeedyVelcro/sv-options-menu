extends CharacterBody2D
## Player-controlled character
##
## This example shows how to access options using the OptionAccessor node. This
## is heavier, as it requires a node, but it is very robust to option changes.

@export_group("Internal")
@export var _sprite_2d: Sprite2D
@export var _sprite_option_accessor: OptionAccessor

var gravity: int = 800
var move_speed: int = 200
var jump_speed: int = 400


# Override
func _ready() -> void:
	_update_sprite_untyped(_sprite_option_accessor.get_value())


# Override
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = 0
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	
	if Input.is_action_pressed("jump") and is_on_floor_only():
		velocity.y = -jump_speed
	
	move_and_slide()


func _update_sprite_untyped(path: Variant) -> void:
	if path is not String:
		push_error("Cannot load player sprite as path is not a string.")
		return
	
	_update_sprite(path)


func _update_sprite(path: String) -> void:
	var texture := load(path)
	
	if texture is not Texture2D:
		push_error("Failed to load player sprite.")
	
	_sprite_2d.texture = texture


# Signal connection
func _on_sprite_option_accessor_option_modified(new_value: Variant) -> void:
	_update_sprite_untyped(new_value)

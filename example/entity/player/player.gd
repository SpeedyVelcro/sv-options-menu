extends CharacterBody2D
## Player-controlled character
##
## Script for the player scene, which is the player-controlled character.

var gravity: int = 800
var move_speed: int = 200
var jump_speed: int = 400


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

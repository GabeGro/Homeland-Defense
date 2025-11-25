extends CharacterBody2D

@export var step: Vector2 = Vector2(32, 32)   # how far each tap moves the target
@export var move_speed: float = 500.0         # how fast we glide toward the target

var target_position: Vector2


func _ready() -> void:
	# Start with target equal to current position
	target_position = global_position


func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO

	# You can tap quickly; each tap nudges the target a bit
	if Input.is_action_just_pressed("ui_up"):
		dir.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		dir.y = 1
	elif Input.is_action_just_pressed("ui_left"):
		dir.x = -1
	elif Input.is_action_just_pressed("ui_right"):
		dir.x = 1

	if dir != Vector2.ZERO:
		# Move the *target* in smaller portions
		target_position += dir * step

	# Smoothly glide toward the target every frame
	global_position = global_position.move_toward(target_position, move_speed * delta)


func reset_movement() -> void:
	# Called when we respawn so we don't glide toward an old target
	target_position = global_position

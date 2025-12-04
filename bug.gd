extends CharacterBody2D

@export var move_speed: float = 300.0   # speed of movement (hold to move)
@export var friction: float = 8.0       # smooth slowdown when you stop

var velocity_vector: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO

	# HOLD movement instead of tap movement
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	# Normalize diagonal movement
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	# Smooth acceleration / deceleration
	velocity_vector = velocity_vector.move_toward(input_vector * move_speed, friction * move_speed * delta)

	# Apply movement
	global_position += velocity_vector * delta


func reset_movement() -> void:
	# Reset movement cleanly when colliding / resetting
	velocity_vector = Vector2.ZERO

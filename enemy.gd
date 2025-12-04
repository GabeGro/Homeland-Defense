extends Area2D

@export var speed: float = 200.0
@export var direction: Vector2 = Vector2.LEFT
@export var left_limit: float = -100.0
@export var right_limit: float = 1300.0  # slightly beyond your right edge

func _process(delta: float) -> void:
	global_position += direction * speed * delta

	# Wrap when off-screen so enemies keep looping
	if direction.x < 0.0 and global_position.x < left_limit:
		global_position.x = right_limit
	elif direction.x > 0.0 and global_position.x > right_limit:
		global_position.x = left_limit

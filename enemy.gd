extends Area2D

@export var speed: float = 200.0
@export var direction: Vector2 = Vector2.LEFT
@export var left_limit: float = -100.0
@export var right_limit: float = 1300.0

# Extra spice
@export var can_wobble: bool = true
@export var wobble_amplitude: float = 12.0      # how tall the bobbing is
@export var wobble_frequency: float = 2.0       # how fast it bobs

var _base_y: float = NAN        # original lane Y (set lazily)
var _time_accum: float = 0.0    # personal time offset per enemy


func _ready() -> void:
	# Just randomize phase; DON'T lock Y here
	_time_accum = randf() * TAU


func _physics_process(delta: float) -> void:
	_time_accum += delta

	# Horizontal movement
	position += direction * speed * delta

	# Initialize base_y AFTER main has set final position
	if is_nan(_base_y):
		_base_y = position.y

	# Vertical wobble
	if can_wobble and wobble_amplitude > 0.0:
		position.y = _base_y + sin(_time_accum * wobble_frequency) * wobble_amplitude

	# Wrap when off-screen so enemies keep looping
	if direction.x < 0.0 and position.x < left_limit:
		position.x = right_limit
	elif direction.x > 0.0 and position.x > right_limit:
		position.x = left_limit

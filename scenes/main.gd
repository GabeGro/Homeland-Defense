extends Node2D

@onready var EnemyScene: PackedScene = preload("res://scenes/enemy.tscn")  # adjust if your path is different
@onready var Bug: CharacterBody2D = $Bug
@onready var GoalArea: Area2D = $GoalArea
@onready var FirewallBar: TextureRect = $FirewallBar
@onready var GoalHoleVisual: TextureRect = $FirewallBar/GoalHole
@onready var Barrier1Hole: ColorRect = $Barrier1/Bar1Hole
@onready var Barrier2Hole: ColorRect = $Barrier2/Bar2Hole
@onready var Barrier3Hole: ColorRect = $Barrier3/Bar3Hole

@export var lanes: int = 4
@export var enemies_per_lane: int = 3

# Vertical layout tuning
@export var top_lane_offset: float = 80.0     # distance below GoalArea
@export var bottom_lane_offset: float = 80.0  # distance above Bug start

# Anchor enemies placed in the scene
@onready var Enemy1: Area2D = $Enemy
@onready var Enemy2: Area2D = $Enemy2
@onready var Enemy3: Area2D = $Enemy3

# Horizontal layout tuning for extra enemies
@export var first_enemy_x: float = 200.0
@export var enemy_spacing_x: float = 250.0

var BUG_START_POS: Vector2

# Moving hole parameters
var hole_speed: float = 200.0        # how fast the hole slides left/right
var hole_direction: int = 1          # 1 = right, -1 = left
var hole_min_x: float = 0.0          # local X min inside the bar
var hole_max_x: float = 0.0          # local X max inside the bar


func _ready() -> void:
	BUG_START_POS = Bug.global_position

	# Force anchor enemies to the exact positions you want (global coords from editor)
	Enemy1.global_position = Vector2(1142, 370)
	Enemy2.global_position = Vector2(1137, 130)
	Enemy3.global_position = Vector2(1138, 244)

	# Debug so you can see they’re correct
	print("Enemy1 at: ", Enemy1.global_position)
	print("Enemy2 at: ", Enemy2.global_position)
	print("Enemy3 at: ", Enemy3.global_position)

	setup_hole_bounds()
	spawn_enemy_lanes()

	$FirewallBar/FireSprite.play("Fire")
	$FirewallBar/FireSprite2.play("Fire")
	$FirewallBar/FireSprite3.play("Fire")
	$FirewallBar/FireSprite4.play("Fire")
	$FirewallBar/FireSprite5.play("Fire")
	$FirewallBar/FireSprite6.play("Fire")
	$FirewallBar/FireSprite7.play("Fire")
	$FirewallBar/FireSprite8.play("Fire")
	$FirewallBar/FireSprite9.play("Fire")
	$FirewallBar/FireSprite10.play("Fire")


func reset_bug() -> void:
	Bug.global_position = BUG_START_POS
	Bug.reset_movement()  # uses your new bug.gd helper
	print("Bug reset to start:", BUG_START_POS)


func _process(delta: float) -> void:
	move_hole(delta)


func _bug_is_inside_hole(hole_rect: Control) -> bool:
	var bug_x: float = Bug.global_position.x

	# For ColorRect / Control, global_position is TOP-LEFT
	var hole_left: float = hole_rect.global_position.x
	var hole_right: float = hole_left + hole_rect.size.x

	return bug_x >= hole_left and bug_x <= hole_right


func _handle_barrier_hit(body: Node2D, hole_rect: ColorRect) -> void:
	if body != Bug:
		return

	if _bug_is_inside_hole(hole_rect):
		print("Passed barrier safely")
	else:
		print("Hit solid barrier, reset.")
		reset_bug()


func _on_goal_area_body_entered(body: Node) -> void:
	if body != Bug:
		return

	if _bug_is_inside_hole(GoalHoleVisual):
		print("You squeezed through the hole! WIN")
		PopUp.ads_enabled = true
		get_tree().call_deferred(
			"change_scene_to_file",
			"res://scenes/WinScreen.tscn"
		)
	else:
		print("Hit solid firewall, reset.")
		reset_bug()


func _on_enemy_body_entered(body: Node2D) -> void:
	print("Enemy hit:", body.name)
	if body == Bug:
		print("Bug hit by enemy!")
		reset_bug()


func spawn_enemy_lanes() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# These three are the ones you placed in the scene
	var lane_markers: Array[Area2D] = [Enemy1, Enemy2, Enemy3]

	print("Found lane markers: ", lane_markers.size())

	for lane_index in range(lane_markers.size()):
		var marker := lane_markers[lane_index]

		var lane_y: float = marker.global_position.y
		var lane_direction: Vector2 = Vector2.LEFT if lane_index % 2 == 0 else Vector2.RIGHT

		# Use the existing marker as the first enemy in this lane
		var first_enemy: Area2D = marker
		first_enemy.direction = lane_direction

		var base_speed: float = 200.0 + float(lane_index) * 40.0
		var jitter: float = rng.randf_range(-40.0, 40.0)
		first_enemy.speed = max(80.0, base_speed + jitter)

		if rng.randf() < 0.2:
			first_enemy.speed *= 1.7
			_make_enemy_fast_visual(first_enemy)

		if not first_enemy.body_entered.is_connected(_on_enemy_body_entered):
			first_enemy.body_entered.connect(_on_enemy_body_entered)

		# Now spawn extra enemies in the same lane, spaced horizontally
		for i in range(1, enemies_per_lane):
			var enemy: Area2D = EnemyScene.instantiate()
			add_child(enemy)

			var start_x: float = marker.global_position.x + float(i) * enemy_spacing_x
			enemy.global_position = Vector2(start_x, lane_y)

			enemy.direction = lane_direction

			var e_base_speed: float = 200.0 + float(lane_index) * 40.0
			var e_jitter: float = rng.randf_range(-40.0, 40.0)
			enemy.speed = max(80.0, e_base_speed + e_jitter)

			if rng.randf() < 0.2:
				enemy.speed *= 1.7
				_make_enemy_fast_visual(enemy)

			enemy.body_entered.connect(_on_enemy_body_entered)


func _make_enemy_fast_visual(enemy: Area2D) -> void:
	# Optional: bigger and tinted to telegraph danger.
	enemy.scale = enemy.scale * 1.25

	# If your enemy scene has a Sprite2D, tint it red.
	# Adjust the path to match your enemy.tscn.
	if enemy.has_node("Sprite2D"):
		var sprite := enemy.get_node("Sprite2D") as Sprite2D
		sprite.modulate = Color(1.0, 0.4, 0.4)  # reddish


func setup_hole_bounds() -> void:
	# Work in local coordinates of FirewallBar
	var firewall_width: float = FirewallBar.size.x
	var hole_width: float = GoalHoleVisual.size.x

	hole_min_x = hole_width / 2.0
	hole_max_x = firewall_width - hole_width / 2.0

	# Start the hole in the middle
	GoalHoleVisual.position.x = (firewall_width - hole_width) / 2.0


func move_hole(delta: float) -> void:
	var pos: Vector2 = GoalHoleVisual.position
	pos.x += float(hole_direction) * hole_speed * delta

	if pos.x < hole_min_x:
		pos.x = hole_min_x
		hole_direction = 1
	elif pos.x > hole_max_x:
		pos.x = hole_max_x
		hole_direction = -1

	GoalHoleVisual.position = pos


func _on_barrier1_body_entered(body: Node2D) -> void:
	_handle_barrier_hit(body, Barrier1Hole)


func _on_barrier2_body_entered(body: Node2D) -> void:
	_handle_barrier_hit(body, Barrier2Hole)


func _on_barrier3_body_entered(body: Node2D) -> void:
	_handle_barrier_hit(body, Barrier3Hole)

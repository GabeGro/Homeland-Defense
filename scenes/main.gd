extends Node2D

@onready var EnemyScene: PackedScene = preload("res://scenes/enemy.tscn")  # adjust if your path is different
@onready var Bug: CharacterBody2D = $Bug
@onready var GoalArea: Area2D = $GoalArea
@onready var FirewallBar: ColorRect = $FirewallBar
@onready var GoalHoleVisual: ColorRect = $FirewallBar/GoalHole

var BUG_START_POS: Vector2

# Moving hole parameters
var hole_speed: float = 200.0        # how fast the hole slides left/right
var hole_direction: int = 1          # 1 = right, -1 = left
var hole_min_x: float = 0.0          # local X min inside the bar
var hole_max_x: float = 0.0          # local X max inside the bar


func _ready() -> void:
	BUG_START_POS = Bug.global_position
	setup_hole_bounds()
	spawn_enemy_lanes()


func reset_bug() -> void:
	Bug.global_position = BUG_START_POS
	Bug.reset_movement()  # uses your new bug.gd helper
	print("Bug reset to start:", BUG_START_POS)


func _process(delta: float) -> void:
	move_hole(delta)


func _on_goal_area_body_entered(body: Node) -> void:
	if body != Bug:
		return

	var bug_x: float = Bug.global_position.x

	var hole_center_x: float = GoalHoleVisual.global_position.x
	var hole_half_width: float = GoalHoleVisual.size.x / 2.0

	if abs(bug_x - hole_center_x) <= hole_half_width:
		print("You squeezed through the hole! WIN")
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
	var lanes: int = 4
	var enemies_per_lane: int = 3

	var top_y: float = GoalArea.global_position.y + 80.0
	var bottom_y: float = BUG_START_POS.y - 80.0

	for lane in range(lanes):
		var t: float = float(lane) / max(lanes - 1, 1)
		var lane_y: float = lerp(bottom_y, top_y, t)

		for i in range(enemies_per_lane):
			var enemy: Area2D = EnemyScene.instantiate()
			add_child(enemy)

			var start_x: float = 200.0 + float(i) * 250.0
			enemy.global_position = Vector2(start_x, lane_y)

			enemy.direction = Vector2.LEFT if lane % 2 == 0 else Vector2.RIGHT
			enemy.speed = 200.0 + float(lane) * 40.0

			enemy.body_entered.connect(_on_enemy_body_entered)


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

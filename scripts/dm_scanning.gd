extends Node2D

@export var dm1_scene: PackedScene
@export var dm2_scene: PackedScene
@export var dm3_scene: PackedScene
@export var dm4_scene: PackedScene
@export var dm5_scene: PackedScene

var current_dm: Node = null
var dm_index := 0        # 1..5 for the DMs
var correct := 0

func _ready() -> void:
	_show_next_dm()

func _show_next_dm() -> void:
	dm_index += 1

	# Finished all DMs, go to win/lose
	if dm_index > 5:
		if correct == 5:
			$WinScreen.visible = true
		else:
			get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")
		return

	# Remove previous DM
	if current_dm:
		current_dm.queue_free()
		current_dm = null

	# Pick which scene to show
	var scene_to_use: PackedScene = null
	match dm_index:
		1: scene_to_use = dm1_scene
		2: scene_to_use = dm2_scene
		3: scene_to_use = dm3_scene
		4: scene_to_use = dm4_scene
		5: scene_to_use = dm5_scene

	if scene_to_use == null:
		return

	current_dm = scene_to_use.instantiate()
	add_child(current_dm)

func _on_dm_yes() -> void:
	# Correct pattern: 1=no, 2=no, 3=yes, 4=no, 5=yes
	match dm_index:
		3, 5:
			correct += 1
		1, 2, 4:
			# these should have been "no", so don't increment
			pass

	_show_next_dm()

func _on_dm_no() -> void:
	# Correct pattern: 1=no, 2=no, 3=yes, 4=no, 5=yes
	match dm_index:
		1, 2, 4:
			correct += 1
		3, 5:
			# these should have been "yes", so don't increment
			pass

	_show_next_dm()

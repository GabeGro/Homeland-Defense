extends Node2D

@export var dm1_scene: PackedScene
@export var dm2_scene: PackedScene

var current_dm: Node = null
var dm_index := 0
var correct = 0

func _ready() -> void:
	_show_next_dm()

func _show_next_dm() -> void:
	dm_index += 1
	
	if dm_index > 2:
		if correct == 2:
			get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")
	
	if current_dm:
		current_dm.queue_free()
		current_dm = null

	var scene_to_use: PackedScene = null
	if dm_index == 1:
		scene_to_use = dm1_scene
	elif dm_index == 2:
		scene_to_use = dm2_scene
	else:
		return

	current_dm = scene_to_use.instantiate()
	add_child(current_dm)

func _on_dm_yes() -> void:
	# handle accept logic here
	_show_next_dm()

func _on_dm_no() -> void:
	correct += 1
	_show_next_dm()

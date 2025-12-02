extends Node2D

var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	$"Yes Button".pressed.connect(_on_dm_yes)
	$"No Button".pressed.connect(_on_dm_no)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Start drag if mouse is over this DM window
			if get_global_mouse_position().distance_to(global_position) < 1000: # optional hit test
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - drag_offset

func _on_dm_yes() -> void:
	print("DM accepted")
	get_parent().call("_on_dm_yes")

func _on_dm_no() -> void:
	print("DM denied")
	get_parent().call("_on_dm_no")

extends Control

@export var main_scene_path: String = "res://scenes/main.tscn"  # adjust if your main scene is elsewhere

func _ready() -> void:
	# You can also set focus on the button if you like:
	$Background/Button.grab_focus()


func _on_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", main_scene_path)

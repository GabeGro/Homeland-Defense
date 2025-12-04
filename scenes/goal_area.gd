extends Area2D

signal bug_reached_goal

func _on_body_entered(body: Node) -> void:
	if body.name == "Bug":
		emit_signal("bug_reached_goal")

extends Control
signal promptExitClicked
@export var password = "wumbo"
@onready var inputField = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inputField.grab_focus()

func passwordSubmitted(newText: String) -> void:
	if newText == password:
		print("Nice")
	else:
		print("poop")


func exitPressed() -> void:
	promptExitClicked.emit() # Replace with function body.

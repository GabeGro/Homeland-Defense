extends Sprite2D
signal gameExitClicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func exitPressed() -> void:
	gameExitClicked.emit() # Replace with function body.

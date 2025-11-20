extends Sprite2D
signal adDeleted
signal linkClicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func buttonPressed() -> void:
	adDeleted.emit()
	queue_free()

func linkPressed() -> void:
	linkClicked.emit()

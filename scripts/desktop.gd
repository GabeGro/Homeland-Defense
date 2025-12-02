extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SecretsFolder.exitClicked.connect(onExitClicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func secretsPressed() -> void:
	$SecretsFolder.visible = true

func onExitClicked():
	$SecretsFolder.visible = false

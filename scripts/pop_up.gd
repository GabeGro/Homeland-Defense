extends Node2D
const clankerAd = preload("res://scenes/ClankerAd.tscn")
var probability = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lucky = randf_range(0, 1000)
	if (lucky < probability):
		spawnAd()

func spawnAd() -> void:
	var newAd = clankerAd.instantiate()
	
	var viewport_size = get_viewport_rect().size
	var minX = 0
	var maxX = viewport_size.x
	var minY = 0
	var maxY = viewport_size.y
	
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	
	newAd.position = Vector2(randomX, randomY)
	add_child(newAd)

extends Node2D
const clankerAd = preload("res://scenes/ClankerAd.tscn")
var probability = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lucky = randf_range(0, 1000)
	if (lucky < probability):
		spawnAd()
	probability += 0.01

func spawnAd() -> void:
	var newAd = clankerAd.instantiate()
	
	var viewport_size = get_viewport_rect().size
	var minX = 200
	var maxX = viewport_size.x - 200
	var minY = 200
	var maxY = viewport_size.y - 200
	
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	
	newAd.position = Vector2(randomX, randomY)
	add_child(newAd)

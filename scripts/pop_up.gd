extends Node2D
const clankerAd = preload("res://scenes/ClankerAd.tscn")
var probability = 1
var adCount = 0
var malware = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (malware == true):
		$crashScreen.visible = true
	elif (adCount < 30):
		var lucky = randf_range(0, 1000)
		if (lucky < probability):
			spawnAd()
		probability += 0.01
	else:
		$crashScreen.visible = true


func spawnAd() -> void:
	#create new instance of ad
	var newAd = clankerAd.instantiate()
	
	#create restrictions for ad placement
	var viewport_size = get_viewport_rect().size
	var minX = 200
	var maxX = viewport_size.x - 200
	var minY = 200
	var maxY = viewport_size.y - 200
	
	#assign random location for ad
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	newAd.position = Vector2(randomX, randomY)
	
	add_child(newAd)
	newAd.adDeleted.connect(deleteAd)
	newAd.linkClicked.connect(linkClicked)
	adCount += 1
	
func deleteAd() -> void:
	adCount -= 1
	
func linkClicked() -> void:
	print("hello")
	malware = true

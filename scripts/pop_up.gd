extends Node2D
const adScenes = [
	preload("res://scenes/ClankerAd.tscn"),
	preload("res://scenes/BrainAd.tscn"),
	preload("res://scenes/ArtistAd.tscn"),
	preload("res://scenes/OceanAd.tscn"),
	preload("res://scenes/SelfDestructAd.tscn")
	]

var probability = 1
var adCount = 0
var malware = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("hello")
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (malware == true):
		$crashScreen.visible = true
	elif (adCount < 30):
		var lucky = randf_range(0, 1000)
		if (lucky < probability):
			spawnAd()
		probability += 0.001
	else:
		$crashScreen.visible = true


func spawnAd() -> void:
	#create new instance of ad
	# Pick a random ad scene from the array
	var adScene = adScenes[randi() % adScenes.size()]
	var newAd = adScene.instantiate()
	
	#create restrictions for ad placement
	var viewport_size = get_viewport_rect().size
	var minX = 200
	var maxX = viewport_size.x - 200
	var minY = 200
	var maxY = viewport_size.y - 200
	
	if adScene == preload("res://scenes/OceanAd.tscn") or adScene == preload("res://scenes/ArtistAd.tscn"):
		minY = 300
	
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

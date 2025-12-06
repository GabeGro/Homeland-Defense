extends Node2D

const adScenes = [
	preload("res://scenes/ClankerAd.tscn"),
	preload("res://scenes/BrainAd.tscn"),
	preload("res://scenes/ArtistAd.tscn"),
	preload("res://scenes/OceanAd.tscn"),
	preload("res://scenes/SelfDestructAd.tscn")
]

var adCount: int = 0
var total_ads_spawned: int = 0   # NEW — total ever spawned
var malware: bool = false
var ads_enabled: bool = false

# Timing vars
var time_since_start: float = 0.0
var time_since_last_ad: float = 0.0
var ad_pause_timer: float = 0.0   # NEW — pause between bursts

# Wave settings
const PHASE_1_DURATION := 15.0     # seconds until phase 2
const PHASE_1_INTERVAL := 3.0      # one ad every 3 seconds
const PHASE_2_INTERVAL := 1.0      # one ad every 1 second
const MAX_AD_COUNT := 30
const PAUSE_DURATION := 5.0        # NEW — 2 second break every burst


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if not ads_enabled:
		return

	if malware:
		$crashScreen.visible = true
		return

	# If too many ads total, crash screen
	if adCount >= MAX_AD_COUNT:
		$crashScreen.visible = true
		return

	time_since_start += delta
	time_since_last_ad += delta

	# Handle pause after every burst of 10 ads
	if ad_pause_timer > 0.0:
		ad_pause_timer -= delta
		return

	# Choose interval based on phase
	var current_interval: float = (
		PHASE_1_INTERVAL if time_since_start < PHASE_1_DURATION else PHASE_2_INTERVAL
	)

	# Time to spawn an ad?
	if time_since_last_ad >= current_interval:
		time_since_last_ad = 0.0
		spawnAd()


func spawnAd() -> void:
	var adScene = adScenes[randi() % adScenes.size()]
	var newAd = adScene.instantiate()

	var viewport_size = get_viewport_rect().size
	var minX = 200.0
	var maxX = viewport_size.x - 200.0
	var minY = 200.0
	var maxY = viewport_size.y - 200.0

	if adScene == preload("res://scenes/OceanAd.tscn") or adScene == preload("res://scenes/ArtistAd.tscn"):
		minY = 300.0

	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	newAd.position = Vector2(randomX, randomY)

	add_child(newAd)
	newAd.adDeleted.connect(deleteAd)
	newAd.linkClicked.connect(linkClicked)

	adCount += 1
	total_ads_spawned += 1     # NEW

	# Every 10 ads, pause for 2 seconds
	if total_ads_spawned % 10 == 0:
		ad_pause_timer = PAUSE_DURATION


func deleteAd() -> void:
	adCount = max(adCount - 1, 0)


func linkClicked() -> void:
	malware = true

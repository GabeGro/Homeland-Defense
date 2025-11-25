extends Node2D

var bank = "abcdefghijklmnopqrstuvwxyz"
var targetString = ""
var currCharIndex = 0
var gameActive = false

@onready var label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetString = generateString(15)
	currCharIndex = 0
	gameActive = false
	updateVisuals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	updateVisuals()

func generateString(length: int) -> String:
	var result = ""
	for i in range(length):
		var randChar = bank[randi_range(0, 14)]
		result += randChar
	return result
	
func updateVisuals() -> void:
	var typed = targetString.substr(0, currCharIndex)
	var untyped = targetString.substr(currCharIndex)
	label.text = "[center][color=#00ff00]%s[/color][color=#ffffff]%s[/color][/center]" % [typed, untyped]
	
func inputHandler(event):
	# We only care about keyboard key presses that are actual characters
	if event is InputEventKey and event.pressed and not event.echo:
		var typedChar = char(event.unicode) # Convert keycode to string character
		
		# Ensure the typed character matches the target
		if currCharIndex < targetString.length():
			var expectedChar = targetString[currCharIndex]
			
			if typedChar == expectedChar:
				correctKey()
			else:
				wrongKey()
				
func correctKey():
	currCharIndex += 1
	updateVisuals()
	
	# Check Win Condition
	if currCharIndex >= targetString.length():
		print("win!")

func wrongKey():
	# Optional: Add sound effect or screen shake here
	print("Wrong key!")

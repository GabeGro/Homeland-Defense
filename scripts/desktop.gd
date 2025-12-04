extends Node2D
const PopUpScene := preload("res://scenes/desktop/PopUp.tscn")
var popup
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SecretsFolder.secretExitClicked.connect(onSecretExitClicked)
	$GamesFolder.gameExitClicked.connect(onGamesExitClicked)
	$FinalFolder.finalExitClicked.connect(onFinalExitClicked)
	$SecretsFolder.passwordClicked.connect(passwordPressed)
	$SecretNotepad.passwordExitClicked.connect(onPassExitClicked)
	$PasswordPrompt.promptExitClicked.connect(onPromptExitClicked)
	$SecretsFolder.dataClicked.connect(dataPressed)

	# Create an instance of PopUp.tscn and add it to the Desktop scene
	popup = PopUpScene.instantiate()
	add_child(popup)

	# Turn on ads only now that we're in the Desktop
	PopUp.ads_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func dataPressed():
	$PasswordPrompt.visible = true

func secretsPressed() -> void:
	$SecretsFolder.visible = true

func gamesPressed() -> void:
	$GamesFolder.visible = true

func finalPressed() -> void:
	$FinalFolder.visible = true
	
func onSecretExitClicked():
	$SecretsFolder.visible = false
	
func onGamesExitClicked():
	$GamesFolder.visible = false
	
func onFinalExitClicked():
	$FinalFolder.visible = false
	
func passwordPressed():
	$SecretNotepad.visible = true
	
func onPassExitClicked():
	$SecretNotepad.visible = false
	
func onPromptExitClicked():
	$PasswordPrompt.visible = false

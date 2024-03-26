extends Node

static var gameManager
@export var timeBetween :float
@export var maxEmission :float
# Called when the node enters the scene tree for the first time.
func _ready():
	if(gameManager == null):
		gameManager = self
	else:
		printerr("2 Gamemanager objects detected")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

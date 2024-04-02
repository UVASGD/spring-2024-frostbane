extends Node

static var gameManager
@export var totalTime:int
@export var minFog :float
@export var maxFog :float
@onready var timer = $Timer 
@export var wE :WorldEnvironment
var curTime:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if(gameManager == null):
		gameManager = self
	else:
		printerr("2 Gamemanager objects detected")
		queue_free()
		
	wE.environment.volumetric_fog_density = minFog
	timer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func _on_timer_timeout():
	if(curTime < totalTime):
		wE.environment.volumetric_fog_density = float(curTime)/totalTime * (maxFog - minFog)
		print("TickTock")
		curTime+=1


extends Node

static var gameManager
@export var startingTime:int
@export var totalTime:int
@export var startingFog :float
@export var endingFog :float
@export var startingEmission:float
@export var endingEmission:float
@onready var timer = $Timer 
@export var wE :WorldEnvironment
@export var woodCount: WoodCount
var curTime:int = 0
#class range extends Object:
	#@export var min = 0
	#@export var max = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if(gameManager == null):
		gameManager = self
	else:
		printerr("2 Gamemanager objects detected")
		queue_free()
	wE.environment.volumetric_fog_density = startingFog
	wE.environment.volumetric_fog_emission = Color.from_hsv(0,0,startingEmission)
	print("prepause")
	await get_tree().create_timer(startingTime).timeout
	print("postpause")
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func _on_timer_timeout():
	if(curTime < totalTime):
		wE.environment.volumetric_fog_density = float(curTime)/totalTime * (endingFog - startingFog) + startingFog
		var v:float = float(curTime)/totalTime * (endingEmission - startingEmission) + startingEmission
		wE.environment.volumetric_fog_emission = Color.from_hsv(0,0,v)
		wE.environment.volumetric_fog_emission_energy = v
		print("Density: " + str(float(curTime)/totalTime * (endingFog - startingFog) + startingFog) + " Emmision: " + str(v) + " Energy: "+ str(startingEmission - v))
		curTime+=1



func _on_health_compoent_died():
	woodCount.count -= 2
	pass

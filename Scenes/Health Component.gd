extends Node
signal lostHp(float) #signal emmited with a percentage of health left
signal died #signal emmited when enitity dies

@export var maxHealth: int
var health :int
func _ready():
	health = maxHealth

func _process(delta):
	if(Input.is_action_just_pressed("ui_home")):
		loseHealth(1)

func loseHealth(dHealth):
	health -= dHealth
	lostHp.emit(float(health) / maxHealth)
	if(health <= 0):
		die()
func die():
	died.emit()
	print("died")
	queue_free()

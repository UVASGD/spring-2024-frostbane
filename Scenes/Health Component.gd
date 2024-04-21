extends Node
signal lostHp(float) #signal emmited with a percentage of health left
signal died #signal emmited when enitity dies

@export var maxHealth: int
@export var audioManager: Node
var health :int
func _ready():
	health = maxHealth

func _process(_delta):
	if(Input.is_action_just_pressed("ui_text_indent")):
		loseHealth(1)

func loseHealth(dHealth):
	audioManager.playSFX(SFX.Hit)
	health -= dHealth
	lostHp.emit(float(health) / maxHealth)
	if(health <= 0):
		die()
func die():
	died.emit()
	
	##queue_free()

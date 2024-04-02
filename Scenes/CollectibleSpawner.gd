extends Node

@export var collectible_scene : PackedScene
@export var range = 7
var id_counter = 0

func _ready():
	spawn_collectible()

	
func spawn_collectible():
	randomize()
	

	var random_x = randi() % range
	var random_z =  randi() % range
	var random_pos = Vector3(random_x, 0, random_z) + self.position
	print(random_pos)
	
	var new_collectible = collectible_scene.instantiate()
	new_collectible.position = random_pos
	new_collectible.name = "Wood_" + str(id_counter)
	id_counter += 1
	self.add_child(new_collectible)

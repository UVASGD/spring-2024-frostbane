extends Node3D

@onready var player = $Player

#func _physics_process(_delta):
	#get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)


func _on_navigation_agent_3d_2_velocity_computed(safe_velocity):
	pass # Replace with function body.

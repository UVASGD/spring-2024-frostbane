extends Node3D

@onready var scream = $Scream

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("scene")
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	$Camera3D.clear_current(true)
	$"../Player/Neck/Camera3D".make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("jumpscare")):
		$AnimationPlayer.play("jumpScare")
		print("this works")
		await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		

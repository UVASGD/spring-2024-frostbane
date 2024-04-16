extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const PLAYER_COLLISION_LAYER = 1
const COLLECTIBLE_COLLISION_LAYER = 2
#Boat layer is 4 not 3 because: https://www.reddit.com/r/godot/comments/18n88zn/raycast3dget_colliderget_collision_layer/
const BOAT_COLLISION_LAYER = 4


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var ray = $'Neck/Camera3D/RayCast3D'

func _ready():
	$HUD.update_inventory(wood_count.count)

func _unhandled_input(event):
	check_raycast()
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
			
	if event is InputEventKey:
		if event.keycode == KEY_E and event.pressed:
			if focused_interactable:
				if focused_interactable.get_collision_layer() == COLLECTIBLE_COLLISION_LAYER:
					pickup_collectible()
				elif focused_interactable.get_collision_layer() == BOAT_COLLISION_LAYER:
					try_repair_boat()
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	var space_state = get_world_3d().direct_space_state


# Interactable Logic

@export var wood_count: WoodCount 
var focused_interactable = null

func check_raycast():
	if ray.is_colliding():
		var col = ray.get_collider()
		#Add distanceconditional so you can't pickup from 1000 meters away
		if col and col.get_collision_layer() != PLAYER_COLLISION_LAYER:
			focus_interactable(col)
	else:
		focus_interactable(null)

func pickup_collectible():
	if focused_interactable and focused_interactable.get_collision_layer() == COLLECTIBLE_COLLISION_LAYER: 
		focused_interactable.queue_free()
		focus_interactable(null)
		wood_count.count += 1
		$HUD.update_inventory(wood_count.count)
	
func focus_interactable(interactable):
	focused_interactable = interactable
	$HUD.toggle_interactable_UI(interactable)
	

func _on_health_compoent_died():
	# die animation
	get_tree().reload_current_scene()
	pass # Replace with function body.

func try_repair_boat():
	if focused_interactable and focused_interactable.get_collision_layer() == BOAT_COLLISION_LAYER: 
		if wood_count.count < 10:
			$HUD.show_morewood_UI()
			return;
		focused_interactable.repair()
		wood_count.count -= 10
		$HUD.update_inventory(wood_count.counts)


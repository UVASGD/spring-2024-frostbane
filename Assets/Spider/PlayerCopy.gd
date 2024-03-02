extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const COLLECTIBLE_COLLISION_LAYER = 2


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var footsteps := $Footsteps
@onready var ray = $'Neck/Camera3D/RayCast3D'

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
			if focused_collectible:
				pickup_collectible()
		

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


# Collectible Logic

var collectible_count = 0
var focused_collectible = null

func check_raycast():
	if ray.is_colliding():
		var col = ray.get_collider()
		#Add distanceconditional so you can't pickup from 1000 meters away
		if col.get_collision_layer() == COLLECTIBLE_COLLISION_LAYER:
			focus_collectible(col)
	else:
		focus_collectible(null)

func pickup_collectible():
	if focused_collectible: 
		focused_collectible.queue_free()
		focus_collectible(null)
		collectible_count += 1
		$HUD.update_inventory(collectible_count)
	
func focus_collectible(collectible):
	focused_collectible = collectible
	$HUD.toggle_collectible_UI(collectible)

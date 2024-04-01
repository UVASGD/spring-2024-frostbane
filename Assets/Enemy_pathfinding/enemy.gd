extends CharacterBody3D

var speed: float
var vel: Vector3
var state_machine
enum states{IDLE, WALKING}
var current_state = states.IDLE	
#@onready var animation_tree =  $AnimationTree # do i need this, for animation stuff later??

func _ready():
	randomize()
	#state_machine = animation_tree.get("")
	speed = 0

func change_state(state):
	match state:
		"idle":
			current_state = states.IDLE
			speed = 0.000001
		"walking":
			current_state = states.WALKING
			speed = 3.0

func _physics_process(_delta):
	var target = $NavigationAgent3D2.get_next_path_position()
	var pos = get_global_transform().origin
	
	var n = $RayCast3D.get_collision_normal()
	if n.length_squared() < 0.001:
		n = Vector3(0,1,0)
	
	vel = (target-pos).slide(n).normalized() * speed
	#$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(vel.x,vel.z),delta *10)
	
	$NavigationAgent3D2.set_velocity(vel)
	move_and_slide()
	
func move_to(target_pos):
	change_state("walking")
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D2.set_target_position(closest_pos)

func get_random_pos_in_sphere(radius:float) -> Vector3:
	var x1 = randi_range(-1,1)
	var x2 = randi_range(-1,1)
	
	
	while x1 *x1 + x2*x2 >=1:
		x1 = randi_range(-1,1)
		x2 = randi_range(-1,1)
		
	var random_pos_on_unit_sphere = Vector3(
		1-2 * (x1*x1 + x2*x2),
		0,
		1-2 * (x1*x1 + x2*x2)	
	)
	
	random_pos_on_unit_sphere.x *= randi_range(-radius, radius)
	random_pos_on_unit_sphere.y *= randi_range(-radius, radius)
	
	return random_pos_on_unit_sphere


func _on_navigation_agent_3d_2_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)


func _on_navigation_agent_3d_2_navigation_finished():
	change_state("idle")
	$MoveTimer.start()


func _on_move_timer_timeout():
	var sphere_point = get_random_pos_in_sphere(50)
	move_to(sphere_point)


extends CharacterBody3D
@onready var patrol_nav_agent: NavigationAgent3D = $NavigationAgent3D2

@export var target_nodes: Array[Marker3D]
@onready var nav_agent = $NavigationAgent3D

@onready var player: PhysicsBody3D = $"../Player"
@onready var playerCheck: Node3D = $"../Player"
@export var audioManager : Node

const PLAYER_COLLISION_LAYER = 7

var SPEED = 5
var accel = 5

var inArea = false;
var canMove = true;
var canShuffle = true;


var canAttack = true;
var soundPlayed : bool = false
func _physics_process(delta):
	if(inArea):	
		var space = get_viewport().world_3d.direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
		query.exclude = [self]
		var results = space.intersect_ray(query)
		

		if results:
			if results.collider == player:				
				var current_location = global_transform.origin
				var next_location = nav_agent.get_next_path_position()
				var newVelocity = (next_location - current_location).normalized() * SPEED
				if (not soundPlayed): 
					audioManager.playSFX(SFX.Growl)
					soundPlayed = true
				if(canAttack):
					nav_agent.set_velocity(newVelocity)
				else:
					nav_agent.set_velocity(Vector3(0, 0, 0))
				
				if(nav_agent.distance_to_target() < 1.27 and canAttack):
						playerCheck.get_node("HealthCompoent").loseHealth(1)
						$AnimationPlayer.play("Attack")
						canAttack = false
						await get_tree().create_timer(4).timeout
						canAttack = true
						nav_agent.set_velocity(newVelocity)
			else:
				print("Reset Sound")
				soundPlayed = false
				
	else:
		var direction = Vector3()
		var item = target_nodes[0]
		if(canMove):
			#print(item)
			patrol_nav_agent.target_position = item.global_position

			direction = patrol_nav_agent.get_next_path_position() - global_position
			direction = direction.normalized()
			
		
			velocity = velocity.lerp(direction * SPEED , accel * delta)
		
			move_and_slide()

		if global_position.distance_to(item.global_position) < 1.0:
			
			target_nodes.shuffle()
			canMove = false;
			await get_tree().create_timer(4).timeout
			canMove = true;

			var nextTarget = target_nodes[0]
			print(nextTarget)
			patrol_nav_agent.target_position = nextTarget.global_position

			direction = patrol_nav_agent.get_next_path_position()- global_position
			direction = direction.normalized()
	
			velocity = velocity.lerp(direction * SPEED , accel * delta)
	
			move_and_slide()


	
	

func update_target_location(target_location):
	nav_agent.target_position = target_location
	

	
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
	

func _on_area_3d_body_entered(body):
	if (body != null && body.get_instance_id() == playerCheck.get_instance_id()):
		inArea = true
		print("true")

func _on_area_3d_body_exited(body):
	if (body != null && body.get_instance_id() == playerCheck.get_instance_id()):
		inArea = false

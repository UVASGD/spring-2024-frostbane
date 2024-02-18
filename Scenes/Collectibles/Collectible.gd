extends Area3D

func on_body_entered(body):
	if body.get_collision_layer() == 1:
		body.pickup_collectible()
		queue_free()

extends RigidBody2D

func _on_Bullet_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("player"):
		body.shot(1)
	if body.is_in_group("object"):
		print("Object")
		print(body)
	queue_free()

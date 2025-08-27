extends Node2D


@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles





func _input(event: InputEvent) -> void:
	
	var mouse_pos = get_global_mouse_position()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if _mouse_over(mouse_pos):
			explosion_particles.emitting = true
			
			await get_tree().create_timer(.2).timeout
			
			queue_free()
			print("fart")







func _mouse_over(mouse_pos: Vector2):
	
	var shape = collision_shape_2d.shape
	
	if shape is RectangleShape2D:
		var rect = Rect2(global_position - shape.extents, shape.extents * 2)
		return rect.has_point(mouse_pos)
	elif shape is CircleShape2D:
		return global_position.distance_to(mouse_pos) <= shape.radius
	
	return false
	

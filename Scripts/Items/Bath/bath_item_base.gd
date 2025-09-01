extends Area2D

@onready var mouse_collision: CollisionShape2D = $Mouse_Collision

var draggin: bool = false


func _process(delta: float) -> void:
	
	if draggin:
		position = get_global_mouse_position()
	

func _input(event: InputEvent) -> void:
	
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		
		if _mouse_over(mouse_pos):
			
			draggin = true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			
			draggin = false




func _mouse_over(mouse_pos: Vector2):
	
	var shape = mouse_collision.shape
	
	if shape is RectangleShape2D:
		var rect = Rect2(global_position - shape.extents, shape.extents * 2)
		return rect.has_point(mouse_pos)
	elif shape is CircleShape2D:
		return global_position.distance_to(mouse_pos) <= shape.radius
	
	return false
	

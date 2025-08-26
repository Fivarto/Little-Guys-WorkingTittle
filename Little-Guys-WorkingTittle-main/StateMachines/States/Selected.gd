extends State
class_name TamaSelected


var selected: bool = false
var target_position: Vector2 = Vector2.ZERO

@onready var tamagochi_sprite: Sprite2D = $Tamagochi_Sprite
@onready var select_area_collision: CollisionShape2D = $SelectionArea/SelectAreaCollision



func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = Vector2()
		
		if _mouse_over(mouse_pos):
			
			set_selected_outline(true)
			
			print("Tamagochi Selected")
		
		elif selected:
			target_position = mouse_pos
			print("Moving to: ", target_position)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and selected:
		
		set_selected_outline(false)
		
		pass











func _mouse_over(mouse_pos: Vector2):
	
	var shape = select_area_collision.shape
	
	if shape is RectangleShape2D:
		var rect = Rect2(owner.wander_body.global_position - shape.extents, shape.extents * 2)
		return rect.has_point(mouse_pos)
	elif shape is CircleShape2D:
		return owner.wander_body.global_position.distance_to(mouse_pos) <= shape.radius
	
	return false
	


func set_selected_outline(value: bool) -> void:
	
	selected = value
	tamagochi_sprite.use_parent_material = !selected
	

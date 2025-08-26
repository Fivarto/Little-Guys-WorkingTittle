extends Area2D
class_name Food

@export var food_res: FoodStats

@onready var food_sprite: Sprite2D = $Food_Sprite

var is_dragging: bool = false
var drag_offset:= Vector2.ZERO
@onready var dragg_collision: CollisionShape2D = $Dragg_Collision

func _ready() -> void:
	
	add_to_group("Food")
	food_sprite.texture = food_res.food_sprite


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _mouse_over():
			is_dragging = true 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			is_dragging = false


func _process(delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset


func _mouse_over() -> bool:
	
	var mouse_pos = get_global_mouse_position()
	var shape = dragg_collision.shape
	
	if shape is RectangleShape2D:
		var rect = Rect2(global_position - shape.extents, shape.extents * 2)
		return rect.has_point(mouse_pos)
	elif shape is CircleShape2D:
		return global_position.distance_to(mouse_pos) <= shape.radius
	
	return false

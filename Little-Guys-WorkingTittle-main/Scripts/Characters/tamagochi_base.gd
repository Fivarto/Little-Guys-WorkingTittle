extends CharacterBody2D
class_name Tamagochi_Base

#BODY
@export var tama_res: TamagochiStats
@export var tama_body: CharacterBody2D
@onready var tamagochi_sprite: Sprite2D = $Tamagochi_Sprite


#CHILD NODES
@onready var state_machine: StateMachineBase = $State_Machine
@onready var hunger_bar: TextureProgressBar = $TamaGochiStatusUI/HungerBar

#TARGETS
var target: Area2D


#SELECTION VARS
var selected: bool = false
var target_position: Vector2 = Vector2.ZERO
@onready var select_area_collision: CollisionShape2D = $SelectionArea/SelectAreaCollision



func _ready() -> void:
	
	
	tamagochi_sprite.texture = tama_res.sprite


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		
		if _mouse_over(mouse_pos):
			
			set_selected_outline(true)
			
			print("Tamagochi Selected")
		
		elif selected:
			target_position = mouse_pos
			print("Moving to: ", target_position)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and selected:
		
		set_selected_outline(false)
		
		pass


func _process(delta: float) -> void:
	
	tama_res.hunger -= delta 
	hunger_bar.value = tama_res.hunger

func _physics_process(delta: float) -> void:
	
	if selected:
		if target_position != Vector2.ZERO:
			var direction = (target_position - global_position).normalized()
			velocity = direction * tama_res.move_speed
			move_and_slide()
			
			if global_position.distance_to(target_position) < 5:
				velocity = Vector2.ZERO
				target_position = Vector2.ZERO
	else:
		move_and_slide()



func _mouse_over(mouse_pos: Vector2):
	
	var shape = select_area_collision.shape
	
	if shape is RectangleShape2D:
		var rect = Rect2(global_position - shape.extents, shape.extents * 2)
		return rect.has_point(mouse_pos)
	elif shape is CircleShape2D:
		return global_position.distance_to(mouse_pos) <= shape.radius
	
	return false
	

func set_selected_outline(value: bool) -> void:
	
	selected = value
	tamagochi_sprite.use_parent_material = !selected
	


#TODO
#func _get_target():
	#
	#target = get_tree().get_first_node_in_group("Items")
	#
	#return target


func _on_mouth_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Food"):
		var food = area as Food
		
		if food:
			tama_res.hunger = clamp(tama_res.hunger + food.food_res.hunger_restore , 0, tama_res.stomach_size)
			SignalBus.FoodEaten.emit()
			
			if state_machine.current_state is Idle:
				state_machine.current_state.target_temp = null
			food.queue_free()

extends CharacterBody2D
class_name Tamagochi_Base

#BODY
@export var tama_res: TamagochiStats
@export var tama_body: CharacterBody2D
@onready var tamagochi_sprite: Sprite2D = $Tamagochi_Sprite
@onready var tamagochi_animation: AnimatedSprite2D = $Tamagochi_Animation

#STATUS BAR/ICONS
@onready var status_particle: CPUParticles2D = $Status_Particle
@onready var hunger_bar: TextureProgressBar = $TamaGochiStatusUI/HungerBar
@onready var hunger_icon: AnimatedSprite2D = $TamaGochiStatusUI/HungerIcon


@onready var hygien_icon: AnimatedSprite2D = $TamaGochiStatusUI/HygienIcon


#STATS AND STUFFS
var taking_bath: bool = false

#CHILD NODES
@onready var state_machine: StateMachineBase = $State_Machine


#TARGETS
var target: Area2D


#SELECTION VARS
var selected: bool = false
var target_position: Vector2 = Vector2.ZERO
@onready var select_area_collision: CollisionShape2D = $SelectionArea/SelectAreaCollision

#POOP
const POOP = preload("res://Scenes/Tamagochis/Waste/Poop.tscn")

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
			tama_res.move_speed = 30
			print("Moving to: ", target_position)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and selected:
		
		tama_res.move_speed = 10
		set_selected_outline(false)
		target_position = Vector2()
		pass


func _process(delta: float) -> void:
	
	_decay_stats(delta)
	_status_icon_handler()
	
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
	elif tama_body:
		
		tama_body.move_and_slide()
		
		var viewport_rect = get_viewport().get_visible_rect()
		var pos = tama_body.global_position
		
		#CLAMPING TAMAGOCHI IN THE VIEWPORT 
		pos.x = clamp(pos.x, viewport_rect.position.x, viewport_rect.end.x)
		pos.y = clamp(pos.y, viewport_rect.position.y, viewport_rect.end.y)
		
		tama_body.global_position = pos



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
	tamagochi_animation.use_parent_material = !selected

func _status_icon_handler() -> void:
	
	#TODO Tirar essas logica
	
	
	#HANDLE HUNGER STATUS ICON
	var hunger_percent = (tama_res.hunger * 100) / tama_res.stomach_size
	
	match hunger_percent:
		_ when hunger_percent <= 0:
			hunger_icon.frame = 2
		_ when hunger_percent <= 50:
			status_particle.emitting = true
			hunger_icon.frame = 1
		_:
			hunger_icon.frame = 0
	
	#HANDLE HYGIEN ICON STATUS ICON
	var hygien_percent = (tama_res.hygiene * 100) / 100
	
	match hygien_percent:
		
		_ when hygien_percent <= 0:
			hygien_icon.frame = 2
		_ when hygien_percent <= 50:
			status_particle.emitting = true
			hygien_icon.frame = 1
		_:
			hygien_icon.frame = 0

#TODO
#func _get_target():
	#
	#target = get_tree().get_first_node_in_group("Items")
	#
	#return target


func _decay_stats(value: float):
	
	#HUNGER
	tama_res.hunger -= value
	clamp(tama_res.hunger, 0.0 , tama_res.stomach_size)
	
	#ENERGY
	tama_res.energy -= value
	clamp(tama_res.energy, 0.0 , 100.0)
	
	#HAPPINESS
	tama_res.happiness -= value
	clamp(tama_res.happiness, 0.0 , 100.0)
	
	
	#HYGIEN
	if !taking_bath:
		tama_res.hygiene -= value
		clamp(tama_res.hygiene, 0.0 , 100.0)
	elif taking_bath:
		tama_res.hygiene += value
		clamp(tama_res.hygiene, 0.0 , 100.0)
	


func eat_food(area : Area2D) -> void:
	
	var food = area as Food
	
	if food:
		
		tama_res.hunger = clamp(tama_res.hunger + food.food_res.hunger_restore , 0 , tama_res.stomach_size)
		food.queue_free()
		
		
		SignalBus.FoodEaten.emit()
		
		#POOP SPAWN
		var poop_ins = POOP.instantiate()
		poop_ins.position = position
		get_parent().add_child(poop_ins)
		
		if state_machine.current_state is Idle:
			state_machine.current_state.target_temp = null


func _on_mouth_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Food"):
		call_deferred("eat_food", area) 



#BANHO
func _on_selection_area_area_entered(area: Area2D) -> void:
	
	
	if area.is_in_group("Hygien"):
		taking_bath = true


func _on_selection_area_area_exited(area: Area2D) -> void:
	
	if area.is_in_group("Hygien"):
		taking_bath = false

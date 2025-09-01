extends Node


var current_state: State
var states: Dictionary = {}

@export var initial_state: State


func _ready() -> void:
	
	if initial_state:
		
		initial_state._Enter()
		
		current_state = initial_state
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_state_transitioned)


func _process(delta: float) -> void:
	
	if current_state:
		current_state._Update(delta)


func _physics_process(delta: float) -> void:
	
	if current_state:
		current_state._Physics_Update(delta)




func _on_state_transitioned(state_who_called, name_of_the_new_state):
	
	if current_state != current_state:
		return
	
	var new_state = states.get(name_of_the_new_state.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state._Exit()
	
	new_state._Enter()
	
	current_state = new_state
	

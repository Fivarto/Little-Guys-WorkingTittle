extends State
class_name Idle


var move_to_position: Vector2
var wander_timer : float

var target_temp: Area2D
var move_speed_temp : float


func randomize_wander():
	
	if !owner.selected:
		move_to_position = Vector2(randf_range(-1 , 1),randf_range(-1 , 1))
		wander_timer = randf_range(1, 3)

func _Enter():
	print("ENTROU IDLE")
	if not SignalBus.FoodSpawned.is_connected(get_target):
		SignalBus.FoodSpawned.connect(get_target)
	get_target()
	owner.tama_res.move_speed = 10
	randomize_wander()


func _Update(delta: float):
	
	if wander_timer > 0:
		wander_timer -= delta
	else:
		randomize_wander()
		


func _Physics_Update(delta: float):
	
	if owner.tama_body:
		owner.tama_body.velocity = move_to_position * owner.tama_res.move_speed
		
	
	if target_temp and is_instance_valid(target_temp):
		var direction = target_temp.global_position - owner.tama_body.global_position
		
		if direction.length() < 50:
			Transitioned.emit(self, "Follow")
	else:
		target_temp = null


func get_target():
	
	target_temp = get_tree().get_first_node_in_group("Items")

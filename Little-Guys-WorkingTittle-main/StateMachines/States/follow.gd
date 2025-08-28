extends State
class_name Follow

var target: Area2D

func _Enter():
	
	print("ENTROU FOLLOW")
	if not SignalBus.FoodEaten.is_connected(_food_eaten):
		SignalBus.FoodEaten.connect(_food_eaten)
	target = get_tree().get_first_node_in_group("Items")



func _Physics_Update(delta: float):
	
	if target:
		var direction =  target.global_position - owner.tama_body.global_position
		
		
		if direction.length() > 5:
			owner.tama_body.velocity = direction.normalized() * owner.tama_res.move_speed
		else:
			owner.tama_body.velocity = Vector2()
		
		if direction.length() > 75:
			Transitioned.emit(self, "Idle")

func _food_eaten():
	
	Transitioned.emit(self, "Idle")
	
	pass

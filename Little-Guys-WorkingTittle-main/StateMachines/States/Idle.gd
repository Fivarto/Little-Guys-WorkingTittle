extends State
class_name Idle


var move_to_position: Vector2
var wander_timer : float

var target_temp: Area2D


func randomize_wander():
	
	if !owner.selected:
		move_to_position = Vector2(randf_range(-1 , 1) , randf_range(-1 , 1))
		wander_timer = randf_range(1, 3)

func _Enter():
	
	randomize_wander()


func _Update(delta: float):
	
	if wander_timer > 0:
		wander_timer -= delta
	else:
		randomize_wander()
		


func _Physics_Update(delta: float):
	
	if owner.tama_body:
		
		owner.tama_body.velocity = move_to_position * owner.tama_res.move_speed
	
	

extends State
class_name Eat


var target_food: Area2D = null
var eat_time: float = 1.5
var timer : float = 0.0

@onready var tamagochi_animation: AnimatedSprite2D = $"../../Tamagochi_Animation"

var is_eating: bool = false

func _Enter() -> void:
	
	print("ENTERED EAT")
	
	
	timer = eat_time
	tamagochi_animation.play("Eat")
	is_eating = true


func _Update(delta: float) -> void:
	
	if is_eating:
		timer -= delta
		
		if timer <= 0 and tamagochi_animation.animation_finished:
			Transitioned.emit(self, "Idle")


func _Physics_Update(delta: float):
	
	owner.tama_body.velocity = Vector2()

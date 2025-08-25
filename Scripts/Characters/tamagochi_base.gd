extends CharacterBody2D
class_name Tamagochi_Base


@export var tama_res: TamagochiStats
@export var tama_body: CharacterBody2D

@onready var tamagochi_sprite: Sprite2D = $Tamagochi_Sprite



func _ready() -> void:
	
	tamagochi_sprite.texture = tama_res.sprite


func _physics_process(delta: float) -> void:
	
	move_and_slide()

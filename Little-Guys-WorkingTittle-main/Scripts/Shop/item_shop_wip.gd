extends Control

const FOOD = preload("res://Scenes/Food/food.tscn")

@onready var buy_button: TextureButton = $GridContainer/Cursor3/VBoxContainer/TextureButton




func _on_buy_button_pressed() -> void:
	var food_ins = FOOD.instantiate()
	
	food_ins.position = Vector2(50, 50)
	
	add_child(food_ins)

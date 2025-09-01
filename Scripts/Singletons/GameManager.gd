extends Node




func _ready() -> void:
	
	SignalBus.FoodEaten.connect(_print_food_status)


func _print_food_status():
	
	print("Food eaten")

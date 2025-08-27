extends State
class_name TamaSelected



func _Enter():
	
	print("Entrou no State : SELECTED")
	await get_tree().create_timer(.2).timeout
	set_selected_outline(true)






func _Exit():
	
	set_selected_outline(false)


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and owner.selected:
		print("Mouse Click")
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and owner.selected:
		
		Transitioned.emit(self, "Idle")
	
	pass

func set_selected_outline(value: bool) -> void:
	
	owner.selected = value
	owner.tamagochi_sprite.use_parent_material = !owner.selected
	

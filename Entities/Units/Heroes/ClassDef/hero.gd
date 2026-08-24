class_name Hero extends Unit

@export var data : HeroData

func start_combat() -> void:
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()

func use_attack() -> void:
	print("use attack")
	
func use_ability() -> void:
	print("use_ability")

#--------------------------

func update_held_status(held : bool) -> void:
	if held:
		get_parent().move_child(self, -1)
		z_index = 2
		for unit in get_tree().get_nodes_in_group("Units"):
			unit.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		z_index = 0
		for unit in get_tree().get_nodes_in_group("Units"):
			unit.mouse_filter = MOUSE_FILTER_STOP

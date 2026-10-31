class_name Hero extends Unit

@export var data : HeroData

func _ready() -> void:
	super()
	temp_data = data.duplicate()
	cd_component.unit_temp_data = temp_data
	
	%ItemSlot1.visible = true
	%ItemSlot2.visible = data.num_item_slots >= 2
	%ItemSlot3.visible = data.num_item_slots >= 3
	%ItemSlot4.visible = data.num_item_slots >= 4
	%ItemSlot5.visible = data.num_item_slots >= 5
	%ItemSlot6.visible = data.num_item_slots >= 6

#------------------------

func start_combat() -> void:
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()

func use_attack() -> void:
	animation_player.play("attack")
	
func process_attack() -> void:
	var dmg = DamageSource.new()
	dmg.amount = 10
	emit_signal("damage_enemy", dmg, 0)
	
func use_ability() -> void:
	animation_player.play("ability")

func process_ability() -> void:
	pass


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

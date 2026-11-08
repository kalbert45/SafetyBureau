class_name Hero extends Unit

@export var data : HeroData

func _ready() -> void:
	super()
	temp_data = data.replicate()
	cd_component.unit_temp_data = temp_data
	
	%ItemSlot1.visible = true
	%ItemSlot2.visible = data.num_item_slots >= 2
	%ItemSlot3.visible = data.num_item_slots >= 3
	%ItemSlot4.visible = data.num_item_slots >= 4
	%ItemSlot5.visible = data.num_item_slots >= 5
	%ItemSlot6.visible = data.num_item_slots >= 6
	
	%ItemSlot1.connect("item_set", update_items)
	%ItemSlot2.connect("item_set", update_items)
	%ItemSlot3.connect("item_set", update_items)
	%ItemSlot4.connect("item_set", update_items)
	%ItemSlot5.connect("item_set", update_items)
	%ItemSlot6.connect("item_set", update_items)
	
	initialize()

#------------------------

func start_combat() -> void:
	$LevelLabel.visible = false
	$Items.visible = false
	
	# process items
	for item_data in data.item_datas:
		if not item_data : continue
		if not item_data.item_uid.is_empty():
			var item = load(item_data.item_uid).instantiate()
			add_child(item)
	
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()
	
func process_attack() -> void:
	var dmg = DamageSource.new()
	dmg.amount = temp_data.attack_power
	dmg.is_crit = randi() < temp_data.crit / 100.0
	dmg.crit_multiplier = 200 + max(temp_data.crit - 100, 0)
	emit_signal("damage_enemy", dmg, 0)
	

func process_ability() -> void:
	var dmg = DamageSource.new()
	dmg.amount = temp_data.ability_power
	dmg.is_crit = randi() < temp_data.crit / 100.0
	dmg.crit_multiplier = 200 + max(temp_data.crit - 100, 0)
	emit_signal("damage_enemy", dmg, 0)


#--------------------------
# Use data AND temp data here
func update_items() -> void:
	data.item_datas[0] = %ItemSlot1.current_item_data
	data.item_datas[1] = %ItemSlot2.current_item_data
	data.item_datas[2] = %ItemSlot3.current_item_data
	data.item_datas[3] = %ItemSlot4.current_item_data
	data.item_datas[4] = %ItemSlot5.current_item_data
	data.item_datas[5] = %ItemSlot6.current_item_data
	
	temp_data.item_datas[0] = %ItemSlot1.current_item_data
	temp_data.item_datas[1] = %ItemSlot2.current_item_data
	temp_data.item_datas[2] = %ItemSlot3.current_item_data
	temp_data.item_datas[3] = %ItemSlot4.current_item_data
	temp_data.item_datas[4] = %ItemSlot5.current_item_data
	temp_data.item_datas[5] = %ItemSlot6.current_item_data
	
	initialize()
	
	emit_signal("update_stats_display")

#------------UI--------------

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

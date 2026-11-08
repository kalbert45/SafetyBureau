extends Node

var HERO_ARR : Array[Hero] = [] # front of array is *frontline*. this is flipped around for combat purposes
var ENEMY_ARR : Array[Enemy] = [] # front of array is frontline


func handle_combat() -> void:
	# flip hero array for combat purposes
	# also need to adjust position index for the running animation
	HERO_ARR.reverse()
	for i in range(HERO_ARR.size()):
		if not is_instance_valid(HERO_ARR[i]): continue
		HERO_ARR[i].temp_data.position_index = i
	
	# setup arrays
	HERO_ARR = HERO_ARR.filter(_filter_out_null)
	ENEMY_ARR = ENEMY_ARR.filter(_filter_out_null)
	
	arrange_units()
	
	# connect signals
	for unit : Unit in HERO_ARR + ENEMY_ARR:
		unit.death.connect(_on_unit_death.bind(unit))
		unit.damage_hero.connect(_on_damage_hero.bind(unit))
		unit.damage_enemy.connect(_on_damage_enemy.bind(unit))
		
		unit.start_combat()

func arrange_units() -> void:
	for i in range(HERO_ARR.size()):
		if not is_instance_valid(HERO_ARR[i]) : continue
		var hero = HERO_ARR[i]
		hero.move_to(%HeroSlotContainer.get_child(Constants.NUM_HERO_SLOTS - i - 1).global_position, hero.temp_data.position_index != i)
		hero.temp_data.position_index = i
		hero.check_attack_mode()
	for i in range(ENEMY_ARR.size()):
		if not is_instance_valid(ENEMY_ARR[i]) : continue
		var enemy = ENEMY_ARR[i]
		enemy.move_to(%EnemySlotContainer.get_child(i).global_position, enemy.temp_data.position_index != i)
		enemy.temp_data.position_index = i
		enemy.check_attack_mode()

func check_combat_end() -> void:
	if HERO_ARR.is_empty() or ENEMY_ARR.is_empty():
		end_combat()

func end_combat() -> void:
	for unit : Unit in get_tree().get_nodes_in_group("Units"):
		if is_instance_valid(unit):
			unit.stop_combat()
	SignalBus.end_combat.emit()

#-----------------------

func _on_damage_hero(dmg : DamageSource, target_index : int, source_unit : Unit) -> void:
	if HERO_ARR.get(target_index):
		HERO_ARR.get(target_index).take_damage(dmg)
	
func _on_damage_enemy(dmg : DamageSource, target_index : int, source_unit : Unit) -> void:
	if ENEMY_ARR.get(target_index):
		ENEMY_ARR.get(target_index).take_damage(dmg)

func _on_unit_death(unit : Unit) -> void:
	if unit is Hero:
		HERO_ARR.erase(unit)
	else:
		ENEMY_ARR.erase(unit)
	
	check_combat_end()
	arrange_units()

#-----------------------
func _filter_out_null(x) -> bool:
	if not is_instance_valid(x):
		return false
	return true

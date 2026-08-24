extends Node

var HERO_ARR : Array[Hero] = [] # front of array is *frontline*. this is flipped around for combat purposes
var ENEMY_ARR : Array[Enemy] = [] # front of array is frontline


func handle_combat() -> void:
	# setup arrays
	HERO_ARR = HERO_ARR.filter(_filter_out_null)
	ENEMY_ARR = ENEMY_ARR.filter(_filter_out_null)
	
	# flip hero array for combat purposes
	HERO_ARR.reverse()
	
	arrange_units()
	
	# connect signals
	for unit : Unit in HERO_ARR + ENEMY_ARR:
		unit.death.connect(_on_unit_death.bind(unit))
		unit.damage_hero.connect(_on_damage_hero)
		unit.damage_enemy.connect(_on_damage_enemy)
		
		unit.start_combat()

func arrange_units() -> void:
	for i in range(HERO_ARR.size()):
		if not is_instance_valid(HERO_ARR[i]) : continue
		HERO_ARR[i].move_to(%HeroSlotContainer.get_child(Constants.NUM_HERO_SLOTS - i - 1).global_position, true)
		HERO_ARR[i].data.position_index = i
	for i in range(ENEMY_ARR.size()):
		if not is_instance_valid(ENEMY_ARR[i]) : continue
		ENEMY_ARR[i].move_to(%EnemySlotContainer.get_child(i).global_position)
		ENEMY_ARR[i].data.position_index = i

func check_combat_end() -> bool:
	return false

#-----------------------

func _on_damage_hero(dmg : DamageSource, target_index : int) -> void:
	pass
	
func _on_damage_enemy(dmg : DamageSource, target_index : int) -> void:
	pass

func _on_unit_death(unit : Unit) -> void:
	pass

#-----------------------
func _filter_out_null(x) -> bool:
	if not is_instance_valid(x):
		return false
	return true

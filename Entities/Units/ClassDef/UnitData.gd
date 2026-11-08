class_name UnitData extends Resource

@export var unit_name : String
@export var unit_profile_tex : Texture2D
@export var position_index := 0

@export var skill_data : UnitSkillData

@export_category("CORE STATS")
@export var health := 1000 : get = _get_health
@export var base_attack_speed := 0.35
@export var attack_range := 1 : get = _get_attack_range

@export_category("MUTABLE STATS")
@export var bonus_health := 0 : get = _get_bonus_health
@export var health_regen := 0 : get = _get_health_regen
@export var defense := 0 : get = _get_defense

@export var attack_speed := 0 : get = _get_attack_speed
@export var attack_power := 0 : get = _get_attack_power

#@export var ability_cd := 4.0
@export var ability_power := 0 : get = _get_ability_power
@export var ability_haste := 0 : get = _get_ability_haste

@export var crit := 0 : get = _get_crit
@export var omnivamp := 0 : get = _get_omnivamp

func _get_health() -> int:
	return health
	
func _get_bonus_health() -> int:
	return bonus_health

func _get_health_regen() -> int:
	return health_regen
	
func _get_defense() -> int:
	return defense

func _get_attack_range() -> int:
	return attack_range
	
func _get_attack_speed() -> int:
	return attack_speed
	
func _get_attack_power() -> int:
	return attack_power
	
func _get_ability_power() -> int:
	return ability_power
	
func _get_ability_haste() -> int:
	return ability_haste
	
func _get_crit() -> int:
	return crit
	
func _get_omnivamp() -> int:
	return omnivamp

class_name HeroData extends UnitData

enum HERO_NAMES {
	JOSEPHINE, SIG,
}

const HERO_SCENE_PATHS = {
	HERO_NAMES.JOSEPHINE : "res://Entities/Units/Heroes/Josephine/josephine.tscn",
	HERO_NAMES.SIG : "res://Entities/Units/Heroes/Sig/sig.tscn",
}

@export var hero_enum := HERO_NAMES.JOSEPHINE

@export_category("ITEMS")
@export var num_item_slots := 1
@export var item_datas : Array[ItemData] = [null, null, null, null, null, null]

@export_category("LEVEL")
@export var level := 1
@export var experience := 0

# BONUS STATS PER LEVEL
@export var health_growth := 100
@export var health_regen_growth := 1
@export var defense_growth := 10

@export var attack_speed_growth := 5
@export var attack_power_growth := 5

func replicate() -> HeroData:
	var new_data = self.duplicate()
	new_data.item_datas = item_datas.duplicate()
	
	return new_data

#--------------------------------

func _get_health() -> int:
	return health + ((level - 1) * health_growth)

func _get_bonus_health() -> int:
	var _bonus_health = bonus_health
	for item_data in item_datas:
		if not item_data : continue
		_bonus_health += item_data.health
	return _bonus_health

func _get_health_regen() -> int:
	var _health_regen = health_regen
	for item_data in item_datas:
		if not item_data : continue
		_health_regen += item_data.health_regen
	return _health_regen + ((level - 1) * health_regen_growth)
	
func _get_defense() -> int:
	var _defense = defense
	for item_data in item_datas:
		if not item_data : continue
		_defense += item_data.defense
	return _defense + ((level - 1) * defense_growth)

func _get_attack_range() -> int:
	var _attack_range = attack_range
	for item_data in item_datas:
		if not item_data : continue
		_attack_range += item_data.attack_range
	return _attack_range
	
func _get_attack_speed() -> int:
	var _attack_speed = attack_speed
	for item_data in item_datas:
		if not item_data : continue
		_attack_speed += item_data.attack_speed
	return _attack_speed + ((level - 1) * attack_speed_growth)
	
func _get_attack_power() -> int:
	var _attack_power = attack_power
	for item_data in item_datas:
		if not item_data : continue
		_attack_power += item_data.attack_power
	return _attack_power + ((level - 1) * attack_power_growth)
	
func _get_ability_power() -> int:
	var _ability_power = ability_power
	for item_data in item_datas:
		if not item_data : continue
		_ability_power += item_data.ability_power
	return _ability_power
	
func _get_ability_haste() -> int:
	var _ability_haste = ability_haste
	for item_data in item_datas:
		if not item_data : continue
		_ability_haste += item_data.ability_haste
	return _ability_haste
	
func _get_crit() -> int:
	var _crit = crit
	for item_data in item_datas:
		if not item_data : continue
		_crit += item_data.crit
	return _crit
	
func _get_omnivamp() -> int:
	var _omnivamp = omnivamp
	for item_data in item_datas:
		if not item_data : continue
		_omnivamp += item_data.omnivamp
	return _omnivamp

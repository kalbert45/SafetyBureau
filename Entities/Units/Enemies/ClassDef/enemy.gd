class_name Enemy extends Unit

@export var data : EnemyData

func _ready() -> void:
	super()
	temp_data = data.replicate()
	cd_component.unit_temp_data = temp_data

	initialize()

#-----------------------------

func start_combat() -> void:
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()
	
func process_attack() -> void:
	var dmg = DamageSource.new()
	dmg.amount = temp_data.attack_power
	emit_signal("damage_hero", dmg, 0)

func process_ability() -> void:
	var dmg = DamageSource.new()
	dmg.amount = temp_data.ability_power
	emit_signal("damage_hero", dmg, 0)

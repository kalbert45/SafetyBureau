class_name Enemy extends Unit

@export var data : EnemyData

func _ready() -> void:
	super()
	temp_data = data.duplicate()
	cd_component.unit_temp_data = temp_data

#-----------------------------

func start_combat() -> void:
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()

func use_attack() -> void:
	animation_player.play("attack")
	
func process_attack() -> void:
	var dmg = DamageSource.new()
	dmg.amount = 15
	emit_signal("damage_hero", dmg, 0)
	
func use_ability() -> void:
	animation_player.play("ability")

func process_ability() -> void:
	pass

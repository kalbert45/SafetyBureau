class_name Enemy extends Unit

@export var data : EnemyData

func start_combat() -> void:
	cd_component.start()
	
func stop_combat() -> void:
	cd_component.stop()

func use_attack() -> void:
	print("use attack")
	
func use_ability() -> void:
	print("use_ability")

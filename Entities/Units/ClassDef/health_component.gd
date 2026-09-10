class_name HealthComponent extends Control

# handles purely health visuals

var max_health := 100
var health := 100 :
	set = set_health
var shield := 0 :
	set = set_shield

# affects label
func set_health(value : int) -> void:
	health = value
	$HealthLabel.text = str(health)
	$ShieldLabel.text = "[" + str(1000) + "]"

# affects label
func set_shield(value : int) -> void:
	shield = value

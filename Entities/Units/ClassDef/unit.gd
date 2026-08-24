class_name Unit extends Control

signal damage_hero(dmg : DamageSource, target_index : int)
signal damage_enemy(dmg : DamageSource, target_index : int)
signal effect_hero
signal effect_enemy

signal death

var _tween : Tween

var max_health := 100 :
	set(value):
		max_health = value
		health_component.max_health = max_health
var current_health := 100 :
	set(value):
		current_health = clampi(value, 0, max_health)
		health_component.health = current_health
var shield := 0:
	set(value):
		shield = maxi(0, value)
		health_component.shield = shield


@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health_component : HealthComponent = $HealthComponent
@onready var cd_component : CDComponent = $CDComponent

func _ready() -> void:
	cd_component.use_attack.connect(use_attack)
	cd_component.use_ability.connect(use_ability)

#----------- LOCALLY DEFINED -----------------
func start_combat() -> void:
	pass
	
func stop_combat() -> void:
	pass

func use_attack() -> void:
	pass
	
func use_ability() -> void:
	pass

func take_damage(dmg : DamageSource) -> int:
	return 0

#----------------------------------------------------

func move_to(p : Vector2, running : bool = false) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	if running:
		animation_player.play("run")
	z_index = 2
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", p, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await _tween.finished
	if running:
		animation_player.play("idle")
	z_index = 0
	return

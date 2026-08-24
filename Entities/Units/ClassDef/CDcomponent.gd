class_name CDComponent extends Control

signal use_attack
signal use_ability

var disabled := false
var attack_mode := false

@onready var attack_cd_timer = $AttackCDTimer
@onready var ability_cd_timer = $AbilityCDTimer

@onready var attack_cd_progress = $AttackCDProgress
@onready var ability_cd_progress = $AbilityCDProgress

func _ready() -> void:
	disabled = true
	attack_mode = false
	ability_cd_progress.visible = false
	attack_cd_progress.visible = false

func _process(_delta: float) -> void:
	if disabled : return
	ability_cd_progress.value = 100.0 - (100.0 * ability_cd_timer.time_left / ability_cd_timer.cooldown)
	attack_cd_progress.value = 100.0 - (100.0 * attack_cd_timer.time_left / attack_cd_timer.cooldown)

func start(_attack_mode : bool = false) -> void:
	disabled = false
	attack_mode = _attack_mode
	if attack_mode:
		attack_cd_progress.visible = true
		attack_cd_timer.start_timer()
	else:
		ability_cd_progress.visible = true
		ability_cd_timer.start_timer()
	
func stop() -> void:
	disabled = true
	attack_mode = false
	ability_cd_timer.stop()
	attack_cd_timer.stop()
	ability_cd_progress.visible = false
	attack_cd_progress.visible = false

func shift_to_attack_mode() -> void:
	attack_mode = true
	ability_cd_timer.stop()
	ability_cd_progress.visible = false
	attack_cd_timer.start_timer()
	attack_cd_progress.visible = true

func _on_attack_cd_timer_timeout() -> void:
	emit_signal("use_attack")


func _on_ability_cd_timer_timeout() -> void:
	emit_signal("use_ability")

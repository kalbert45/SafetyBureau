class_name CDComponent extends Control

signal use_attack
signal use_ability

var disabled := false
var attack_mode := false

var ability_ready := false

var unit_temp_data : UnitData = UnitData.new()

@onready var attack_cd_timer = $AttackCDTimer
@onready var ability_cd_timer = $AbilityCDTimer

#@onready var attack_cd_progress = $AttackCDProgress
@onready var ability_cd_progress = $AbilityCDProgress

func _ready() -> void:
	disabled = true
	attack_mode = false
	ability_cd_progress.visible = false
	#attack_cd_progress.visible = false

func _process(_delta: float) -> void:
	if disabled : return
	if ability_ready:
		ability_cd_progress.value = 100.0
	elif ability_cd_timer.is_stopped():
		ability_cd_progress.value = 0.0
	else:
		ability_cd_progress.value = 100.0 - (100.0 * ability_cd_timer.time_left / ability_cd_timer.cooldown)
	#attack_cd_progress.value = 100.0 - (100.0 * attack_cd_timer.time_left / attack_cd_timer.cooldown)

func start() -> void:
	disabled = false
	
	ability_cd_progress.visible = true
	#attack_cd_timer.cooldown = unit_temp_data.attack_cd
	#ability_cd_timer.cooldown = unit_temp_data.ability_cd
	
	if attack_mode:
		start_attack_timer()
	
	start_ability_timer()
	
func stop() -> void:
	disabled = true
	attack_mode = false
	ability_cd_timer.stop()
	attack_cd_timer.stop()
	ability_cd_progress.visible = false

func shift_to_attack_mode() -> void:
	if attack_mode : return
	attack_mode = true
	if disabled : return
	
	start_attack_timer()

func start_attack_timer() -> void:
	var attacks_per_sec = clamp(unit_temp_data.base_attack_speed * (1 + (unit_temp_data.attack_speed / 100.0)), 0.2, 10.0)
	attack_cd_timer.cooldown = 1.0 / attacks_per_sec
	attack_cd_timer.start_timer()
	
func start_ability_timer() -> void:
	var ability_cd = 5.0 * (1.0 / (1 + (unit_temp_data.ability_haste / 100.0))) # 5.0 is filler for base cooldown
	ability_cd_timer.cooldown = ability_cd
	ability_cd_timer.start_timer()

func _on_attack_cd_timer_timeout() -> void:
	if disabled : return
	emit_signal("use_attack")

func _on_ability_cd_timer_timeout() -> void:
	if disabled : return
	ability_ready = true
	emit_signal("use_ability")

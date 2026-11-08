class_name Unit extends Control

signal update_stats_display

signal damage_hero(dmg : DamageSource, target_index : int)
signal damage_enemy(dmg : DamageSource, target_index : int)
signal effect_hero(effect : UnitEffectData, target_index : int)
signal effect_enemy(effect : UnitEffectData, target_index : int)

signal death

var _tween : Tween

var temp_data : UnitData

var max_health := 100 :
	set(value):
		max_health = value
		health_component.max_health = max_health
		update_stats_display.emit()
var current_health := 100 :
	set(value):
		current_health = clampi(value, 0, max_health)
		health_component.health = current_health
		update_stats_display.emit()
		if current_health <= 0:
			handle_death()
var shield := 0:
	set(value):
		shield = maxi(0, value)
		health_component.shield = shield
		update_stats_display.emit()

var attacking := false
var using_ability := false
var attack_ready := false
var ability_ready := false

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var health_component : HealthComponent = $HealthComponent
@onready var cd_component : CDComponent = $CDComponent

func _ready() -> void:
	cd_component.use_attack.connect(use_attack)
	cd_component.use_ability.connect(use_ability)

# called after temp data is set
func initialize() -> void:
	self.max_health = temp_data.health + temp_data.bonus_health
	self.current_health = max_health
	health_component.set_health(max_health)

#----------- LOCALLY DEFINED FOR HERO VS. ENEMY -----------------
func start_combat() -> void:
	pass
	
func stop_combat() -> void:
	pass

func process_attack() -> void:
	pass

func process_ability() -> void:
	pass

#-------------------------
#-------- LOCALLY DEFINED FOR EACH UNIT, FOR SKILLS -------------
func _on_attack_cast() -> void:
	pass
	
func _on_ability_cast() -> void:
	pass

func _on_attack_dmg_dealt(dmg_dealt : int, target_unit : Unit) -> void:
	pass

func _on_ability_dmg_dealt(dmg_dealt : int, target_unit : Unit) -> void:
	pass
	
func _on_damage_taken(amount : int, unmitigated_dmg : DamageSource) -> void:
	pass
	
func _on_death() -> void:
	pass

#---------------------------------------------------------


func use_attack() -> void:
	#print(str(self) + " attack used")
	if attacking or using_ability:
		attack_ready = true
	else:
		attack_ready = false
		attacking = true
		var animation_speed = clamp(temp_data.base_attack_speed * (1 + (temp_data.attack_speed / 100.0)), 1.0, 10.0)
		animation_player.play("attack", -1, animation_speed)
		_on_attack_cast()



# used to cancel animations early if other stuff is ready
func end_attack() -> void:
	attacking = false
	if ability_ready:
		use_ability()
	elif attack_ready:
		use_attack()
	else:
		cd_component.start_attack_timer()

func use_ability() -> void:
	#print(str(self) + " ability used")
	if attacking or using_ability:
		ability_ready = true
	else:
		using_ability = true
		ability_ready = false
		cd_component.ability_ready = false
		animation_player.play("ability")
		_on_ability_cast()
	
# used to mark when ability can be cancelled by another ability
# also marks when mana lock is over
# for ability spam in particulr
func end_ability_early() -> void:
	using_ability = false
	if ability_ready:
		use_ability()
	else:
		cd_component.start_ability_timer()
	
# used to mark when unit can start attacking again
func end_ability() -> void:
	using_ability = false
	if attack_ready:
		use_attack()
	else:
		cd_component.start_attack_timer()

#-------------------------------------------

func handle_death() -> void:
	_on_death()
	cd_component.stop()
	animation_player.play("death")
	emit_signal("death")
	

func take_damage(dmg : DamageSource) -> int:
	var shield_amount = dmg.amount
	shield_amount = int(shield_amount * (100.0 / (100.0 + temp_data.defense)))
	
	# handle damage to shield
	var true_amount = max(shield_amount - shield, 0)
	self.shield -= shield_amount
	
	self.current_health -= true_amount
	if is_instance_valid(dmg.source_unit):
		dmg.source_unit.handle_damage_dealt(true_amount, self)
		
	_on_damage_taken(true_amount, dmg)
		
	return true_amount

# for things like omnivamp
func handle_damage_dealt(amount : int, target_unit : Unit) -> void:
	heal(int(amount * temp_data.omnivamp / 100.0))
	if attacking:
		_on_attack_dmg_dealt(amount, target_unit)
	if using_ability:
		_on_ability_dmg_dealt(amount, target_unit)
	
func heal(amount : int) -> void:
	self.current_health += amount

func receive_effect(effect : UnitEffectData) -> void:
	temp_data.bonus_health += effect.bonus_health
	self.max_health = temp_data.health + temp_data.bonus_health
	self.current_health += effect.bonus_health
	self.shield += effect.shield
	
	temp_data.health_regen += effect.health_regen
	temp_data.defense += effect.defense
	temp_data.attack_speed += effect.attack_speed
	temp_data.attack_power += effect.attack_power
	temp_data.ability_power += effect.ability_power
	temp_data.ability_haste += effect.ability_haste
	temp_data.crit += effect.crit
	temp_data.omnivamp += effect.omnivamp
	
	update_stats_display.emit()

#----------------------------------------------------

func check_attack_mode() -> void:
	if temp_data.position_index <= temp_data.attack_range - 1:
		cd_component.shift_to_attack_mode()

func move_to(p : Vector2, running : bool = false) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	if running:
		animation_player.play("run")
	z_index = 2
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", p, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await _tween.finished
	if running:
		animation_player.play("idle")
	z_index = 0
	return


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("RMB"):
		SignalBus.emit_signal("show_unit_display", self)

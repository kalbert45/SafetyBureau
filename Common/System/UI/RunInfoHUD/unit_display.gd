extends Control

var displayed_unit : Unit

func _ready() -> void:
	SignalBus.show_unit_display.connect(_on_set_unit_display)
	
	$InfoElements.visible = false

# signal emitted by units themselves
func _on_update_stats_display(unit : Unit) -> void:
	if displayed_unit != unit : return
	_on_set_unit_display(unit)

# make sure to add item stats
func _on_set_unit_display(unit : Unit) -> void:
	displayed_unit = unit
	
	#set the unit
	if not displayed_unit:
		$InfoElements.visible = false
		return
	else:
		$InfoElements.visible = true
		if not displayed_unit.is_connected("update_stats_display", _on_update_stats_display):
			displayed_unit.update_stats_display.connect(_on_update_stats_display.bind(displayed_unit))
		
	var data = displayed_unit.temp_data

	
	# set the stats display
	$InfoElements/ProfilePanel/TextureRect.texture = data.unit_profile_tex
	$InfoElements/NameLabel.text = data.unit_name
	$InfoElements/LevelLabel.text = "Lvl " + str(data.level) if unit is Hero else ""
	
	$InfoElements/HealthBar.max_value = unit.max_health
	$InfoElements/HealthBar.value = unit.current_health
	$InfoElements/HealthBar/HealthLabel.text = str(unit.current_health) + " / " + str(unit.max_health)
	
	$InfoElements/ExpBar.visible = unit is Hero
	
	# STATS
	%DefenseContainer.visible = true
	%DefenseLabel.text = str(data.defense)
	
	%HealthRegenContainer.visible = data.health_regen > 0
	%HealthRegenLabel.text = str(data.health_regen)
	
	%AttackContainer.visible = true
	%AttackLabel.text = str(data.attack_power)
	
	%SkillPowerContainer.visible = true
	%SkillPowerLabel.text = str(data.ability_power)
	
	%AttackSpeedContainer.visible = true
	%AttackSpeedLabel.text = str(data.attack_speed)
	
	%SkillHasteContainer.visible = data.ability_haste > 0
	%SkillHasteLabel.text = str(data.ability_haste)
	
	%CritContainer.visible = data.crit > 0
	%CritLabel.text = str(data.crit)
	
	%OmnivampContainer.visible = data.omnivamp > 0
	%OmnivampLabel.text = str(data.omnivamp)
	
	%AttackRangeContainer.visible = true
	%AttackRangeLabel.text = str(data.attack_range)
		

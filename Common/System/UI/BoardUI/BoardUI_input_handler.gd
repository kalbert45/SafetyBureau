extends Node

signal arrange_heroes(exception : Hero)
signal snap_hero(hero : Hero)

var HERO_ARR : Array[Hero] = []

var _clicked_unit : Unit
var _hovered_unit : Unit

var hero_held := false

var clicked_p := Vector2.ZERO
var holding_click := false

var disabled := false

func _on_hero_board_slot_mouse_entered(slot : BoardSlot) -> void:
	if disabled : return
	if not hero_held : return
	if not _hovered_unit is Hero: return
	if slot.is_occupied():
		var hero = slot.get_unit()
		if (_hovered_unit != hero):
			var new_index = HERO_ARR.find(hero)
			HERO_ARR.erase(_hovered_unit)
			HERO_ARR.insert(new_index, _hovered_unit)
			emit_signal("arrange_heroes", _hovered_unit)
	else:
		HERO_ARR.erase(_hovered_unit)
		HERO_ARR.insert(slot.index, _hovered_unit)
		emit_signal("arrange_heroes", _hovered_unit)

func _on_unit_mouse_entered(unit : Unit) -> void:
	if disabled : return
	if hero_held : return
	_hovered_unit = unit
	
func _on_unit_mouse_exited(unit : Unit) -> void:
	if disabled : return
	if hero_held : return
	if is_instance_valid(_hovered_unit):
		if unit is Hero and not hero_held and Input.is_action_pressed("LMB") and holding_click:
			_hold_hero()
	
func _on_unit_gui_event(event : InputEvent, unit : Unit) -> void:
	if disabled : return
	if hero_held : return
	if event.is_action_released("LMB"):
		holding_click = false
		
	elif event.is_action_pressed("LMB"):
		if unit == _hovered_unit:
			_clicked_unit = _hovered_unit
			_hovered_unit.accept_event()
			holding_click = true
			clicked_p = event.position

func _input(event: InputEvent) -> void:
	if disabled : return
	if event.is_action_released("LMB"):
		holding_click = false
		_drop_hero()

func _hold_hero() -> void:
	if disabled : return
	if not is_instance_valid(_hovered_unit) : return
	if not is_instance_valid(_clicked_unit) : return
	
	holding_click = false
	hero_held = true
	
	_hovered_unit.update_held_status(true)
	
func _drop_hero() -> void:
	if disabled : return
	if not hero_held : return
	
	_hovered_unit.accept_event()
	holding_click = false
	hero_held = false
	
	_hovered_unit.update_held_status(false)
	
	emit_signal("arrange_heroes", _hovered_unit)
	emit_signal("snap_hero", _hovered_unit)

func _process(_delta: float) -> void:
	if disabled : return
	if not hero_held : return
	if not _hovered_unit is Hero: return
	
	var mouse_p = get_viewport().get_mouse_position()
	mouse_p.x = clamp(mouse_p.x, 0.0, get_viewport().get_visible_rect().size.x)
	mouse_p.y = clamp(mouse_p.y, 0.0, get_viewport().get_visible_rect().size.y)
	_hovered_unit.global_position = mouse_p - Vector2(23.0, 23.0)

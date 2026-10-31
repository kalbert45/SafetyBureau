class_name ItemUIHandler extends Node

const DRAG_REGISTER_DIST = 1.0

var UI_DISABLED := false

var item_held := false
var held_item_slot : ItemSlot = null

var _hovered_slot : ItemSlot
var _clicked_slot : ItemSlot

var clicked_p := Vector2.ZERO
var holding_click := false

func _ready() -> void:
	SignalBus.item_slot_hovered.connect(_on_item_slot_hovered)
	SignalBus.item_slot_gui_input.connect(_on_item_slot_gui_input)

func _process(delta: float) -> void:
	if not item_held: return
	if not held_item_slot : return
	
	var mouse_p = get_viewport().get_mouse_position()
	mouse_p.x = clamp(mouse_p.x, 0.0, get_viewport().get_visible_rect().size.x)
	mouse_p.y = clamp(mouse_p.y, 0.0, get_viewport().get_visible_rect().size.y)
	held_item_slot.item_tex.global_position = mouse_p - Vector2(8, 8)
	
func _input(event: InputEvent) -> void:
	if UI_DISABLED : return
	
	if event.is_action_released("LMB"):
		holding_click = false
		drop_item()

func _on_item_slot_hovered(slot : ItemSlot, on : bool) -> void:
	if UI_DISABLED : return
	if on:
		_hovered_slot = slot
	else:
		if slot == _hovered_slot:
			_hovered_slot = null
	
func _on_item_slot_gui_input(slot : ItemSlot, event : InputEvent) -> void:
	if UI_DISABLED : return
	if item_held : return
	if event.is_action_released("LMB"):
		holding_click = false
	elif event.is_action_pressed("LMB"):
		if slot == _hovered_slot:
			# do not want to do anything to empty slots
			if slot.is_occupied():
				_clicked_slot = _hovered_slot
				_hovered_slot.accept_event()
				holding_click = true
				clicked_p = event.position

	if event is InputEventMouse and holding_click and clicked_p.distance_to(event.position) > DRAG_REGISTER_DIST:
		if is_instance_valid(_clicked_slot):
			if _clicked_slot.is_occupied():
				if not item_held:
					hold_item()

func hold_item() -> void:
	if UI_DISABLED : return
	if not is_instance_valid(_hovered_slot) : return
	if not is_instance_valid(_clicked_slot) : return
	
	holding_click = false
	item_held = true
	held_item_slot = _clicked_slot
	held_item_slot.item_tex.z_index = 1
	
func drop_item() -> void:
	if UI_DISABLED : return
	if not item_held : return
	if not held_item_slot : return
	
	holding_click = false
	item_held = false
	
	if is_instance_valid(_hovered_slot) and _hovered_slot != _clicked_slot:
		if not _hovered_slot.read_only:
			_clicked_slot.swap_with_slot(_hovered_slot)
			
	held_item_slot.item_tex.position = Vector2.ZERO
	held_item_slot.item_tex.z_index = 0
	held_item_slot = null

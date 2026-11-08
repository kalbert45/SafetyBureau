class_name ItemSlot extends Control

signal item_set

@export var read_only := false

var disabled := false
@export var current_item_data : ItemData

@onready var item_tex := $ItemTex

func _ready() -> void:
	if current_item_data:
		set_item(current_item_data)

func set_item(data : ItemData) -> void:
	current_item_data = data
	if data:
		item_tex.texture = data.item_texture
	else:
		item_tex.texture = null
	emit_signal("item_set")

func pop_item() -> ItemData:
	var data = current_item_data
	current_item_data = null
	return data

func swap_with_slot(other_slot : ItemSlot) -> void:
	var other_item_data = other_slot.current_item_data
	
	other_slot.set_item(current_item_data)
	set_item(other_item_data)
	
func is_occupied() -> bool:
	return current_item_data != null


func _on_mouse_entered() -> void:
	if read_only : return
	SignalBus.item_slot_hovered.emit(self, true)
	$HoverPanel.visible = true


func _on_mouse_exited() -> void:
	if read_only : return
	SignalBus.item_slot_hovered.emit(self, false)
	$HoverPanel.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if read_only : return
	SignalBus.item_slot_gui_input.emit(self, event)

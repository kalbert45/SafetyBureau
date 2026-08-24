class_name BoardSlot extends Control

@export var index := 0

func is_occupied() -> bool:
	return $Slot.get_child_count() != 0

func set_unit(unit : Unit) -> void:
	$Slot.add_child(unit)

func get_unit() -> Unit:
	return $Slot.get_child(0)

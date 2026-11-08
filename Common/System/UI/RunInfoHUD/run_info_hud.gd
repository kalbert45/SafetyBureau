extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		SignalBus.emit_signal("show_unit_display", null)

#func _on_rich_text_label_mouse_entered() -> void:
	#SignalBus.emit_signal( "show_text_tooltip", $RichTextLabel/Marker2D.global_position, "Money", false)
	#
#
#
#
#func _on_rich_text_label_mouse_exited() -> void:
	#SignalBus.emit_signal("hide_all_tooltips")

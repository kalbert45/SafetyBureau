extends Control

func _ready() -> void:
	pass
	#SignalBus.show_text_tooltip.connect(_on_show_text_tooltip)
	
func _on_show_text_tooltip(global_p : Vector2, text : String, _bottom_anchor : bool) -> void:
	%Tooltip.global_position = global_p * 3 # need to scale up position
	%Tooltip.set_text(text)
	%Tooltip.visible = true

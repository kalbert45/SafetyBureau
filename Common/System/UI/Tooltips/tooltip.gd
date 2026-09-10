extends Control

func _ready() -> void:
	SignalBus.hide_all_tooltips.connect(_on_hide_all_tooltips)

func set_text(text : String) -> void:
	$PanelContainer/RichTextLabel.text = text

func _on_hide_all_tooltips() -> void:
	hide()

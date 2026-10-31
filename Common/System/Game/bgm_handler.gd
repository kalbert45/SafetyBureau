extends Node

func _ready() -> void:
	SignalBus.begin_combat.connect(_on_begin_combat)
	SignalBus.end_combat.connect(_on_end_combat)
	
	# TEMP
	Bgm.fade_to_new_ambience("wind_ambience.ogg")
	
	Bgm.chained = true
	Bgm.chained_track_path = "preparation_cool.ogg"
	Bgm.crossfade_bgm("preparation_cool.ogg")
	
func _on_begin_combat() -> void:
	Bgm.crossfade_bgm("battle_theme.ogg")
	
func _on_end_combat() -> void:
	Bgm.crossfade_bgm("preparation_cool.ogg")

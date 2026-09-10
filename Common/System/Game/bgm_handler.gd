extends Node

func _ready() -> void:
	SignalBus.begin_combat.connect(_on_begin_combat)
	SignalBus.end_combat.connect(_on_end_combat)
	
	# TEMP
	Bgm.fade_to_new_ambience("wind_ambience.ogg")
	
	Bgm.chained = true
	Bgm.chained_track_path = "tense_theme.ogg"
	Bgm.crossfade_bgm("tense_theme.ogg")
	
func _on_begin_combat() -> void:
	Bgm.crossfade_bgm("battle_theme.ogg")
	
func _on_end_combat() -> void:
	Bgm.crossfade_bgm("tense_theme.ogg")

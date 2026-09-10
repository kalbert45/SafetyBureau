extends Node

const BGM_DB := -8.0
const AMBIENCE_DB := -4.0

# REQUIRED FUNCTIONALITY
# crossfading bgms
# ducking ambience
# fading out then fading ambience back in

@export var MUTED := false

var _bgm_tween : Tween
var _ambience_tween : Tween

var chained := false
var chained_track_path := ""

var playback_position := 0.0

@onready var ambience_track := $Ambience
@onready var bgm_track1 := $BgmTrack1
@onready var bgm_track2 := $BgmTrack2

#------------ BGM ------------------------------
func crossfade_bgm(new_bgm_path, fade_time = 1.0, gap_time = 0.5, _keep_loop_position = false) -> void:
	if MUTED : return
	var current_track = bgm_track1 if bgm_track1.playing else bgm_track2
	var new_track = bgm_track2 if bgm_track1.playing else bgm_track1
	
	#bgm_track1.get_playback_position()
	
	new_track.stream = load("res://Assets/Sounds/BGM/" + new_bgm_path)
	new_track.volume_db = -40.0
	new_track.play(playback_position)
	
	if _bgm_tween and _bgm_tween.is_running():
		_bgm_tween.kill()
		
	_bgm_tween = get_tree().create_tween().set_parallel(true)
	_bgm_tween.tween_property(current_track, "volume_db", -40.0, fade_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_bgm_tween.tween_property(new_track, "volume_db", BGM_DB, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_delay(gap_time)

	await _bgm_tween.finished
	playback_position = current_track.get_playback_position()
	current_track.stop()

func fade_out_bgm(fade_time = 2.0) -> void:
	if MUTED : return
	var current_track = bgm_track1 if bgm_track1.playing else bgm_track2
	
	if _bgm_tween and _bgm_tween.is_running():
		_bgm_tween.kill()
	if _ambience_tween and _ambience_tween.is_running():
		_ambience_tween.kill()
		
	_bgm_tween = get_tree().create_tween()
	_ambience_tween = get_tree().create_tween()
	
	_bgm_tween.tween_property(current_track, "volume_db", -80.0, fade_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_ambience_tween.tween_property(ambience_track, "volume_db", 0.0, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
func fade_in_bgm(fade_time = 2.0) -> void:
	if MUTED : return
	var current_track = bgm_track1 if bgm_track1.playing else bgm_track2

	if _bgm_tween and _bgm_tween.is_running():
		_bgm_tween.kill()
	if _ambience_tween and _ambience_tween.is_running():
		_ambience_tween.kill()
		
	_bgm_tween = get_tree().create_tween()
	_ambience_tween = get_tree().create_tween()
	
	_bgm_tween.tween_property(current_track, "volume_db", BGM_DB, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_ambience_tween.tween_property(ambience_track, "volume_db", AMBIENCE_DB, fade_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

#------------ Ambience -------------------------------
func fade_to_new_ambience(new_ambience_path, fade_time = 4.0, gap_time = 0.5) -> void:
	if MUTED : return
	if _ambience_tween and _ambience_tween.is_running():
		_ambience_tween.kill()
		
	_ambience_tween = get_tree().create_tween()
		
	_ambience_tween.tween_property(ambience_track, "volume_db", -40.0, fade_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_ambience_tween.tween_callback(ambience_track.set_stream.bind(load("res://Assets/Sounds/Ambience/" + new_ambience_path)))
	_ambience_tween.tween_callback(ambience_track.play)
	_ambience_tween.tween_property(ambience_track, "volume_db", AMBIENCE_DB, fade_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_delay(gap_time)


#--------------------------------------------------------
#-------- handle chained tracks for looping -----------------
#-------------------------------------------------

func _on_bgm_track_1_finished() -> void:
	if MUTED : return
	if not chained : return
	chained = false
	bgm_track1.stream = load("res://Assets/Sounds/BGM/" + chained_track_path)
	bgm_track1.play()

func _on_bgm_track_2_finished() -> void:
	if MUTED : return
	if not chained : return
	chained = false
	bgm_track2.stream = load("res://Assets/Sounds/BGM/" + chained_track_path)

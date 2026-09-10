class_name CombatRoom extends Room

func _ready() -> void:
	SignalBus.begin_combat.connect(_on_begin_combat)
	SignalBus.end_combat.connect(_on_end_combat)

# initialization
func enter(_data : RoomData) -> void:
	pass
	#Bgm.fade_out_bgm()
	
# cleanup
func exit() -> void:
	emit_signal("exit_room", RoomData.ROOM_TYPE.NULL)


#----------------------------------------

func _on_begin_combat() -> void:
	$Env/BlackBars/AnimationPlayer.play("narrow_bars")
	
func _on_end_combat() -> void:
	await get_tree().create_timer(3.0).timeout
	exit()

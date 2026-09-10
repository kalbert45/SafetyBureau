class_name DoorRoom extends Room

# initialization
func enter(_data : RoomData) -> void:
	pass
	
# cleanup
func exit() -> void:
	emit_signal("exit_room", RoomData.ROOM_TYPE.COMBAT)


func _on_button_pressed() -> void:
	exit()

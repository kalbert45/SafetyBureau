class_name Room extends Control

signal exit_room(new_room : RoomData.ROOM_TYPE)

# initialization
func enter(_data : RoomData) -> void:
	pass
	
# cleanup
func exit() -> void:
	pass

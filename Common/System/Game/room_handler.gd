extends Control

const ROOM_PATHS = {
	RoomData.ROOM_TYPE.INITIAL : "res://Common/Rooms/Initial/InitialRoom.tscn",
	RoomData.ROOM_TYPE.DOOR : "res://Common/Rooms/Door/DoorRoom.tscn",
	RoomData.ROOM_TYPE.COMBAT : "res://Common/Rooms/Combat/CombatRoom.tscn",
}

var current_room : Room

func _ready() -> void:
	current_room = $InitialRoom
	current_room.enter(null)
	
	current_room.exit_room.connect(_on_exit_room)
	
func _on_exit_room(new_room_type : RoomData.ROOM_TYPE) -> void:
	if current_room:
		current_room.queue_free()
	
	var new_room : Room
	if new_room_type != RoomData.ROOM_TYPE.NULL:
		# TODO load roomdata from generator and from overworld path
		new_room = load(ROOM_PATHS[new_room_type]).instantiate()
		add_child(new_room)
		current_room = new_room
		new_room.enter(null)
		
		print("entering room : " + str(RoomData.ROOM_TYPE.keys()[new_room_type]))
	else:
		# for now, just load door room
		new_room = load(ROOM_PATHS[RoomData.ROOM_TYPE.DOOR]).instantiate()
		add_child(new_room)
		current_room = new_room
		new_room.enter(null)

		print("entering door room")
		
	new_room.exit_room.connect(_on_exit_room)

class_name RoomData extends Resource

# should contain all data required to display a door for a room
# should contain all data required to initialize a room

enum ROOM_TYPE {
	NULL,
	INITIAL, DOOR, 
	LEVEL, ELITE, BOSS,
	ARTIFACT_SHOP, ARCANA_SHOP
	}


@export var room_type : ROOM_TYPE

# elite debuff here

func _init(_room_type : ROOM_TYPE) -> void:
	room_type = _room_type

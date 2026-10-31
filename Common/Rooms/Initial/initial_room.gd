class_name InitialRoom extends Room

# starting bonuses and starting hero

# initialization
func enter(_data : RoomData) -> void:
	var random_hero_pool = Generator.get_hero_pool(1, [], 0)
	var random_hero_data = random_hero_pool[0]
	GameState.HERO_DATA_ARR.append(random_hero_data.duplicate())
	GameState.HERO_DATA_ARR.append(random_hero_data.duplicate())
	
# cleanup
func exit() -> void:
	emit_signal("exit_room", RoomData.ROOM_TYPE.NULL)


func _on_button_pressed() -> void:
	exit()

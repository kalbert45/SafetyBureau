extends Node

enum ROOM_CATEGORY {BATTLE, CHALLENGE, SHOP, RANDOM}

const CATEGORY_WEIGHTS := {
	ROOM_CATEGORY.BATTLE : 1,
	ROOM_CATEGORY.CHALLENGE : 1,
	ROOM_CATEGORY.SHOP : 1,
	ROOM_CATEGORY.RANDOM : 1,
}

const ROOM_WEIGHTS := {
	RoomData.ROOM_TYPE.COMBAT : 1,
	RoomData.ROOM_TYPE.ELITE : 0.5,
	RoomData.ROOM_TYPE.ARTIFACT_SHOP : 1,
	RoomData.ROOM_TYPE.ARCANA_SHOP : 1
}

#-------------- ROOM GENERATION --------------------------------

# odd round, guarantee enemy
# even round, guarantee shop
# round 12, boss room
# disallow 2 of the same room type
# 33% battle, 33% shop, 33% hidden
func get_rooms_pool(round : int, num_rooms : int) -> Array[RoomData]:
	var room_data_pool : Array[RoomData] = []
	var room_type_pool : Array[RoomData.ROOM_TYPE] = []
	var category_pool : Array[ROOM_CATEGORY] = []
	if round == GameState.NUM_ROUNDS:
		room_type_pool.append(RoomData.ROOM_TYPE.BOSS)
	elif round % 2 == 0:
		category_pool.append(ROOM_CATEGORY.SHOP)
	else:
		category_pool.append(ROOM_CATEGORY.BATTLE)
		
	for i in range(num_rooms - 1):
		category_pool.append(_get_random_room_category())
		
	for cat in category_pool:
		room_type_pool.append(_get_random_room_type(cat, room_type_pool))
		
	for i in room_type_pool.size():
		if room_type_pool[i] != RoomData.ROOM_TYPE.NULL:
			room_data_pool.append(_create_room_data(round, room_type_pool[i], category_pool[i]))
	
	room_data_pool.shuffle()
	
	return room_data_pool

func _get_random_room_category() -> ROOM_CATEGORY:
	var categories = CATEGORY_WEIGHTS.keys()
	var weights = CATEGORY_WEIGHTS.values()
	
	var rng = RandomNumberGenerator.new()
	
	return categories[rng.rand_weighted(weights)]


func _get_random_room_type(cat : ROOM_CATEGORY, existing_pool : Array[RoomData.ROOM_TYPE]) -> RoomData.ROOM_TYPE:
	var room_type_pool : Array[RoomData.ROOM_TYPE]
	var weights : Array[float]
	match cat:
		ROOM_CATEGORY.BATTLE:
			room_type_pool = [
				RoomData.ROOM_TYPE.COMBAT,
				RoomData.ROOM_TYPE.ELITE,
			]
		ROOM_CATEGORY.SHOP:
			room_type_pool = [
				RoomData.ROOM_TYPE.ARTIFACT_SHOP,
				RoomData.ROOM_TYPE.ARCANA_SHOP,
			]
		ROOM_CATEGORY.RANDOM:
			room_type_pool = [
				RoomData.ROOM_TYPE.COMBAT,
				RoomData.ROOM_TYPE.ELITE,
				RoomData.ROOM_TYPE.ARTIFACT_SHOP,
				RoomData.ROOM_TYPE.ARCANA_SHOP,
			]
	for type in existing_pool:
		room_type_pool.erase(type)
	for type in room_type_pool:
		weights.append(ROOM_WEIGHTS[type])
	
	if room_type_pool.is_empty():
		return RoomData.ROOM_TYPE.NULL
	
	var rng = RandomNumberGenerator.new()
	return room_type_pool[rng.rand_weighted(weights)]
	
# TODO : elite debuffs, boss handling, maybe some other stuff idk
func _create_room_data(round : int, room_type : RoomData.ROOM_TYPE, category : ROOM_CATEGORY) -> RoomData:
	var data = RoomData.new(room_type)
	
	if category == ROOM_CATEGORY.RANDOM:
		data.hidden = true
		
	if room_type == RoomData.ROOM_TYPE.COMBAT or room_type == RoomData.ROOM_TYPE.ELITE \
		or room_type == RoomData.ROOM_TYPE.BOSS:
		pass
	
	return data

#------------------------------------------------------------

const ALL_HERO_DATA_RESOURCE = preload("res://Entities/Units/Heroes/ALL_HERO_DATA.tres")
const ALL_ENEMY_DATA_RESOURCE = preload("res://Entities/Units/Enemies/ALL_ENEMY_DATA.tres")

var _all_hero_data : Array[HeroData]
var _all_enemy_data : Array[EnemyData]

func _ready() -> void:
	ALL_HERO_DATA_RESOURCE.load_all_into(_all_hero_data)
	ALL_ENEMY_DATA_RESOURCE.load_all_into(_all_enemy_data)

func get_hero_pool(num_cards : int, tier_range : Array[int], tag_flags : int) -> Array[HeroData]:
	# TODO filter
	var all_heroes = _all_hero_data
	var filtered_cards = all_heroes.filter(_filter_hero_method.bind(tier_range, tag_flags))
	filtered_cards.shuffle()
	
	return filtered_cards.slice(0, num_cards)
	
func _filter_hero_method(data : HeroData, tier_range : Array[int], tag_flags : int) -> bool:
	return true

#----------------------------------------------------------------

func get_artifacts_pool(num_artifacts : int, tier_range : Array[int], tag_flags : int) -> Array:
	return []
	
func _filter_artifact_method(data : HeroData, tier_range : Array[int], tag_flags : int) -> bool:
	return false

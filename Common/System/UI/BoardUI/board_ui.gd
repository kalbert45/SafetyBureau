class_name BoardUI extends Control

@onready var input_handler = $InputHandler
@onready var combat_handler = $CombatHandler

var HERO_ARR : Array[Hero] = [] # front of array is backline
var ENEMY_ARR : Array[Enemy] = [] # front of array is frontline

func _ready() -> void:
	input_handler.arrange_heroes.connect(_on_arrange_heroes)
	input_handler.snap_hero.connect(_on_snap_hero)
	
	for board_slot : BoardSlot in %HeroSlotContainer.get_children():
		board_slot.mouse_entered.connect(input_handler._on_hero_board_slot_mouse_entered.bind(board_slot))
	
	HERO_ARR.resize(Constants.NUM_HERO_SLOTS)
	ENEMY_ARR.resize(Constants.NUM_ENEMY_SLOTS)
	
	input_handler.HERO_ARR = HERO_ARR
	
	combat_handler.HERO_ARR = HERO_ARR
	combat_handler.ENEMY_ARR = ENEMY_ARR
	
	# instantiate units based on data
	for hero_data : HeroData in GameState.HERO_DATA_ARR:
		var hero : Hero = load(hero_data.HERO_SCENE_PATHS[hero_data.hero_enum]).instantiate()
		hero.data = hero_data
		hero.data.position_index = GameState.HERO_DATA_ARR.find(hero_data)
		%HeroContainer.add_child(hero)
	
	# then, setup units
	await get_tree().process_frame
	await get_tree().process_frame
	setup_units()

func _on_arrange_heroes(exception : Hero = null) -> void:
	for i in range(HERO_ARR.size()):
		if not is_instance_valid(HERO_ARR[i]) : continue
		if HERO_ARR[i] == exception : continue
		HERO_ARR[i].move_to(%HeroSlotContainer.get_child(i).global_position - global_position)
		HERO_ARR[i].data.position_index = i
		HERO_ARR[i].temp_data.position_index = i
		
func _on_snap_hero(hero : Hero) -> void:
	var index = HERO_ARR.find(hero)
	if index < 0 : return
	hero.position = %HeroSlotContainer.get_child(index).global_position - global_position
	hero.data.position_index = index
	hero.temp_data.position_index = index

func setup_units() -> void:
	for unit in get_tree().get_nodes_in_group("Units"):
		unit.mouse_entered.connect(input_handler._on_unit_mouse_entered.bind(unit))
		unit.mouse_exited.connect(input_handler._on_unit_mouse_exited.bind(unit))
		unit.gui_input.connect(input_handler._on_unit_gui_event.bind(unit))
		
		if unit is Hero:
			HERO_ARR[unit.data.position_index] = unit
			unit.position = %HeroSlotContainer.get_child(unit.data.position_index).global_position - global_position
			
			
		elif unit is Enemy:
			ENEMY_ARR[unit.data.position_index] = unit

func initiate_combat() -> void:
	input_handler.disabled = true
	combat_handler.handle_combat()
	

func _on_start_combat_button_pressed() -> void:
	SignalBus.begin_combat.emit()
	initiate_combat()
	$StartCombatButton.visible = false

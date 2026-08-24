class_name BoardUI extends Control

@onready var input_handler = $InputHandler
@onready var combat_handler = $CombatHandler

var HERO_ARR : Array[Hero] = [] # front of array is backline
var ENEMY_ARR : Array[Enemy] = [] # front of array is frontline

func _ready() -> void:
	input_handler.arrange_heroes.connect(_on_arrange_heroes)
	
	for board_slot : BoardSlot in %HeroSlotContainer.get_children():
		board_slot.mouse_entered.connect(input_handler._on_hero_board_slot_mouse_entered.bind(board_slot))
	
	HERO_ARR.resize(Constants.NUM_HERO_SLOTS)
	ENEMY_ARR.resize(Constants.NUM_ENEMY_SLOTS)
	
	input_handler.HERO_ARR = HERO_ARR
	
	combat_handler.HERO_ARR = HERO_ARR
	combat_handler.ENEMY_ARR = ENEMY_ARR
	
	# instantiate units based on data
	
	# then, setup units
	setup_units()

func _on_arrange_heroes(exception : Hero = null) -> void:
	for i in range(HERO_ARR.size()):
		if not is_instance_valid(HERO_ARR[i]) : continue
		if HERO_ARR[i] == exception : continue
		HERO_ARR[i].move_to(%HeroSlotContainer.get_child(i).global_position - global_position)
		HERO_ARR[i].data.position_index = i

func setup_units() -> void:
	for unit in get_tree().get_nodes_in_group("Units"):
		unit.mouse_entered.connect(input_handler._on_unit_mouse_entered.bind(unit))
		unit.mouse_exited.connect(input_handler._on_unit_mouse_exited.bind(unit))
		unit.gui_input.connect(input_handler._on_unit_gui_event.bind(unit))
		
		if unit is Hero:
			HERO_ARR[unit.data.position_index] = unit
			
		elif unit is Enemy:
			ENEMY_ARR[unit.data.position_index] = unit

func initiate_combat() -> void:
	input_handler.disabled = true
	combat_handler.handle_combat()
	
	


func _on_start_combat_button_pressed() -> void:
	initiate_combat()

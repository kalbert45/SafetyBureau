class_name Item extends Node

enum ITEM_ENUM {
	
}

@export var target_hero : Hero
@export var data : ItemData
@export var item_enum : ITEM_ENUM

# on ready, add all stats to the unit

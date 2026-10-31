class_name HeroData extends UnitData

enum HERO_NAMES {
	JOSEPHINE, SIG,
}

const HERO_SCENE_PATHS = {
	HERO_NAMES.JOSEPHINE : "res://Entities/Units/Heroes/Josephine/josephine.tscn",
	HERO_NAMES.SIG : "res://Entities/Units/Heroes/Sig/sig.tscn",
}

@export var hero_enum := HERO_NAMES.JOSEPHINE

@export var num_item_slots := 1
@export var items : Array = []
@export var level := 1
@export var experience := 0

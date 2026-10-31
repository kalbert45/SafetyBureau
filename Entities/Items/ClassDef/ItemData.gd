class_name ItemData extends Resource

@export var item_name : String
@export var item_texture : Texture2D # 17 x 17

@export_category("STATS")
@export var health := 1000
@export var health_regen := 0
@export var defense := 0

@export var attack_speed := 0.25
@export var attack_power := 0
@export var attack_range := 1

@export var ability_power := 0
@export var ability_haste := 0

@export var crit := 0
@export var omnivamp := 0

@export_category("SPECIAL")

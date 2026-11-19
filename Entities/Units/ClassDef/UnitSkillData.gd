class_name UnitSkillData extends Resource

enum SKILL_LABEL {
	NIL = 0,
	BASE = 1,
	SKILL_1 = 2, SKILL_2 = 3, SKILL_3 = 4,
	SKILL_1_UPGRADED = 5, SKILL_2_UPGRADED = 6, SKILL_3_UPGRADED = 7,
	
	DEFENSIVE = 10,
	ROBUST = 11,
	LUCKY = 12,
	SHIELDING = 13,
	SPECIALTY = 14,
	CASTING = 15,
	ATTACKING = 16,
	AFFLICTING = 17,
}

enum SKILL_TYPE {
	PASSIVE,
	ACTIVE,
}

const ENCHANTMENT_TEXTURES = {
	SKILL_LABEL.DEFENSIVE : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.ROBUST : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.LUCKY : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.SHIELDING : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.SPECIALTY : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.CASTING : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.ATTACKING : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
	SKILL_LABEL.AFFLICTING : preload("res://Entities/Units/Heroes/Josephine/T_Josephine_Skill1.png"),
}

@export var activated_skills : Array[SKILL_LABEL] = []

# HEROES MUST HAVE ALL SKILL ENUMS DEFINED
# ENEMIES MAY HAVE JUST A FEW DEFINED
@export var skill_name_dict : Dictionary[SKILL_LABEL, String] = {}
@export var skill_type_dict : Dictionary[SKILL_LABEL, SKILL_TYPE] = {}
@export var skill_cd_dict : Dictionary[SKILL_LABEL, float] = {} # for active skills only
@export var skill_tooltip_dict : Dictionary[SKILL_LABEL, String] = {}
# NON ENCHANTMENT ONLY
@export var skill_texture_dict : Dictionary[SKILL_LABEL, Texture2D] = {}


func get_skill_texture(skill : SKILL_LABEL) -> Texture2D:
	if skill < 10:
		return skill_texture_dict.get(skill)
	else:
		return ENCHANTMENT_TEXTURES.get(skill)

func has_active_skill() -> bool:
	for skill in activated_skills:
		if skill_type_dict.get(skill) == SKILL_TYPE.ACTIVE:
			return true
	return false

func get_active_skill() -> SKILL_LABEL:
	for skill in activated_skills:
		if skill_type_dict.get(skill) == SKILL_TYPE.ACTIVE:
			return skill
	return SKILL_LABEL.NIL
	
func get_active_skill_cd() -> float:
	var active_skill = get_active_skill()
	if active_skill != SKILL_LABEL.NIL:
		return skill_cd_dict.get(active_skill)
	else:
		return -1.0

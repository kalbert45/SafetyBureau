class_name UnitSkillData extends Resource

enum SKILL_LABEL {
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

@export var activated_skills : Array[SKILL_LABEL] = []

# HEROES MUST HAVE ALL SKILL ENUMS DEFINED
# ENEMIES MAY HAVE JUST A FEW DEFINED
@export var skill_name_dict : Dictionary[SKILL_LABEL, String] = {}
@export var skill_type_dict : Dictionary[SKILL_LABEL, SKILL_TYPE] = {}
@export var skill_tooltip_dict : Dictionary[SKILL_LABEL, String] = {}
@export var skill_texture_dict : Dictionary[SKILL_LABEL, String] = {}

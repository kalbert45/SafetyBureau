class_name EnemyData extends UnitData


func replicate() -> EnemyData:
	var new_data = self.duplicate()
	new_data.skill_data = skill_data
	
	return new_data

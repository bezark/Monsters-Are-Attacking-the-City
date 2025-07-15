extends CSGBox3D


func floating():
	var dest = randf_range(-1.0,1.0)
	var float_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	float_tween.tween_property( self, "position", Vector3(position.x,dest,position.z), 3.0)
	float_tween.tween_callback(floating)
	

func _ready() -> void:
	floating()

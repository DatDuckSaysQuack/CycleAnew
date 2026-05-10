extends Node3D
class_name Barrier

var health := 15.0

func setup(p:Vector3) -> void:
	global_position = Vector3(p.x,1.0,p.z)
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new(); bm.size = Vector3(1.5,2.5,1.5); mi.mesh = bm
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(0.7,0.9,1,0.45); mat.emission_enabled = true; mat.emission = Color(0.5,0.8,1); mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mi.material_override = mat
	add_child(mi)

func _process(delta: float) -> void:
	health -= delta
	if health <= 0: queue_free()

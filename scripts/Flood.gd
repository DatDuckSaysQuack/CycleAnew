extends Node3D
class_name Flood

var speed := 2.0
var slow_power := 0.0
var frozen := false

func setup(p:Vector3) -> void:
	global_position = p
	var wall := MeshInstance3D.new(); wall.name = "Wall"
	var bm := BoxMesh.new(); bm.size = Vector3(2,8,40); wall.mesh = bm
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(0.2,0.5,1,0.55); mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	wall.material_override = mat
	add_child(wall)

func _process(delta: float) -> void:
	if frozen: return
	global_position.x += max(0.2, speed - slow_power) * delta
	slow_power = max(0.0, slow_power - 0.05 * delta)

func freeze_wall() -> void:
	frozen = true

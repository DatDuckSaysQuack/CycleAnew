extends CharacterBody3D
class_name Villager

var kind := "human"
var alive := true
var conflict := 0.0
var target := Vector3.ZERO
var speed := 2.0
var mesh_root: Node3D

func setup(k:String, center:Vector3) -> void:
	kind = k
	target = center
	mesh_root = Node3D.new(); add_child(mesh_root)
	if kind == "human":
		_add_part(CapsuleMesh.new(), Color(0.9,0.84,0.76), Vector3(0,1,0), Vector3(0.6,1,0.6))
	else:
		_add_part(CapsuleMesh.new(), Color(0.12,0.04,0.2), Vector3(0,1.1,0), Vector3(0.45,1.2,0.45))
		_add_part(BoxMesh.new(), Color(0.18,0.06,0.24), Vector3(0,0.5,-0.7), Vector3(0.25,0.15,1.2))

func _physics_process(delta: float) -> void:
	if not alive: return
	if global_position.distance_to(target) < 0.8:
		target = Vector3(randf_range(-15,15),0,randf_range(-15,15))
	velocity = (target - global_position).normalized() * speed
	move_and_slide()

func receive_reconciliation() -> void:
	speed = 1.8

func flee_from(p:Vector3) -> void:
	target = global_position + (global_position - p).normalized() * 8.0

func base_form() -> void:
	for c in mesh_root.get_children(): c.queue_free()
	_add_part(CapsuleMesh.new(), Color(1.0,0.95,0.75,0.9), Vector3(0,1,0), Vector3(0.45,1,0.45))

func _add_part(mesh:Mesh, color:Color, p:Vector3, s:Vector3) -> void:
	var mi := MeshInstance3D.new(); mi.mesh = mesh; mi.position = p; mi.scale = s
	var mat := StandardMaterial3D.new(); mat.albedo_color = color; mat.emission_enabled = color.a < 1.0; mat.emission = color
	mi.material_override = mat; mesh_root.add_child(mi)

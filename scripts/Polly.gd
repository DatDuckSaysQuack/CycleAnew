extends CharacterBody3D
class_name Polly

var ball: Node3D
var rock: Node3D
var bed: Node3D
var carry := false
var target := Vector3.ZERO
var on_rock := false

func setup(b:Node3D, r:Node3D, bed_node:Node3D) -> void:
	ball = b
	rock = r
	bed = bed_node
	var body := MeshInstance3D.new(); var bm := CapsuleMesh.new(); body.mesh = bm; body.scale = Vector3(0.35,0.45,0.35); body.position.y = 0.45
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color.WHITE; body.material_override = mat; add_child(body)
	var lbl := Label3D.new(); lbl.text = "Polly"; lbl.position = Vector3(0,1.4,0); add_child(lbl)
	target = global_position

func _physics_process(delta: float) -> void:
	if global_position.distance_to(target) < 0.7:
		target = Vector3(randf_range(-16,16),0,randf_range(-16,16))
	velocity = (target - global_position).normalized() * 2.4
	move_and_slide()
	if not carry and global_position.distance_to(ball.global_position) < 1.1:
		carry = true
	if carry:
		ball.global_position = global_position + Vector3(0.5,0.5,0)
	on_rock = global_position.distance_to(rock.global_position) < 1.4

func is_holding_ball() -> bool:
	return carry

func call_to_bed() -> void:
	target = bed.global_position

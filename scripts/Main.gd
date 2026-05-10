extends Node3D

const VillagerScene = preload("res://scripts/Villager.gd")
const PollyScene = preload("res://scripts/Polly.gd")
const FloodScene = preload("res://scripts/Flood.gd")
const BarrierScene = preload("res://scripts/Barrier.gd")

enum WorldState {STABLE, VULNERABLE, CRISIS, LIMBO, LOST}

var stages := CivilizationData.get_stages()
var branches: Array = CivilizationData.get_branches()
var stage_index := 2
var branch: String = branches[0]
var world_state := WorldState.STABLE
var conflict := 25.0
var houses_built := 0
var recon_done := false
var crisis_time := 0.0
var polly_rock_timer := 0.0

var villagers: Array = []
var houses_root: Node3D
var barrier_root: Node3D
var flood
var settlement_center := Vector3(0,0,0)
var marble_rock: Node3D
var ball: Node3D
var shrine: Node3D
var polly
var ui_log: RichTextLabel
var divergences_unlocked := false
var dusk := false

func _ready() -> void:
	randomize()
	_create_world()
	_create_ui()
	log_line("A cycle begins.")

func _process(delta: float) -> void:
	_update_conflict(delta)
	_update_objectives(delta)
	_update_polly_trigger(delta)
	if world_state == WorldState.CRISIS:
		crisis_time += delta
		if crisis_time >= 30.0:
			enter_limbo()
		elif flood and flood.global_position.x >= settlement_center.x:
			lose_civilization()
	_update_ui(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if world_state == WorldState.CRISIS:
			var p = ray_to_ground(event.position)
			if p != null:
				place_barrier(p)

func _create_world() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.2,0.24,0.3)
	env.environment = e
	add_child(env)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55,45,0)
	add_child(light)

	var rig := Node3D.new()
	rig.set_script(load("res://scripts/CameraRig.gd"))
	rig.position = Vector3(0,0,0)
	add_child(rig)
	var cam := Camera3D.new()
	cam.name = "Camera3D"
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 24
	rig.add_child(cam)

	var ground := MeshInstance3D.new()
	var pm := PlaneMesh.new(); pm.size = Vector2(60,60); ground.mesh = pm
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(0.34,0.5,0.34); ground.material_override = mat
	add_child(ground)

	houses_root = Node3D.new(); add_child(houses_root)
	barrier_root = Node3D.new(); add_child(barrier_root)
	_spawn_setpieces()
	_spawn_entities()

func _spawn_setpieces() -> void:
	marble_rock = _make_mesh(CylinderMesh.new(), Color(0.95,0.95,0.98), Vector3(-4,0.5,-2), Vector3(1.8,1,1.8))
	shrine = _make_mesh(BoxMesh.new(), Color(0.5,0.9,1.0), Vector3(4,1.5,2), Vector3(1,3,1))
	ball = _make_mesh(SphereMesh.new(), Color.YELLOW, Vector3(-8,0.5,-6), Vector3.ONE * 0.5)
	var bed := _make_mesh(BoxMesh.new(), Color(0.6,0.2,0.1), Vector3(10,0.1,-10), Vector3(1.5,0.2,1.0)); bed.name = "DogBed"

func _spawn_entities() -> void:
	for i in range(8): villagers.append(_spawn_villager("human", Vector3(randf_range(-10,10),0,randf_range(-10,10))))
	for i in range(6): villagers.append(_spawn_villager("xeno", Vector3(randf_range(-10,10),0,randf_range(-10,10))))
	polly = CharacterBody3D.new(); polly.set_script(PollyScene); polly.name = "Polly"; add_child(polly); polly.setup(ball, marble_rock, get_node("DogBed"))
	polly.global_position = Vector3(-12,0,-8)

func _spawn_villager(kind:String, p:Vector3):
	var v := CharacterBody3D.new(); v.set_script(VillagerScene); add_child(v); v.setup(kind, settlement_center); v.global_position = p; return v

func _create_ui() -> void:
	var c := CanvasLayer.new(); add_child(c)
	var p := PanelContainer.new(); p.size = Vector2(440,340); c.add_child(p)
	var vb := VBoxContainer.new(); p.add_child(vb)
	for t in ["Build House","Reconciliation Pulse","Base-Form Memory","Call Polly","Open Divergences"]:
		var b := Button.new(); b.text = t; vb.add_child(b)
		if t == "Build House": b.pressed.connect(func(): build_house())
		if t == "Reconciliation Pulse": b.pressed.connect(func(): reconciliation())
		if t == "Base-Form Memory": b.pressed.connect(func(): base_form_memory())
		if t == "Call Polly": b.pressed.connect(func(): polly.call_to_bed())
		if t == "Open Divergences": b.pressed.connect(func(): open_divergences())
	var utter := LineEdit.new(); utter.placeholder_text = "Utterance / Chant"; vb.add_child(utter)
	utter.text_submitted.connect(func(text): submit_utterance(text); utter.clear())
	ui_log = RichTextLabel.new(); ui_log.custom_minimum_size = Vector2(420,170); vb.add_child(ui_log)

func _update_ui(_delta:float) -> void:
	var stage = stages[stage_index]
	var pop := alive_population()
	var s := "[b]%s[/b] | Branch: %s\nPop: %d  Conflict: %d\nHouses: %d/3 Recon:%s\nState: %s"
	ui_log.text = s % [stage.name, branch, pop, int(conflict), houses_built, str(recon_done), _state_name()]

func build_house() -> void:
	houses_built += 1
	_make_house(Vector3(randf_range(-6,6),0,randf_range(-6,6)))
	log_line("A new shelter rises.")

func _make_house(p:Vector3) -> void:
	var n := Node3D.new(); n.position = p; houses_root.add_child(n)
	var body := MeshInstance3D.new(); var bm := BoxMesh.new(); bm.size = Vector3(1.4,1,1.4); body.mesh = bm; n.add_child(body)
	var roof := MeshInstance3D.new(); var rm := PrismMesh.new(); rm.size = Vector3(1.6,0.8,1.6); roof.mesh = rm; roof.position.y = 0.9; roof.rotation_degrees.z = 90; n.add_child(roof)

func reconciliation() -> void:
	recon_done = true
	conflict = max(0, conflict - 20)
	for v in villagers: v.receive_reconciliation()
	log_line("A pulse of cooperation ripples from the shrine.")

func base_form_memory() -> void:
	var h = _near_species("human")
	var x = _near_species("xeno")
	if h and x:
		h.base_form(); x.base_form(); conflict = max(0, conflict - 35)
		log_line("LOW DRONE: the old shapes remember. They were not enemies at the beginning.")
		if world_state == WorldState.VULNERABLE and dusk:
			invoke_extinction("Twin memory under dusk")

func submit_utterance(text:String) -> void:
	if text.strip_edges().to_lower() == "yeah yeah yeah":
		if world_state == WorldState.VULNERABLE:
			log_line("The words find the old door.")
			invoke_extinction("The chorus of Money remembers three yeses")
		else:
			log_line("The words vanish into ordinary air.")
	else:
		log_line("The world hears: %s" % text)

func _update_objectives(delta:float) -> void:
	dusk = fmod(Time.get_ticks_msec()/1000.0, 40.0) > 30.0
	if world_state == WorldState.STABLE and houses_built >= 3 and alive_population() >= 10 and conflict < 50 and recon_done:
		world_state = WorldState.VULNERABLE
		log_line("The world is extinction-vulnerable.")
		log_line("Do not let the white dog carry the sun to the pale stone.")
		log_line("The chorus of Money remembers three yeses.")
		log_line("When two old shapes return beneath the monolith, the cycle listens.")
	if stage_index < stages.size()-1 and houses_built >= stages[stage_index].houses and randf() < delta * 0.03:
		stage_index += 1
	if stage_index >= 7 or world_state == WorldState.LIMBO:
		divergences_unlocked = true

func _update_conflict(delta:float) -> void:
	var pressure := 0.9 if stage_index >= 3 else 0.3
	conflict = clampf(conflict + pressure * delta, 0, 100)
	for v in villagers:
		v.conflict = conflict
		if world_state == WorldState.CRISIS: v.flee_from(flood.global_position)

func _update_polly_trigger(delta:float) -> void:
	if world_state != WorldState.VULNERABLE: return
	if polly.is_holding_ball() and polly.on_rock:
		polly_rock_timer += delta
		if polly_rock_timer > 2: log_line("The white dog balances sun over pale stone...")
		if polly_rock_timer >= 5: invoke_extinction("Polly carried the sun to pale stone")
	else: polly_rock_timer = 0.0

func invoke_extinction(reason:String) -> void:
	if world_state == WorldState.CRISIS or world_state == WorldState.LIMBO: return
	world_state = WorldState.CRISIS
	crisis_time = 0.0
	log_line("EXTINCTION INVOKED: %s" % reason)
	flood = Node3D.new(); flood.set_script(FloodScene); add_child(flood); flood.setup(Vector3(-28,4,0))

func place_barrier(p:Vector3) -> void:
	var b := Node3D.new(); b.set_script(BarrierScene); barrier_root.add_child(b); b.setup(p)
	if flood: flood.slow_power += 0.2

func enter_limbo() -> void:
	if world_state != WorldState.CRISIS: return
	world_state = WorldState.LIMBO
	if flood: flood.freeze_wall()
	divergences_unlocked = true
	log_line("The flood hangs in limbo. This world survives.")

func lose_civilization() -> void:
	world_state = WorldState.LOST
	log_line("The civilization was washed away. A new cycle may begin.")

func open_divergences() -> void:
	if not divergences_unlocked:
		log_line("Worlds Not Chosen are still asleep.")
		return
	branch = branches[(branches.find(branch) + 1) % branches.size()]
	log_line("Divergence opened: %s" % branch)

func ray_to_ground(mouse_pos:Vector2):
	var cam := get_viewport().get_camera_3d()
	var o := cam.project_ray_origin(mouse_pos)
	var d := cam.project_ray_normal(mouse_pos)
	var t := -o.y / d.y
	return o + d * t if t > 0 else null

func _make_mesh(mesh:Mesh, color:Color, pos:Vector3, scl:Vector3) -> MeshInstance3D:
	var m := MeshInstance3D.new(); m.mesh = mesh; m.position = pos; m.scale = scl
	var mat := StandardMaterial3D.new(); mat.albedo_color = color; mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if color.a < 1.0 else 0; m.material_override = mat
	add_child(m); return m

func _near_species(kind:String):
	for v in villagers:
		if v.kind == kind and v.global_position.distance_to(shrine.global_position) < 6 and v.alive: return v
	return null

func alive_population() -> int:
	var c:=0
	for v in villagers:
		if v.alive: c+=1
	return c

func _state_name() -> String:
	return ["Stable","Vulnerable","Extinction Invoked","Saved With Scar","Lost"][world_state]

func log_line(t:String) -> void:
	print(t)

extends Node3D
class_name CameraRig

@export var pan_speed := 25.0
@export var rotate_speed := 1.5
@export var min_zoom := 12.0
@export var max_zoom := 65.0

var zoom_distance := 32.0
var yaw := 0.0
var dragging := false
var cam: Camera3D

func _ready() -> void:
	cam = $Camera3D
	_update_transform()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT):
		dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		global_position += Vector3(-event.relative.x * 0.03, 0.0, -event.relative.y * 0.03).rotated(Vector3.UP, yaw)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_distance = max(min_zoom, zoom_distance - 2.0)
			_update_transform()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_distance = min(max_zoom, zoom_distance + 2.0)
			_update_transform()

func _process(delta: float) -> void:
	var dir := Vector2.ZERO
	dir.y += Input.get_action_strength("camera_pan_down") - Input.get_action_strength("camera_pan_up")
	dir.x += Input.get_action_strength("camera_pan_right") - Input.get_action_strength("camera_pan_left")
	if dir.length() > 0.01:
		var move := Vector3(dir.x, 0, dir.y).normalized().rotated(Vector3.UP, yaw)
		global_position += move * pan_speed * delta
	if Input.is_action_pressed("camera_rotate_left"):
		yaw += rotate_speed * delta
		_update_transform()
	if Input.is_action_pressed("camera_rotate_right"):
		yaw -= rotate_speed * delta
		_update_transform()

func _update_transform() -> void:
	rotation = Vector3(deg_to_rad(-55), yaw, 0)
	cam.position = Vector3(0, 0, zoom_distance)

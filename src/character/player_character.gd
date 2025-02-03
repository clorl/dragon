@tool
extends CharacterBody3D

@onready var input := $PlayerInput
@onready var cam_root := $CameraRoot
@onready var cam := $CameraRoot/Camera
@onready var sm := $StateMachine
@onready var at := $AnimationTree

@export_group("Camera Settings")
# Mouse sensitivity
@export var cam_sensitivity: float = 0.1

# Vertical rotation limits (in degrees)
@export var min_pitch: float = -70.0
@export var max_pitch: float = 70.0

@export_group("Debug Draw")
@export var look_dir_arrow_length := 3.0
@export var look_dir_arrow_head_size := .05

var look_direction := Vector3.FORWARD

func _physics_process(delta: float) -> void:
	var cam_forward = -cam.transform.basis.z.normalized()
	look_direction = cam_forward

	DebugDraw3D.draw_arrow($LookOrigin.position, $LookOrigin.position + look_direction * look_dir_arrow_length, Color.BLUE, look_dir_arrow_head_size)

	if Engine.is_editor_hint():
		return

	# Aim
	var mouse_motion = input.mouse_motion
	cam_root.rotate_y(-mouse_motion.x * cam_sensitivity * delta)
	cam_root.rotation_degrees.x -= mouse_motion.y * cam_sensitivity
	cam_root.rotation_degrees.x = clamp(cam_root.rotation_degrees.x, min_pitch, max_pitch)
	input.mouse_motion = Vector2.ZERO

var _state_process(state, delta):
	match state:
		"Idle":
		"Run":
			pass
	sm.set_param("grounded", is_on_floor())
	sm.set_param("velocity", velocity)

var _state_entered(to):
	pass

var _state_exited(from):
	pass

var _state_transition(from, to):
	pass

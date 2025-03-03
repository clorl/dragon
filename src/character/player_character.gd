@tool
extends CharacterBody3D

@onready var input := $PlayerInput
@onready var cam_root := $CameraRoot
@onready var cam := $CameraRoot/Camera
@onready var sm := $StateMachine
@onready var at := $AnimationTree


@export_group("Movement")
@export var max_speed: float
@export var drag: float

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

func _ready():
	input.axis_changed.connect(_player_input_axis)

func _player_input_axis(_name, value):
	var forward = -transform.basis.z.normalized()  # Forward direction (negative Z in Godot)
	var right = transform.basis.x.normalized()  # Right direction (positive X in Godot)
	var added_velocity = Vector3.ZERO
	if _name == "horizontal":
		added_velocity.x = right.x * value * max_speed
		added_velocity.z = right.z * value * max_speed
	elif _name == "vertical":
		added_velocity.x += -forward.x * value * max_speed
		added_velocity.z += -forward.z * value * max_speed
	else:
		return


	# Normalize the added_velocity to prevent faster diagonal movement
	added_velocity = added_velocity.normalized() * max_speed
	velocity += added_velocity
	print(velocity)

func _physics_process(delta: float) -> void:
	var cam_forward = -cam.transform.basis.z.normalized()
	look_direction = cam_forward

	DebugDraw3D.draw_arrow($LookOrigin.global_position, $LookOrigin.global_position + look_direction * look_dir_arrow_length, Color.BLUE, look_dir_arrow_head_size)

	if Engine.is_editor_hint():
		return

	# Aim
	var mouse_motion = input.mouse_motion
	cam_root.rotate_y(-mouse_motion.x * cam_sensitivity * delta)
	cam_root.rotation_degrees.x -= mouse_motion.y * cam_sensitivity
	cam_root.rotation_degrees.x = clamp(cam_root.rotation_degrees.x, min_pitch, max_pitch)
	input.mouse_motion = Vector2.ZERO

	# State machine and anim
	var input_vel = Vector3(input.get_axis("horizontal"),0,input.get_axis("vertical"))

	var forward = -cam_root.transform.basis.z.normalized()  # Forward direction (negative Z in Godot)
	var right = forward.cross(Vector3.UP).normalized()  # Right direction
	var projected_velocity = Vector3(velocity.x, 0, velocity.z)

	var blend_x = projected_velocity.dot(right)  # Left/Right movement
	var blend_y = projected_velocity.dot(forward)  # Forward/Backward movement
	var blend_vector = Vector2(blend_x, blend_y).normalized()

	velocity += (Vector3(forward.x, 0, forward.z) * -input_vel.z + Vector3(right.x, 0, right.z) * -input_vel.x).normalized() * max_speed
	velocity *= drag
	move_and_slide()
	print(str(input_vel))

	sm.set_param("grounded", is_on_floor())
	sm.set_param("velocity", velocity)
	at.set("parameters/WalkRun/blend_position", lerp(velocity.length(), 0., max_speed))
	at.set("parameters/WalkRun/1/blend_position", lerp(velocity.length(), 0., blend_vector))

func _state_process(state, delta):
	match state:
		"Idle":
			pass
		"Run":
			pass

func _state_entered(to):
	pass

func _state_exited(from):
	pass

func _state_transition(from, to):
	pass

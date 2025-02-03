@tool
extends Node3D

# Mouse sensitivity
@export var sensitivity: float = 0.1

# Vertical rotation limits (in degrees)
@export var min_pitch: float = -70.0
@export var max_pitch: float = 70.0

# Internal variables
var mouse_motion: Vector2 = Vector2.ZERO

func _ready():
    # Capture the mouse
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    # Capture mouse motion
    if event is InputEventMouseMotion:
        mouse_motion = event.relative

func _process(delta):
    # Rotate horizontally (yaw)
    rotate_y(-mouse_motion.x * sensitivity * delta)

    # Rotate vertically (pitch) with limits
    rotation_degrees.x -= mouse_motion.y * sensitivity
    rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)

    # Reset mouse motion
    mouse_motion = Vector2.ZERO

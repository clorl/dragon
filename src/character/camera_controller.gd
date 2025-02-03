@tool
extends Node3D

signal camera_moved(t: Transform)


# Internal variables
var mouse_motion: Vector2 = Vector2.ZERO

func _ready():
    pass

func _input(event):
    # Capture mouse motion
    if event is InputEventMouseMotion:
        mouse_motion = event.relative

func _process(delta):
    # Rotate horizontally (yaw)

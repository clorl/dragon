@tool
extends Node3D



# Internal variables
var mouse_motion: Vector2 = Vector2.ZERO

func _ready():
    pass

func _input(event):
    # Capture mouse motion
    if event is InputEventMouseMotion:
        mouse_motion = event.relative

func _process(delta):
    pass
    # Rotate horizontally (yaw)

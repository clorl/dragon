extends PhantomCamera3D

# Variables for camera control
var target: Node  # The player character
@export var distance: float = 5.0  # Distance from the target
@export var height: float = 2.0  # Height above the target
@export var rotation_speed: float = 2.0  # Speed of rotation around the target
var pitch: float = 0.0  # Vertical angle
var yaw: float = 0.0  # Horizontal angle

func _ready():
    # Set the target to the player character
    target = get_parent()  # Assuming the camera is a child of the player

func _process(delta):
    # Get mouse input for camera rotation
    var mouse_movement = Input.get_mouse_motion()
    yaw -= mouse_movement.x * rotation_speed * delta  # Rotate around Y-axis
    pitch -= mouse_movement.y * rotation_speed * delta  # Rotate around X-axis
    pitch = clamp(pitch, -80, 80)  # Limit vertical rotation

    # Calculate the new camera position
    var offset = Vector3()
    offset.x = distance * cos(deg2rad(pitch)) * sin(deg2rad(yaw))
    offset.y = distance * sin(deg2rad(pitch))
    offset.z = distance * cos(deg2rad(pitch)) * cos(deg2rad(yaw))

    # Set the camera position
    global_transform.origin = target.global_transform.origin + offset

    # Make the camera look at the target
    look_at(target.global_transform.origin, Vector3.UP)

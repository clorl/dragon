extends Node

const FLOAT_EQUALS_MARGIN = 0.0001

signal axis_changed(name, value)
signal action_just_pressed(name)
signal action_just_released(name)
signal action_pressed(name)

var _axis = {
	"horizontal" = 0.,
	"vertical" = 0.,
	"mouse_vertical" = 0.,
	"mouse_horizontal" = 0.
}

var _mouse_mode = Input.MOUSE_MODE_VISIBLE

@export var actions = [ "jump", "aim", "shoot", "esc" ]
@export var mouse_sensitivity = 1.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ServiceLocator.register("PlayerInput", self)

func _process(_d):
	for axis_name in _axis.keys():
		var new_value = get_axis(axis_name)
		if not is_equal_approx(_axis[axis_name], new_value):
			axis_changed.emit(axis_name)
			_axis[axis_name] = new_value
		if is_zero_approx(_axis[axis_name]):
			_axis[axis_name] = 0
	
	for action_name in actions:
		if Input.is_action_just_pressed(action_name):
			action_just_pressed.emit(action_name)
		if Input.is_action_just_released(action_name):
			action_just_released.emit(action_name)
		if Input.is_action_pressed(action_name):
			action_pressed.emit(action_name)
	
	if Input.is_action_just_pressed("esc"):
		_mouse_mode = Input.MOUSE_MODE_VISIBLE if _mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func get_axis(_name: String):
	if _name == "horizontal":
		return Input.get_axis("left", "right")
	elif _name == "vertical":
		return Input.get_axis("backward", "forward")
	elif _name == "mouse_horizontal":
		return Input.get_last_mouse_velocity().x * mouse_sensitivity
	elif _name == "mouse_vertical":
		return Input.get_last_mouse_velocity().y * mouse_sensitivity
	return 0

func get_action(_name: String):
	return Input.is_action_pressed(_name)

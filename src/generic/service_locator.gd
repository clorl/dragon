extends Node

signal service_available(name, object)

var _registry = {}

func register(_name: StringName, object):
	_registry[_name] = object
	service_available.emit(_name, object)

func get_service(_name: StringName):
	if _registry.get(_name):
		return {
			result = true,
			value = _registry[_name]
		}
	return {
		result = false,
		value = false
	}

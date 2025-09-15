class_name Particle
extends RefCounted


var position: Vector3
var density: float = 0.0
var pressure: float = 0.0


func _init(_position: Vector3) -> void:
	position = _position

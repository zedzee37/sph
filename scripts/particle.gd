class_name Particle
extends RefCounted


var position: Vector3
var velocity: Vector3
var density: float = 0.0
var pressure := Vector3.ZERO


func _init(_position: Vector3) -> void:
	position = _position

class_name PivotCamera
extends Node3D


@export var arm_length: float = 50.0
@export var speed_scaling: float = 50


@onready var camera: Node3D = $Camera3D


var _mouse_held := false
var _velocity := Vector2.ZERO


func _ready() -> void:
	camera.position = Vector3.BACK * arm_length


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton

		if mouse_button_event.is_released():
			_mouse_held = false
		else:
			_mouse_held = true
	elif event is InputEventMouseMotion and _mouse_held:
		var mouse_event_motion := event as InputEventMouseMotion
		_velocity = mouse_event_motion.velocity / speed_scaling


func _process(delta: float) -> void:
	if _mouse_held:
		rotation.x -= _velocity.y * delta
		rotation.y -= _velocity.x * delta

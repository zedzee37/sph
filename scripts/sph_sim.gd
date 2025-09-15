class_name SphSim
extends Node3D


@export var particle_count: int = 500
@export var bounding_box_size: int = 20
@export var smoothing_radius: float = 0.1
@export var mass: float = 1.0


@onready var _visualizer: MultiMeshSphVisualizer = $MultiMeshSphVisualizer
@onready var _has_visualizer := _visualizer.has_method("render")
@onready var _c1 := Vector3(
	-bounding_box_size, -bounding_box_size, -bounding_box_size
)
@onready var _c2 := _c1 * -1
@onready var target_volume: float = smoothing_radius * particle_count
@onready var target_density = (mass * particle_count) / target_volume


var _particles: Array[Particle] = []


func _ready() -> void:
	print_debug(target_density)
	randomize()
	for i in range(particle_count):
		@warning_ignore("NARROWING_CONVERSION")
		var particle := Particle.new(
			Vector3(
				randi_range(_c1.x, _c2.x),
				randi_range(_c1.y, _c2.y),
				randi_range(_c1.z, _c2.z)
			)
		)
		_particles.append(particle)


func _process(_delta: float) -> void:
	if _has_visualizer:
		_visualizer.render(_particles)

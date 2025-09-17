class_name SphSim
extends Node3D


@export var particle_count: int = 500
@export var bounding_box_size: int = 20
@export var smoothing_radius: float = 0.1
@export var mass: float = 1.0
@export var pressure_multiplier: float = 0.25
@export var tmp_target_density: float = 0.2


@onready var _visualizer: MultiMeshSphVisualizer = $MultiMeshSphVisualizer
@onready var _has_visualizer := _visualizer.has_method("render")
@onready var _c1 := Vector3(
	-bounding_box_size, -bounding_box_size, -bounding_box_size
)
@onready var _c2 := _c1 * -1
@onready var target_volume: float = smoothing_radius * particle_count
@onready var target_density := (mass * particle_count) / target_volume


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


func _process(delta: float) -> void:
	_update_simulation(delta)
	if _has_visualizer:
		_visualizer.render(_particles)


func _update_simulation(delta: float) -> void:
	_calculate_densities()
	_calculate_pressures()

	for i: int in range(particle_count):
		var particle := _particles[i]

		particle.position += particle.velocity * delta
		particle.velocity += particle.pressure * delta
		particle.pressure = Vector3.ZERO

		if particle.position.x > _c2.x or particle.position.x < _c1.x:
			particle.velocity.x *= -1

		if particle.position.y > _c2.y or particle.position.y < _c1.y:
			particle.velocity.y *= -1

		if particle.position.z > _c2.z or particle.position.z < _c1.z:
			particle.velocity.z *= -1


func _calculate_densities() -> void:
	for i: int in range(particle_count):
		_particles[i].density = _calculate_density(i)


func _calculate_density(index: int) -> float:
	var density := 0.0

	var pos := _particles[index].position
	for i: int in range(particle_count):
		var particle: Particle = _particles[i]
		density += mass * _poly6_kernel(pos.distance_squared_to(particle.position))

	return density


func _calculate_pressures() -> void:
	for i: int in range(particle_count):
		_particles[i].pressure = _calculate_pressure(i)


func _pressure_magnitude(density: float) -> float:
	var error := tmp_target_density - density
	return error * pressure_multiplier


func _calculate_pressure(index: int) -> Vector3:
	var pressure := _particles[index].pressure

	var pos := _particles[index].position
	for i: int in range(particle_count):
		if i == index:
			continue

		var particle := _particles[i]
		var distance := particle.position.distance_to(pos)

		var kernel_factor := _delta_spiky_kernel(distance)
		var direction := -pos.direction_to(particle.position)

		pressure += (_pressure_magnitude(particle.density) * direction * kernel_factor * mass) / particle.density

	return pressure


func _poly6_kernel(d2: float) -> float:
	var h2 := smoothing_radius**2
	if d2 > h2:
		return 0.0

	var factor := (h2 - d2)**3
	return (315/(64*PI*(smoothing_radius**9)))*factor


func _spiky_kernel(d: float) -> float:
	if d > smoothing_radius:
		return 0.0

	var factor := (smoothing_radius - d)**3
	return (15/(PI*(smoothing_radius**6)))*factor


func _delta_spiky_kernel(d: float) -> float:
	if d > smoothing_radius:
		return 0.0

	var factor := (smoothing_radius - d)**2
	return (-45/(PI*(smoothing_radius**6)))*factor

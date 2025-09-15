class_name MultiMeshSphVisualizer
extends MultiMeshInstance3D


@export var mesh: Mesh


var _has_instantiated := false


# update the position of the particles
func render(particles: Array[Particle]) -> void:
	if not _has_instantiated:
		_instantiate_meshes(len(particles))

	for i in range(len(particles)):
		var particle := particles[i]

		var pos := Transform3D()
		pos = pos.translated(particle.position)

		multimesh.set_instance_transform(i, pos)


func _instantiate_meshes(particle_count: int) -> void:
	var multi_mesh := MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.instance_count = particle_count
	multi_mesh.mesh = mesh

	multimesh = multi_mesh

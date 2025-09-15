class_name TestManager
extends Node


@export var test_path: String = "res://test/"


func _ready() -> void:
	var scenes := ResourceUtil.find_scenes(test_path)

	for scene: PackedScene in scenes:
		var sys: Node = scene.instantiate()

		if sys is not TestSystem:
			continue

		print("Running test system: {}".format([sys.name], "{}"))

		add_child(sys)
		
		if not sys.ran:
			await sys.ran_tests

		sys.queue_free()

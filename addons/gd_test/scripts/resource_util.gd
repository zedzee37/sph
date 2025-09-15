class_name ResourceUtil
extends RefCounted


static func find_scenes(path: String) -> Array[PackedScene]:
	if path[-1] != '/':
		path += '/'
	
	var scenes: Array[PackedScene] = []

	var paths = ResourceLoader.list_directory(path)
	for fp: String in paths:
		var file_path := path + fp

		if not ResourceLoader.exists(file_path, "PackedScene"):
			continue

		var scene := load(file_path)
		if scene is not PackedScene:
			continue

		scenes.append(scene)

	return scenes

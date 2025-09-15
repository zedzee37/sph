@tool
extends EditorPlugin


var dock: Control


func _enter_tree() -> void:
	dock = preload("res://addons/gd_test/scenes/dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)

	dock.run_scene.connect(_run_scene)


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()


func _run_scene(path: String) -> void:
	var maybe_scene = load(path)

	if maybe_scene is not PackedScene:
		printerr("File '{}' is not a scene".format([path], "{}"))
		return

	var scene := maybe_scene as PackedScene
	if not scene:
		# ????
		printerr("An unexpected error has occured")
		return 

	var interface := get_editor_interface()
	interface.open_scene_from_path(path)
	await get_tree().process_frame
	interface.play_current_scene()

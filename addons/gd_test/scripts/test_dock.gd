@tool
extends Control


signal run_scene(path: String)


@onready var _directory_label: Label = %DirectoryLabel
@onready var test_group_vbox: VBoxContainer = %TestGroupVBox


const TEST_GROUP_SCENE: PackedScene = preload("res://addons/gd_test/scenes/test_group.tscn")


var dialog: EditorFileDialog
var _target_folder: String = "res://scenes/test/":
	set(value):
		_target_folder = value

		_directory_label.text = _get_target_folder_text(value)


func _ready() -> void:
	_directory_label.text = _get_target_folder_text(_target_folder)

	dialog = EditorFileDialog.new()
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR

	var screen_size := DisplayServer.screen_get_size()
	
	dialog.size = screen_size / 2
	dialog.dir_selected.connect(_on_folder_select_dialog_dir_selected)

	add_child(dialog)

	_on_folder_select_dialog_dir_selected(_target_folder)

	visibility_changed.connect(func(): _on_folder_select_dialog_dir_selected(_target_folder))


func _get_target_folder_text(dir: String) -> String:
	return "Current Directory: " + dir


func _on_folder_select_button_pressed() -> void:
	dialog.move_to_center()
	dialog.show()


func _on_folder_select_dialog_dir_selected(dir: String) -> void:
	if dir[-1] != "/":
		_target_folder = dir + "/"
	else:
		_target_folder = dir

	for child in test_group_vbox.get_children():
		test_group_vbox.remove_child(child)
		child.queue_free()
	
	var scenes = ResourceUtil.find_scenes(_target_folder)
	for scene in scenes:
		var group := TEST_GROUP_SCENE.instantiate()
		group.text = scene.resource_path
		group.get_node("Button").pressed.connect(_run_test_group.bind(group))
		test_group_vbox.add_child(group)


func _run_test_group(test_group: Control) -> void:
	var path: String = test_group.text
	run_scene.emit(path)

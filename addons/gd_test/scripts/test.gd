class_name Test
extends Node


@export var test_name: String = ""


func run(builder: TestBuilder) -> Array[TestBuilder.Result]:
	await test(builder)
	return builder.results


func test(_builder: TestBuilder) -> void:
	pass

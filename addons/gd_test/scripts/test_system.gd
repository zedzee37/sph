class_name TestSystem
extends Node


signal ran_tests


var _tests: Array[Test] = []
var ran: bool = false


func _ready() -> void:
	_collect_tests()
	run()


func _collect_tests() -> void:
	for child: Node in get_children():
		if child is Test:
			_tests.append(child)


func run() -> void:
	for test: Test in _tests:
		var builder := TestBuilder.new(test)
		var results := await test.run(builder)

		print(" | Running Test: {}".format([test.name], "{}"))

		var i: int = 1
		for result: TestBuilder.Result in results:
			if result.success:
				_print_success(result.test_info, i)
			else:
				_print_error(result.test_info, i)
			i += 1


		print(" | Test {} done".format([test.name], "{}"))

		print("\n")

	ran = true
	ran_tests.emit()


func _print_error(test_info: TestBuilder.TestInfo, idx: int) -> void:
	_print_result(false, idx, test_info, "has failed! :( - {}".format([test_info.error_msg], "{}"))


func _print_success(test_info: TestBuilder.TestInfo, idx: int) -> void:
	_print_result(true, idx, test_info, "has succeeded :)")


func _print_result(success: bool, idx: int, test_info: TestBuilder.TestInfo, body: String) -> void:
	var s: String = " |  | [{}] {}: ".format([idx, test_info.test_name], "{}") + body
	if success:
		print(s)
	else:
		printerr(s)
	
	

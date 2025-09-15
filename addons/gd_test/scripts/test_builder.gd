class_name TestBuilder
extends RefCounted


var results: Array[Result] = []


var test: Test


func _init(_test: Test) -> void:
	test = _test


func expect(expression: bool, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	results.append(Result.new(expression, test_info))
	return self


func expect_equal(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 == v2, test_info)


func expect_not_equal(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 != v2, test_info)


func expect_greater(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 > v2, test_info)


func expect_greater_equal(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 >= v2, test_info)


func expect_lesser(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 < v2, test_info)


func expect_lesser_equal(v1, v2, test_info: TestInfo = TestInfo.new()) -> TestBuilder:
	return expect(v1 <= v2, test_info)


class Result:
	var success: bool
	var test_info: TestInfo

	func _init(_success: bool, _test_info: TestInfo = TestInfo.new()) -> void:
		success = _success
		test_info = _test_info


class TestInfo:
	var test_name: String
	var error_msg: String

	func _init(_test_name: String = "", _error_msg: String = "") -> void:
		test_name = _test_name
		error_msg = _error_msg

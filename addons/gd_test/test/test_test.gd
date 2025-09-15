extends Test

func test(builder: TestBuilder) -> void:
	builder.expect(true)
	builder.expect_equal(1, 2, TestBuilder.TestInfo.new("1 == 2", "one does not equal two :("))

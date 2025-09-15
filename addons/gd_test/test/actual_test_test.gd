extends Test

func manhattan_distance(p1: Vector2, p2: Vector2) -> float:
	return abs(p1.x - p2.x) + abs(p1.y - p2.y)

func test(builder: TestBuilder) -> void:
	builder.expect_equal(
		manhattan_distance(
			Vector2(3, -2),
			Vector2(6, 1),
		),
		6
	)

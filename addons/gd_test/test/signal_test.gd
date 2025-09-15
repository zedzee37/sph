extends Test

@export var button: Button

func test(_builder: TestBuilder) -> void:
	await button.pressed
	

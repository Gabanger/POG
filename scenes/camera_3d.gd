extends Camera3D

const SENSITIVITY = 1.0/240.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var MouseEvent = event.relative
		rotation.x += MouseEvent.y * SENSITIVITY * -1
		rotation.x = min(PI/2,rotation.x)
		rotation.x = max(-PI/2,rotation.x)
		rotation.y += MouseEvent.x * SENSITIVITY * -1

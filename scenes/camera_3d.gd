extends Camera3D

const SENSITIVITY = 1.0/240.0
const THIRD_PERSON_RANGE = 5
const OFFSET_POS = Vector3(0,1.25,0)
const DISTANCE_FROM_SURFACE = 0.05

@onready var Raycast = $"../RayCast_Camera"
@onready var Player = $".."

var is_in_first_person = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_camera(event,true)
	if event is InputEventKey:
		if event.is_action_pressed("Switch camera person"):
			is_in_first_person = not is_in_first_person
			update_camera(event,false)

func _process(_delta: float) -> void:
	if not is_in_first_person:
		update_camera(InputEventKey.new(), false)

func update_camera(e : InputEvent, change_angle : bool):
	if change_angle:
		var MouseEvent = e.relative
		rotation.x += MouseEvent.y * SENSITIVITY * -1
		rotation.x = min(PI/2,rotation.x)
		rotation.x = max(-PI/2,rotation.x)
		rotation.y += MouseEvent.x * SENSITIVITY * -1
	
	if is_in_first_person:
		position = OFFSET_POS
	else:
		var vec = global_basis * Vector3.FORWARD
		vec *= -1 * THIRD_PERSON_RANGE
		Raycast.target_position = vec
		if Raycast.is_colliding():
			var gap = Raycast.get_collision_normal()
			gap *= DISTANCE_FROM_SURFACE
			position = gap + Raycast.get_collision_point() - Player.position
		else:
			position = OFFSET_POS + vec

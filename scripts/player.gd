extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DECELERATION_MID_AIR = 1
const DECELERATION_FLOOR = 15
const ACCELERATION_MID_AIR = 0.25
const ACCELERATION_FLOOR = 3

@onready var Camera = $"Camera3D"

func _physics_process(delta: float) -> void:
	#Engine.time_scale = 0.05
	if Input.is_action_just_pressed("ui_cancel"):
		if Engine.max_fps == 0:
			Engine.max_fps = 10
		else:
			Engine.max_fps = 0
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_pogo_on_floor:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3(0,1,0),Camera.rotation.y)
	if direction:
		if is_pogo_on_floor:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION_MID_AIR)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION_MID_AIR)
		else:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION_MID_AIR)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION_MID_AIR)
	else:
		if is_pogo_on_floor:
			velocity.x -= velocity.x * DECELERATION_FLOOR * delta
			velocity.z -= velocity.z * DECELERATION_FLOOR * delta
		else:
			velocity.x -= velocity.x * DECELERATION_MID_AIR * delta
			velocity.z -= velocity.z * DECELERATION_MID_AIR * delta

	move_and_slide()

var is_pogo_on_floor := 0

func _on_area_pogo_body_entered(_body: Node3D) -> void:
	is_pogo_on_floor += 1

func _on_area_pogo_body_exited(_body: Node3D) -> void:
	is_pogo_on_floor -= 1

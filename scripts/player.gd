extends CharacterBody3D

const HOP_FORCE = 3
const HOP_HEIGHT = 2.0
const JUMP_VELOCITY = 5.0
const GRAVITY = 9.8
const AIR_CONTROL_BLEND = 0.2
const ACCELERATION_MID_AIR = 0.5

@onready var Camera = $"Camera3D"


var saved_direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3(0,1,0),Camera.rotation.y)
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION_MID_AIR)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION_MID_AIR)
		else:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION_MID_AIR)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION_MID_AIR)
	else:
		if is_on_floor():
			velocity.x -= velocity.x * DECELERATION_FLOOR * delta
			velocity.z -= velocity.z * DECELERATION_FLOOR * delta
		else:
			velocity.x -= velocity.x * DECELERATION_MID_AIR * delta
			velocity.z -= velocity.z * DECELERATION_MID_AIR * delta

	move_and_slide()

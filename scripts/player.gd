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
		velocity.y -= GRAVITY * delta

	var input_direction = get_input_direction()

	if is_on_floor():

		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			saved_direction = input_direction

		elif input_direction == Vector3.ZERO:
			velocity.x = move_toward(velocity.x, 0, HOP_FORCE * 0.3)
			velocity.z = move_toward(velocity.z, 0, HOP_FORCE * 0.3)

		elif not Input.is_action_pressed("ui_accept") and input_direction != Vector3.ZERO:
			saved_direction = input_direction
			var impulse = input_direction.normalized() * HOP_FORCE
			velocity.x = impulse.x
			velocity.z = impulse.z
			velocity.y = HOP_HEIGHT
	else:
		# Contrôle en l'air
		var blended = saved_direction.lerp(input_direction, AIR_CONTROL_BLEND).normalized()
		velocity.x = move_toward(velocity.x, blended.x * HOP_FORCE, ACCELERATION_MID_AIR)
		velocity.z = move_toward(velocity.z, blended.z * HOP_FORCE, ACCELERATION_MID_AIR)

	move_and_slide()

func get_input_direction() -> Vector3:
	var input_vec = Input.get_vector("left", "right", "forward", "backward")
	var dir = (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()
	return dir.rotated(Vector3.UP, Camera.rotation.y)
	
	
	
var is_pogo_on_floor := 0

func _on_area_pogo_body_entered(_body: Node3D) -> void:
	is_pogo_on_floor += 1

func _on_area_pogo_body_exited(_body: Node3D) -> void:
	is_pogo_on_floor -= 1

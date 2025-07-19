extends CharacterBody3D


var SPEED = 5.0
const walkspeed = 5.0
const sprintspeed = 7.5
const JUMP_VELOCITY = 4.5
var SENSITIVITY= 0.005


const bob_frequency = 2.0
const bob_amplitute = 0.08
var t_bob = 0.0
@export var checkpoint1:Area3D
@export var checkpoint2:Area3D
@export var checkpoint3:Area3D
@export var checkpoint4:Area3D
@export var checkpoint5:Area3D
@export var checkpoint6:Area3D
var destination



@onready var head = $head
@onready var camera = $head/Camera3D
func _ready() -> void:
	destination = checkpoint1.global_transform.origin
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("sprint"):
		SPEED = sprintspeed
	else:
		SPEED = walkspeed
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = lerp(velocity.x,direction.x * SPEED, delta * 3)
		velocity.z = lerp(velocity.z,direction.z * SPEED, delta * 3)
		t_bob += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(t_bob)
		

	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitute
	pos.x = cos(time * bob_frequency / 2) * bob_amplitute
	return pos


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.global_transform.origin = destination


func _on_checkpoint_2_body_entered(body: Node3D) -> void:
	if body.name == "player":
		destination = checkpoint2.global_transform.origin

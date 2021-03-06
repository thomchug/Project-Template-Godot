extends KinematicBody

onready var Camera = $Pivot/Camera
var Bullet = preload("res://Scenes/Bullet.tscn")

var velocity = Vector3()
var gravity = -9.8
var speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("Forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("Back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("Left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("Right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _physics_process(delta):
	velocity.y = gravity * delta
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)
	if event.is_action_pressed("Shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var b = Bullet.instance()
		b.start($Pivot/Muzzle.global_transform)
		get_node("/root/Game/Bullets").add_child(b)

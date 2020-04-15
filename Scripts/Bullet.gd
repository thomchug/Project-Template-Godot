extends Area

var speed = 100
var velocity = Vector3()
var damage = 2
func _ready():
	pass

func start(start_from):
	transform = start_from
	velocity = transform.basis.z * speed

func _physics_process(delta):
	transform.origin += velocity * delta

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body is StaticBody:
		queue_free()
	if body.name == "Tank":
		body.take_damage(damage)
		queue_free()

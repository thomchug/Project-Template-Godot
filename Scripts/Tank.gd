extends KinematicBody

var state = ""
var speed = 0.2
onready var Scan = $Scanner
var health = 50
var EnemyBullet = preload("res://Scenes/EnemyBullet.tscn")

func take_damage(d):
	health -= d
	if health <= 0:
		queue_free()

func change_state(s):
	state = s
	var material = $Body/Sphere.mesh.surface_get_material(0)
	if state == "scanning":
		pass

func _ready():
	change_state("searching")

func _physics_process(delta):
	if state == "searching":
		rotate(Vector3(0, 1, 0), speed * delta)
		var c = Scan.get_collider()
		if c != null and c.name == 'Player':
			change_state("found")
		if state == "found":
			$Timer.start()
		if state == "shooting":
			var b = EnemyBullet.instance()
			b.start($Pivot/Muzzle.global_transform)
			get_node("/root/Game/EnemyBullets").add_child(b)

func _on_Timer_timeout():
	var c = Scan.get_collider()
	if c != null and c.name =='Player':
			if state == "found":
				change_state("shooting")

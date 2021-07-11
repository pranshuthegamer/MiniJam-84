extends Area2D

var speed = 400
var damage = null
var direction = null
var parent = null
var parentname = ""

func _physics_process(delta):
	position += Vector2(speed,0).rotated(direction) * delta


func _on_bullet_body_entered(body):
	var bodyname = body.name
	var queuefree = true
	if body.is_in_group("mob"):
		pass
	if body is TileMap:
		queuefree = false
		queue_free()
	elif body == parent:
		queuefree = false
	if queuefree == true:
		body.hit(damage)
		print(parentname," did ",damage," damage to ",bodyname)
		queue_free()


func _enter_tree():
	var time = Timer.new()
	time.connect("timeout",self,"_on_timer_timeout")
	add_child(time)
	time.start(2)

func _on_timer_timeout():
	queue_free()


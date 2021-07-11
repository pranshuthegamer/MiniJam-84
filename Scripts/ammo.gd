extends Area2D

var speed = 400
var damage = null
var direction = null
var parent = null

func _physics_process(delta):
	position += Vector2(speed,0).rotated(direction) * delta


func _on_bullet_body_entered(body):
	var queuefree = true
	if body.is_in_group("mob"):
		body.hit(damage)
	
	if body == parent:
		queuefree = false
	if queuefree == true:
		queue_free()


func _enter_tree():
	var time = Timer.new()
	time.connect("timeout",self,"_on_timer_timeout")
	add_child(time)
	time.start(2)

func _on_timer_timeout():
	queue_free()


extends Area2D

var speed = 10
var damage = null

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_bullet_body_entered(body):
	var queuefree = true
	if body.is_in_group("mob"):
		body.hit(damage)
	elif body == get_parent():
		queuefree = false
	if queuefree == true:
		queue_free()


func _enter_tree():
	var time = Timer.new()
	var lighting = Timer.new()
	lighting.connect("timeout",self,"_on_light_timeout")
	add_child(lighting)
	lighting.start(0.05)
	time.connect("timeout",self,"_on_timer_timeout")
	add_child(time)
	time.start(1)

func _on_timer_timeout():
	queue_free()

func _on_light_timeout():
	$Light2D.energy -= 0.1
	$Light2D.scale -= Vector2(0.01,0.01)

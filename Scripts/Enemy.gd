extends KinematicBody2D

export var speed = 150.0
var velocity = Vector2()
var RandVel = Vector2()
var shooting = false
var ShotSpeed = 0
var move_and_slide
var recoil_timer
var recoiltime = 0
var currentweapon = 0
var rng = RandomNumberGenerator.new()
var randomtimer = Timer

var target = null
export var recoil = 5.0
export var damage = 10.0
export var spray = 0.01
export var MaxSpray = 0.1
export var ShootingSpeed = 0.10

export var health = 100

#Weapons

var weapons = [{
	"name":"Fast",
	"damage":5,
	"speed":0.03,
	"recoil":0.5,
	"spray":0.1,
	"MaxSpray":0.2},
	{
	"name":"Slow",
	"damage":15,
	"speed":0.17,
	"recoil":1,
	"spray":0.05,
	"MaxSpray":0.25}
	]

#SMG



var bullet = Auto.EnemyBullet

func _ready():
	pass

func _enter_tree():
	target = null
	randomtimer = Timer.new()
	randomtimer.connect("timeout",self,"Randmovement")
	randomtimer.autostart = true
	add_child(randomtimer)
	randomtimer.start(1)

func Randmovement():
	if target == null:
		rng.randomize()
		RandVel = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1))
		RandVel = RandVel.normalized()
		RandVel *= 150
	randomtimer.start(2)

func _process(delta):
	
	
	ShotSpeed += delta
	
	if target == null:
		$BarrelHolder.rotation_degrees += 50 * delta
	
	if health <= 0:
		Auto.EnemyDied(self)
	if target != null:
		$BarrelHolder.look_at(target.global_position)
	
	#if the shot cooldown is met, the player shoots
	if shooting and ShotSpeed >= ShootingSpeed:
		#recoil
		position -= Vector2(recoil,0).rotated($BarrelHolder.rotation)
		#spawns bullet
		var shot = bullet.instance()
		get_node("/root/Main").add_child(shot)
		shot.damage = damage
		shot.direction = $BarrelHolder.rotation
		shot.position = $BarrelHolder/Barrel.global_position / 4
		shot.parent = self
		shot.parentname = name
		#adds spray
		var tempspray = spray + (recoiltime/1000)
		if tempspray >= MaxSpray:
			tempspray = MaxSpray
		shot.direction += rand_range(-tempspray,tempspray)
		ShotSpeed = 0
	#reduces Spray as time passes without shooting
	if shooting == false:
		if recoiltime >= 0:
			recoiltime -= delta * 100
		else:
			recoiltime = 0
	else:
		recoiltime += delta
	
	#checks if you released left click


func _physics_process(_delta):
	velocity = Vector2.ZERO
	if target != null:
		if shooting == true:
			pass
		elif shooting == false:
			velocity = Vector2(speed,0).rotated($BarrelHolder.rotation)
	else:
		velocity = RandVel
	move_and_slide = move_and_slide(velocity)


#func change weapon
func changeWeapon():
	if weapons.size() - 1 <= currentweapon:
		currentweapon = 0
	else:
		currentweapon += 1
	var temp = weapons[currentweapon]
	print("Switched to ",temp["name"])
	damage = temp["damage"]
	ShootingSpeed = temp["speed"]
	spray = temp["spray"]
	recoil = temp["recoil"]
	ShotSpeed = 0

#Reduces Health
func hit(dmg):
	health -= dmg 

func _on_Area2D_body_entered(body):
	if body == Auto.Player:
		target = Auto.Player
		shooting = true


func _on_Area2D_body_exited(body):
	if body == Auto.Player:
		shooting = false

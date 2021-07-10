extends KinematicBody2D

export var speed = 200.0
var velocity = Vector2()
var shooting = false
var ShotSpeed = 0
var move_and_slide
var recoil_timer
var recoiltime = 0
var currentweapon = 0

onready var target = null

var recoil = 1
var damage = 1
var spray = 1
var MaxSpray = 1
var ShootingSpeed = 0.15

var health = 100

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



var bullet = preload("res://Scenes/NotLevels/Ammo.tscn")

func _ready():
	changeWeapon()

func _process(delta):
	
	
	ShotSpeed += delta
	
	if health <= 0:
		pass
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

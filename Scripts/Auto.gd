extends Node

var MainScene = null
var Player = preload("res://Scenes/Player.tscn").instance()
var ingame = false

var resettimer = Timer

var EnemyBullet = preload("res://Scenes/NotLevels/AmmoEnemy.tscn")
var CurrentLevel = null

func reset():
	MainScene = preload("res://Scenes/Main.tscn").instance()
	Player = preload("res://Scenes/Player.tscn").instance()
	ingame = false
	CurrentLevel = null

func Start():
	if get_node_or_null("/root/Main/Level") != null:
		MainScene.queue_free()
		MainScene = preload("res://Scenes/Main.tscn").instance()
		reset()
	
	resettimer.start(0.5)


func _reset_2():
	if get_node_or_null("/root/Main") != null:
		get_node("/root").add_child(MainScene)
	CurrentLevel = load("res://Scenes/Levels/Level1.tscn").instance()
	get_node("/root").add_child(MainScene)
	MainScene = get_node("/root/Main")
	MainScene.add_child(Player)
	MainScene.add_child(CurrentLevel)
	ingame = true
	Player.global_position = CurrentLevel.get_node("SpawnPos").global_position

func EnemyDied(deadenemy):
	if CurrentLevel.get_node("Enemies").get_child_count() <= 1:
		ChangeLevel(CurrentLevel.level + 1)
		print("changing level to ")
	deadenemy.queue_free()
	Player.score += 1
	Player.get_node("HealthBar/Control/Label").text = str("Score = "+str(Player.score))

func playerdead():
	MainScene.get_node("GUI").add_child(preload("res://Scenes/MainMenu.tscn").instance())
	ingame = false

func ChangeLevel(level):
	if level <= 3:
		level = 1
	CurrentLevel.queue_free()
	CurrentLevel = load("res://Scenes/Levels/Level" + str(level) + ".tscn").instance()
	MainScene.add_child(CurrentLevel)

func _enter_tree():
	if get_node_or_null("/root/Main") != null:
		pass
		MainScene = get_node("/root/Main")
		MainScene.get_node("GUI").add_child(preload("res://Scenes/MainMenu.tscn").instance())
	else:
		pass

func _ready():
	resettimer = Timer.new()
	resettimer.connect("timeout",self,"_reset_2")	
	add_child(resettimer)
	resettimer.one_shot = true

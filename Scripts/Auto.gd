extends Node

var MainScene = null
var Player = preload("res://Scenes/Player.tscn").instance()
var ingame = false

var EnemyBullet = preload("res://Scenes/NotLevels/AmmoEnemy.tscn")
var CurrentLevel = null

func Start():
	CurrentLevel = load("res://Scenes/Levels/Level1.tscn").instance()
	MainScene.add_child(CurrentLevel)
	MainScene.add_child(Player)
	ingame = true
	Player.global_position = CurrentLevel.get_node("SpawnPos").global_position

func EnemyDied(deadenemy):
	if CurrentLevel.get_node("Enemies").get_child_count() <= 1:
		ChangeLevel(CurrentLevel.level + 1)
		print("changing level to ")
	deadenemy.queue_free()

func ChangeLevel(level):
	if level <= 3:
		level = 1
	CurrentLevel.queue_free()
	CurrentLevel = load("res://Scenes/Levels/Level" + str(level) + ".tscn").instance()
	MainScene.add_child(CurrentLevel)

func _ready():
	if get_node_or_null("/root/Main") != null:
		pass
		MainScene = get_node("/root/Main")
		MainScene.get_node("GUI").add_child(preload("res://Scenes/MainMenu.tscn").instance())
	else:
		pass

extends Node

var MainScene = null
var Player = preload("res://Scenes/Player.tscn").instance()
var ingame = false

var EnemyBullet = preload("res://Scenes/NotLevels/AmmoEnemy.tscn")


func Start():
	MainScene.add_child(Player)
	ingame = true

func _ready():
	if get_node_or_null("/root/Main") != null:
		pass
		MainScene = get_node("/root/Main")
		MainScene.get_node("GUI").add_child(preload("res://Scenes/MainMenu.tscn").instance())
	else:
		pass

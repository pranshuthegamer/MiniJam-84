extends Node

var MainScene = null

func _ready():
	if get_node_or_null("/root/Main") != null:
		pass
		MainScene = get_node("/root/Main")
		var tempscene = preload("res://Scenes/MainMenu.tscn").instance()
		MainScene.get_node("GUI").add_child(tempscene)
	else:
		pass

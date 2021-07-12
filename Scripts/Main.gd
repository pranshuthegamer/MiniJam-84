extends Node2D


func _enter_tree():
	if get_node_or_null("/root/Auto") == null:
		get_tree()
		pass

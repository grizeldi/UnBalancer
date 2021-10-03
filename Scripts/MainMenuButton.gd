extends Node

export var level_to_load : PackedScene;

func _on_Button_pressed():
	Globals.level_to_load = level_to_load;
	get_tree().change_scene("res://Scenes/Game.tscn")

extends Node2D
onready var menu = $Menu
onready var players = $Menu/VBoxContainer/CenterContainer2/HBoxContainer/OptionButton
onready var spawns = [$Spawn1,$Spawn2,$Spawn3,$Spawn4]
var player = preload("res://Player/Player.tscn")
func _on_Button_pressed():
	menu.hide()
	
	for i in range(players.selected+1):
		var player_instance = player.instance()
		player_instance.init(i+1, i+1)
		player_instance.position = spawns[i].position
		add_child(player_instance)

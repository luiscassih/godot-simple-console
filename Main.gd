extends Node2D

var console_open = false
var consoleScene = preload("res://Console/console.tscn")

func _process(delta):
	if (Input.is_action_just_pressed("toggle_console")):
		if !console_open:
			init_console()

func init_console():
	var console = consoleScene.instance()
	console._init_console(self, console)
	console_open = true

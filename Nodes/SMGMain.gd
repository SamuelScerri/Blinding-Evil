extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SMG").angle += .4
	get_node("SMG2").angle += .2
	
	get_node("SMG3").angle -= .4
	get_node("SMG4").angle -= .2

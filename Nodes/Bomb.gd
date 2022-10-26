extends Node2D

onready var location = get_global_mouse_position()
onready var explosion = preload("res://Nodes/Explosion.tscn")

func _ready():
	position = GameManager.player_node.position

func _physics_process(delta):
	position = position.move_toward(location, delta * 500)
	
	if position.distance_to(location) < 1:
		var explosion_instance = explosion.instance()
		explosion_instance.position = position
		GameManager.Root.add_child(explosion_instance)
		queue_free()

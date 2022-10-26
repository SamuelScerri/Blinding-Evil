extends KinematicBody2D

onready var player_position = GameManager.player_node.position
onready var direction = (GameManager.player_node.get_node("CollisionShape2D").position + GameManager.player_node.position - position).normalized()

func _physics_process(delta):
	
	
	var collide = move_and_collide(direction * TweakedValues.ADVANCED_ENEMY_PROJECTILE_SPEED * delta)
	if collide:
		if collide.collider.is_in_group("Player"):
			GameManager.TakeDamage(1)
			queue_free()

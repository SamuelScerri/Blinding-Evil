extends Area2D

var enabled = true

func _process(delta):
	if GameManager.player_health >= 0:
	
		var distance = position.distance_to(GameManager.player_node.position)
	
		if enabled:
			if distance < 100:
				position = position.move_toward(GameManager.player_node.position, delta * 500)
			if distance < 20:
				GameManager.AddSoul()
				#GameManager.FlashScreen()
				#GameManager.ShakeScreen(.1)
		
				get_node("AudioStreamPlayer").play()
				visible = false
		
				enabled = false


func _on_Soul_body_entered(body):
	#GameManager.souls_left -= 1
	#queue_free()
	pass


func _on_AudioStreamPlayer_finished():
	queue_free()

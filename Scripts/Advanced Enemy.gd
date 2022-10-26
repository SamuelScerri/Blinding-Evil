extends KinematicBody2D

var life = TweakedValues.BASIC_ENEMY_HEALTH

onready var sprite = get_node("Sprite")

var timer

var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 1
	add_child(timer)
	timer.start()
	
	pass # Replace with function body.

func _process(delta):
	modulate.r = lerp(modulate.r, 1, delta * 10)
	modulate.g = lerp(modulate.g, 1, delta * 10)
	modulate.b = lerp(modulate.b, 1, delta * 10)

func _physics_process(delta):
	if GameManager.player_health >= 0:
		var distance = position.distance_to(GameManager.player_node.position)
	
		var direction = GameManager.player_node.position - position
		direction = direction.normalized()
	
		if position.x < GameManager.player_node.position.x:
			get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false
	
	#if position.y < GameManager.player_node.position.y:
		#direction.y = TweakedValues.ADVANCED_ENEMY_SPEED * clamp(distance, -1, 1)
	#else: direction.y = -TweakedValues.ADVANCED_ENEMY_SPEED * clamp(distance, -1, 1)
	
	#modulate = Color(lerp(1, 0, life / 50), .5, .5)
	
		if life <= 0:
			GameManager.DropSoul(self.position)
			queue_free()
		else: update()
		
		if timer.time_left <= 0:
			if distance < 100:
				can_move = false
				GameManager.ThrowProjectile(position)
				get_node("Sprite").play("Throw")
				timer.start()
	
		if can_move:
			var collide = move_and_collide(TweakedValues.ADVANCED_ENEMY_SPEED * direction * delta, false)
		
			if distance < 32:
				pass
			#if collide.collider.is_in_group("Player"):
				#GameManager.player_node.current_speed = direction
				#GameManager.TakeDamage(1)
				#if GameManager.invinsibility_timer.time_left <= 0:
					#get_node("Sprite").play("Attack")


func _draw():
	var health_display = lerp(0, 32 / 4, float(life) / float(TweakedValues.ADVANCED_ENEMY_HEALTH))
	draw_line(Vector2(-health_display, 30), Vector2(health_display, 30), Color.white, 3)


func _on_Sprite_animation_finished():
	if get_node("Sprite").animation == "Throw":
		can_move = true
		get_node("Sprite").play("Walk")

extends Node2D

var life = TweakedValues.SHOTGUN_SHADOW_LIFETIME
var length_point = 0

onready var bullet_location = get_global_mouse_position()
onready var player_location = GameManager.player_node.position

onready var angle = bullet_location.angle_to_point(player_location)
onready var last_hit_position = player_location
var final_point = Vector2.ZERO
var intersected_list = []

var increase = 0

func _ready():
	#get_node("AudioStreamPlayer").play()
	position = player_location
	rotation = angle
	
	scale.x = lerp(0, 1, increase)
	scale.y = lerp(0, 1, increase)
	
	final_point = Vector2(player_location.x + cos(angle) * TweakedValues.SHOTGUN_RANGE, player_location.y + sin(angle) * TweakedValues.SHOTGUN_RANGE)
	

	#while ShootRay(last_hit_position):
		#var result = ShootRay(last_hit_position).collider
		
		#if result:
			#intersected_list.append(result)
			#last_hit_position = result.position
		
		
	if intersected_list.size() > 0:
		get_node("AudioStreamPlayer2").play()
		
	#for i in intersected_list:
		#GameManager.DamageEnemy(i, GameManager.PISTOL)

	#get_node("CollisionShape2D").position

func _physics_process(delta):
	
	#final_point = Vector2(player_location.x + cos(angle) * length_point, player_location.y + sin(angle) * length_point)
	
	#get_node("CPUParticles2D").position = final_point
	increase += delta * 10
	
	scale.x = lerp(0, 1, clamp(increase, 0, 1))
	scale.y = lerp(0, 1, clamp(increase, 0, 1))
	
	position = position.move_toward(final_point, delta * 500)
	
	if life <= 0:
		queue_free()
	else:
		life -= delta
		update()
		
	get_node("Polygon2D").modulate.a = lerp(0, 1, life / TweakedValues.SHOTGUN_SHADOW_LIFETIME)


func _draw():
	var final_position = final_point
	#draw_line(player_location, final_position, Color(.1, .1, .1, lerp(0, 1, life)), TweakedValues.PISTOL_THICC_BOY_LINE)


func _on_Shotgun_body_entered(body):
	var distance = position.distance_to(final_point)
	
	if distance > 1:
		if body.is_in_group("Enemy"):
			get_node("AudioStreamPlayer2").play()
			GameManager.DamageEnemy(body, GameManager.SHOTGUN)

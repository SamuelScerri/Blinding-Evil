extends Node2D

var life = TweakedValues.PISTOL_SHADOW_LIFETIME
var length_point = 0

onready var bullet_location = get_global_mouse_position()
onready var player_location = GameManager.player_node.position

onready var angle = bullet_location.angle_to_point(player_location)
onready var last_hit_position = player_location
var final_point = Vector2.ZERO
var first_point = Vector2.ZERO

var intersected_list = []

var distance = 640

func _ready():
	#get_node("AudioStreamPlayer").play()
	get_node("Line2D").points[0] = player_location
	
	
	final_point = Vector2(player_location.x + cos(angle) * 500, player_location.y + sin(angle) * 500)
	get_node("Line2D").points[1] = player_location
	
	intersected_list.append(GameManager.player_node)
	
	while ShootRay(last_hit_position):
		var result = ShootRay(last_hit_position).collider
		
		if result:
			intersected_list.append(result)
			
			distance = result.position.distance_to(player_location)
			#final_point = Vector2(player_location.x + cos(angle) * distance, player_location.y + sin(angle) * distance)
			break
		
		
	if intersected_list.size() > 0:
		get_node("AudioStreamPlayer2").play()
	
	
		
	for i in intersected_list:
		GameManager.DamageEnemy(i, GameManager.SMG)

	#get_node("CollisionShape2D").position

func ShootRay(position_ray):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position_ray, final_point, intersected_list)
	
	return result

func _physics_process(delta):
	#get_node("Line2D").width = lerp(5, 10, distance / 640)
	final_point = Vector2(player_location.x + cos(angle) * length_point, player_location.y + sin(angle) * length_point)
	first_point = Vector2(player_location.x + cos(angle) * (clamp(length_point - 100, 0, 9999)) , player_location.y + sin(angle) * (clamp(length_point - 100, 0, 9999)))
	
	#get_node("CPUParticles2D").position = final_point
	if length_point < distance:
		length_point += delta * TweakedValues.SMG_SPEED
	
	if life <= 0:
		queue_free()
	else:
		life -= delta
		update()
		
		get_node("Line2D").points[0] = first_point
		get_node("Line2D").points[1] = final_point
		get_node("Line2D").modulate.a = lerp(0, 1, life / TweakedValues.SMG_SHADOW_LIFETIME)


func _draw():
	var final_position = final_point
	#draw_line(player_location, final_position, Color(.1, .1, .1, lerp(0, 1, life)), TweakedValues.PISTOL_THICC_BOY_LINE)

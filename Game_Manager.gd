extends Node2D

var player_health = TweakedValues.PLAYER_START_HEALTH
var player_level = TweakedValues.PLAYER_START_LEVEL

var explosion_cooldown = 0

var current_weapon = null

#Just For Convenience
var player_node = null

var shake_screen = false
var current_weapon_selected = 0

var current_level = 0

var player_reloading_time = 0

var souls_collected = 0

var invinsibility_timer
var total_souls_collected = 0

var timer

#Gets The UI Elements
onready var camera = get_node("Camera")
onready var health_label = get_node("Health")
onready var level_label = get_node("Level")
onready var canvas = get_node("CanvasModulate")
onready var xp_bar = get_node("XpBar")
onready var full_health = get_node("Full")
onready var empty_health = get_node("Empty")

#Weapon Types, This Is For The Array weapon_hud Below
enum {
	PISTOL,
	SHOTGUN,
	SMG,
	GRENADE_LAUNCHER
}

var unlocked_weapons = [PISTOL]

var weapon_multiplier = [
	1, 1, .1, 4
]



onready var weapon_hud = [
	get_node("Weapon 1"),
	get_node("Weapon 2"),
	get_node("Weapon 3"),
	get_node("Weapon 4")
]

onready var level_up_menu = get_node("Level Up Screen")
onready var switch_sound = get_node("Switch")

#Load Actual Weapons
onready var weapon_nodes = [
	preload("res://Nodes/Pistol.tscn"),
	preload("res://Nodes/Shotgun.tscn"),
	preload("res://Nodes/SMGMain.tscn"),
	preload("res://Nodes/Bomb.tscn")
]

onready var projectile = preload("res://Nodes/Projectile.tscn")

onready var enemy_nodes = [
	preload("res://Nodes/Basic Enemy.tscn"),
	preload("res://Nodes/Advanced Enemy.tscn")
]

onready var soul = preload("res://Nodes/Soul.tscn")

onready var Root = get_tree().get_current_scene()

func _ready():
	level_up_menu.get_child(0).visible = false
	
	timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = float(TweakedValues.TIME_BETWEEN_ENEMY_SPAWN) / float((player_level + 1))
	
	invinsibility_timer = Timer.new()
	invinsibility_timer.one_shot = true
	invinsibility_timer.wait_time = TweakedValues.PLAYER_INVINSIBILITY_TIMER
	
	add_child(invinsibility_timer)
	add_child(timer)
	timer.connect("timeout", self, "SpawnEnemy")
	timer.start()
	invinsibility_timer.start()
	
	#Hide The Mouse And Set The Level & Health
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SwitchWeapon(PISTOL)
	SetLevel(TweakedValues.PLAYER_START_LEVEL)
	SetHealth(TweakedValues.PLAYER_START_HEALTH)
	
	print("Game Manager Loaded!")

#Again, Just For Convenience
func SetPlayerNode(node: KinematicBody2D):
	if node:
		self.player_node = node


func ContinueGame():
	get_node("AudioStreamPlayer").volume_db = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	level_up_menu.get_child(0).visible = false
	get_tree().paused = false
	timer.wait_time = float(TweakedValues.TIME_BETWEEN_ENEMY_SPAWN) / player_level
	print(timer.wait_time)
	
	timer.start()

#Self Explanatory
func LevelUp(amount: float):
	get_node("AudioStreamPlayer").volume_db = -10
	souls_collected = 0
	
	player_level += amount
	
	if player_level >= TweakedValues.EXPLOSION_LOCKED_UNTIL:
		weapon_hud[GRENADE_LAUNCHER].modulate = Color(1, 1, 1)
		get_node("Level Up Screen").get_child(0).get_node("Multiplier4").text = "GRENADE LAUNCHER UNLOCKED!"
		unlocked_weapons.append(GRENADE_LAUNCHER)
		
	elif player_level >= TweakedValues.SMG_LOCKED_UNTIL:
		weapon_hud[SMG].modulate = Color(1, 1, 1)
		get_node("Level Up Screen").get_child(0).get_node("Multiplier4").text = "SMG UNLOCKED!"
		unlocked_weapons.append(SMG)
	
	elif player_level >= TweakedValues.SHOTGUN_LOCKED_UNTIL:
		weapon_hud[SHOTGUN].modulate = Color(1, 1, 1)
		get_node("Level Up Screen").get_child(0).get_node("Multiplier4").text = "SHOTGUN UNLOCKED!"
		unlocked_weapons.append(SHOTGUN)
	
	
	level_label.text = str(player_level)
	timer.stop()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	level_up_menu.get_child(0).visible = true
	

func SetLevel(amount: int):
	player_level = amount
	level_label.text = str(player_level)

func TakeDamage(amount: float):
	
	#if invinsibility_timer.time_left <= 0:
		player_health -= amount
		
		ShakeScreen(.1)
		FlashScreen()
		
		get_node("AudioStreamPlayer2").play()
		
		health_label.text = "Health: " + str(player_health)
		full_health.modulate.a = player_health / TweakedValues.PLAYER_START_HEALTH
	
		if player_health >= 0:
			player_node.modulate = Color(.5, 0, 0)
		full_health.scale = Vector2(.5, .5)
	
		if player_health < 0:
			for i in range(total_souls_collected):
				var random_pos = Vector2(rand_range(-total_souls_collected * 2, total_souls_collected * 2), rand_range(-total_souls_collected * 2, total_souls_collected * 2))
				DropSoul(player_node.position + random_pos)
			player_node.queue_free()
			
		
		invinsibility_timer.start()

func SetHealth(amount: int):
	player_health = amount
	health_label.text = "Health: " + str(player_health)

func ThrowProjectile(position_at: Vector2):
	var proj_instance = projectile.instance()
	proj_instance.position = position_at
	Root.add_child(proj_instance)

#Switch The Weapon, Not Really Implemented Yet..
func SwitchWeapon(weapon_index: int):
	if weapon_index != current_weapon_selected && weapon_index < unlocked_weapons.size() && weapon_index >= 0:
		
		switch_sound.play()
		
		#Reset Weapon Modulation (Will Be Changed Later)
		for i in range(weapon_hud.size()):
			for weapon_check in unlocked_weapons:
				if i == weapon_check:
					weapon_hud[i].modulate = Color(1, 1, 1)
	
		#weapon_hud[weapon_index].modulate = Color(1, 0, 0)
		
		#Then Of Course, Change The Currently Selected Weapon
		current_weapon_selected = weapon_index

#This Will Shoot With The Currently Selected Weapon
func ShootBullet():
	if player_health >= 0:
	
		if player_reloading_time <= 0:
			if current_weapon_selected == GRENADE_LAUNCHER:
				if explosion_cooldown <= 0:
					var shot_weapon = weapon_nodes[current_weapon_selected].instance()
					Root.add_child(shot_weapon)
	
					GameManager.ShakeScreen(.2)
					player_reloading_time = TweakedValues.PLAYER_RELOAD_TIME
					explosion_cooldown = TweakedValues.EXPLOSION_COOLDOWN
		
			else:
				var shot_weapon = weapon_nodes[current_weapon_selected].instance()
				Root.add_child(shot_weapon)
	
				GameManager.ShakeScreen(.2)
				player_reloading_time = TweakedValues.PLAYER_RELOAD_TIME
		

#Stupid Shaking Garbage
func DisableShake():
	shake_screen = false
	camera.set_offset(Vector2.ZERO)

func ShakeScreen(seconds: float):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = seconds
	add_child(timer)
	timer.start()
	
	shake_screen = true
	timer.connect("timeout", self, "DisableShake")
	timer.start()

func DamageEnemy(enemy, type):
	if enemy.is_in_group("Enemy"):
		enemy.life -= weapon_multiplier[type]
		enemy.modulate = Color(.5, 0, 0)

func DropSoul(position_given: Vector2):
	var soul_instance = soul.instance()
	soul_instance.position = position_given
	
	Root.add_child(soul_instance)
	
func AddSoul():
	souls_collected += TweakedValues.SOULS_INCREASE / (player_level + 1)
	total_souls_collected += 1
	
	update()
	
	if souls_collected >= TweakedValues.SOULS_TO_LEVEL_UP:
		LevelUp(1)
		

func FlashScreen():
	canvas.color = Color(.5, 0, 0)

func _process(delta):
	if player_health <= 0:
		get_node("Death").visible = true
		
		#if Input.is_action_just_pressed("click"):
			#get_tree().reload_current_scene()
			#Root = get_tree().get_current_scene()
	
	explosion_cooldown -= delta
	
	if shake_screen:
		camera.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * TweakedValues.SHAKE_AMOUNT, \
		rand_range(-1.0, 1.0) * TweakedValues.SHAKE_AMOUNT \
		))
	
	#Player Is Reloading
	if player_reloading_time > 0:
		player_reloading_time -= delta
	
	#Simple Select Animation Cause I Like Wasting Time!
	for i in range(weapon_hud.size()):
		if i == current_weapon_selected:
			weapon_hud[i].scale.x = lerp(weapon_hud[i].scale.x, 1.25, delta * 10)
			weapon_hud[i].scale.y = lerp(weapon_hud[i].scale.y, 1.25, delta * 10)
		else:
			weapon_hud[i].scale.x = lerp(weapon_hud[i].scale.x, .75, delta * 10)
			weapon_hud[i].scale.y = lerp(weapon_hud[i].scale.y, .75, delta * 10)
			
	canvas.color.r = lerp(canvas.color.r, 1, delta * 10)
	canvas.color.g = lerp(canvas.color.g, 1, delta * 10)
	canvas.color.b = lerp(canvas.color.b, 1, delta * 20)
	
	if GameManager.player_health >= 0:
		player_node.modulate.r = lerp(player_node.modulate.r, 1, delta * 10)
		player_node.modulate.g = lerp(player_node.modulate.g, 1, delta * 10)
		player_node.modulate.b = lerp(player_node.modulate.b, 1, delta * 10)

	full_health.scale.x = lerp(full_health.scale.x, 0.375, delta * 10)
	full_health.scale.y = lerp(full_health.scale.y, 0.375, delta * 10)
	empty_health.scale = full_health.scale

func SpawnEnemy():
	var i = clamp(randi() & 1, 0, enemy_nodes.size())
	
	var enemy = enemy_nodes[i].instance()
	
	enemy.position.y = rand_range(0, 480)
	enemy.position.x = (randi() & 1) * 640
	Root.add_child(enemy)


#Mainly For The XP Bar
func _draw():
	var lerped = lerp(xp_bar.position.x + xp_bar.texture.get_width() / 4.57, xp_bar.position.x - xp_bar.texture.get_width() / 4.57, 1 - souls_collected / float(TweakedValues.SOULS_TO_LEVEL_UP))
	
	draw_line(Vector2(xp_bar.position.x - xp_bar.texture.get_width() / 4.57, xp_bar.position.y), Vector2(lerped, xp_bar.position.y), Color(0, 0.5, 1, 0.5), 9.3)

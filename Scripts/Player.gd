extends KinematicBody2D

var current_speed = Vector2()
var should_move = true

func _ready():
	GameManager.SetPlayerNode(self)

func _process(_delta):
	
	if should_move:
	
		if Input.is_action_just_pressed("click"):
		
			GameManager.ShootBullet()
	
		#This Is Awful... But It Works!
		if Input.is_key_pressed(KEY_1):
			GameManager.SwitchWeapon(GameManager.PISTOL)
		
		if Input.is_key_pressed(KEY_2):
			GameManager.SwitchWeapon(GameManager.SHOTGUN)
	
		if Input.is_key_pressed(KEY_3):
			GameManager.SwitchWeapon(GameManager.SMG)
	
		if Input.is_key_pressed(KEY_4):
			GameManager.SwitchWeapon(GameManager.GRENADE_LAUNCHER)
		
		update()

func _physics_process(delta):
	if should_move:
	
		var x_direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		var y_direction = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

		current_speed.x += x_direction * TweakedValues.PLAYER_ACCELERATION
		current_speed.y += y_direction * TweakedValues.PLAYER_ACCELERATION
	
		current_speed.x = clamp(current_speed.x, -TweakedValues.PLAYER_MAX_SPEED, TweakedValues.PLAYER_MAX_SPEED)
		current_speed.y = clamp(current_speed.y, -TweakedValues.PLAYER_MAX_SPEED, TweakedValues.PLAYER_MAX_SPEED)
	
	
		if !x_direction:
			current_speed.x = lerp(current_speed.x, 0, TweakedValues.PLAYER_DECELERATION)
		if !y_direction:
			current_speed.y = lerp(current_speed.y, 0, TweakedValues.PLAYER_DECELERATION)
		
		move_and_collide(current_speed * delta, false)
	
		position.x = clamp(position.x, 0, 640)
		position.y = clamp(position.y, 0, 480)

func _draw():
	draw_line(Vector2(-round(GameManager.player_reloading_time * 5), -32), Vector2(round(GameManager.player_reloading_time * 5), -32), Color.white, 3)

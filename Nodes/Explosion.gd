extends Area2D


var life = TweakedValues.PISTOL_SHADOW_LIFETIME


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite").play("default")
	GameManager.ShakeScreen(1)


func _process(delta):
	life -= delta
	
	if life < 0:
		queue_free()
	else: update()


func _on_AnimatedSprite_animation_finished():
	get_node("CollisionShape2D").disabled = true
	get_node("AnimatedSprite").visible = false


func _on_ESXLPLPASWOPKION_body_entered(body):
	if body.is_in_group("Enemy"):
		GameManager.DamageEnemy(body, GameManager.GRENADE_LAUNCHER)

func _draw():
	draw_circle(Vector2.ZERO, 48, Color(0, 0, 0, lerp(0, 1, life / TweakedValues.PISTOL_SHADOW_LIFETIME)))

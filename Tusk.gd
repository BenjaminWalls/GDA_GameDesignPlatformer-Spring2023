extends KinematicBody2D

var velocity = Vector2(0,0)
const SPEED = 100
const JUMPFORCE = -400
const GRAVITY = 30
var direction = 1

func _physics_process(delta):
	# print(is_near_wall())
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
	
	if not is_on_floor():
		$Sprite.play("jump")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	set_direction()
	
	velocity.x = lerp(velocity.x,0,0.4)

func set_direction():
	direction = 1 if not $Sprite.flip_h else -1
	$wallchecker.rotation_degrees = 90 * -direction

func is_near_wall():
	return $wallchecker.is_colliding()

func _on_LOL_DEATH_ZONE_body_entered(body):
	get_tree().change_scene("res://firstlevel.tscn")

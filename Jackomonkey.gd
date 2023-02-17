extends KinematicBody2D

var velocity = Vector2(0,0)
const SPEED = 300
const GRAVITY = 40
const JUMPFORCE = -750

func _physics_process(delta):                # Physics function
	if Input.is_action_pressed("right"):        # moving right changes velocity, plays walk animation, and flips sprite
		velocity.x = SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):       # moving left changes velocity, plays walk animation, and flips sprite
		velocity.x = -SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = true
	else:                                       # idle animation for not moving left or right
		$Sprite.play("idle")
	
	if not is_on_floor():                       # falling animation for not touching the ground
		$Sprite.play("air")
	
	velocity.y = velocity.y + GRAVITY           # Accelerated gravity over time
	
	if Input.is_action_just_pressed("jump") and is_on_floor(): # jumping !! only once AND only on the floor
		velocity.y = JUMPFORCE
	
	
	velocity = move_and_slide(velocity, Vector2.UP) # resets gravity every time you are on the floor so it doesnt compound over time
	
	velocity.x = lerp(velocity.x, 0, 0.2) # slowing down left and right speed

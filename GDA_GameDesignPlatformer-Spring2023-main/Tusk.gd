extends KinematicBody2D

var velocity = Vector2(0,0)
const SPEED = 100
const JUMP_SPEED = 360
const GRAVITY = 1000
var JUMP_END_MULTIPLIER = 5
var direction = 1
var HORIZONTAL_ACCELERATION = 750
var MAX_HORIZONTAL_SPEED = 80
onready var coyote_timer = $CoyoteTimer
onready var buffer_timer = $BufferTimer
onready var animated_sprite = $Sprite

func _physics_process(delta):
		#gets input and puts into 2d vector
	var input_vector = get_input_vector()
	
		#sets the x velocity by multiplying it by the horizontal accel
	velocity.x += input_vector.x * HORIZONTAL_ACCELERATION * delta
	
		#Decelerates the players velocity once they stop inputting left or right
	if input_vector.x == 0:
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
		#Clamps players velocity between -2000 and 2000
	velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	
		#starts the input buffer for the jump
	if input_vector.y < 0:
		buffer_timer.start()
	
		#Jumps if the buffer time is active and either the player is on the floor OR the coyote timer is active
	if !buffer_timer.is_stopped() && (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = input_vector.y * JUMP_SPEED
		buffer_timer.stop()

		#Adds variable jumping by placing a force in the opposite direction of the jump
			#Otherwise adds gravity like normal.
	if velocity.y < 0 && !Input.is_action_pressed("jump"):
		velocity.y += GRAVITY * JUMP_END_MULTIPLIER * delta
	else:
		velocity.y += GRAVITY * delta
		
		#gets if the player was on the floor in the previous call (MUST be done before move_and_slide is called)
	var was_on_floor = is_on_floor()
	
		#moves the player
	velocity = move_and_slide(velocity, Vector2.UP)
	
		#sets the coyote timer for jumping if the player was on the floor last call and not on this one.
	if was_on_floor && !is_on_floor():
		coyote_timer.start()

	update_animation(input_vector)

func is_near_wall():
	return $wallchecker.is_colliding()

func _on_LOL_DEATH_ZONE_body_entered(body):
	get_tree().change_scene("res://firstlevel.tscn")


func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector

func update_animation(input_vector):
	if !is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	elif input_vector.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	
	if input_vector.x != 0:
		animated_sprite.flip_h = true if input_vector.x < 0 else false
	
	$wallchecker.rotation_degrees = 90 * -direction

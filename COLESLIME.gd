extends KinematicBody2D

var SPEED = 20
var velocity = Vector2()
export var direction = -1
export var detects_cliffs = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floorchecker.enabled = detects_cliffs


func _physics_process(delta):
	
	if is_on_wall() or not $floorchecker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = SPEED * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_TOP_CHECKER_body_entered(body):
	$AnimatedSprite.play("squash")
	SPEED = 0
	
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	
	$TOP_CHECKER.set_collision_layer_bit(4,false)
	$TOP_CHECKER.set_collision_mask_bit(0,false)
	
	$SIDE_CHECKER.set_collision_layer_bit(4,false)
	$SIDE_CHECKER.set_collision_mask_bit(0,false)
	
	$Timer.start()
	


func _on_SIDE_CHECKER_body_entered(body):
	get_tree().change_scene("res://firstlevel.tscn")


func _on_Timer_timeout():
	queue_free()

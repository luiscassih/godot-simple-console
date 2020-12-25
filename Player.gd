extends KinematicBody2D
export var speed = 200 setget _on_set_speed
	
func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_just_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

func _on_set_speed(new_speed):
	speed = new_speed
	print("new speed set to ", speed)

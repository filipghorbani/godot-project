extends KinematicBody2D

var SPEED = 100
var ACC = 500
var GRAVITY = 8
var JUMP_FORCE = 260
var FRICTION = 1
var RESISTANCE = 1
var forces_vector = Vector2.ZERO
onready var sprite = $Sprite
onready var animationplayer = $AnimationPlayer

func _physics_process(delta):
	
	run()
	flip()
	jump()
	friction()
	gravity()
	texture()
	respawn()
	
	forces_vector = move_and_slide(forces_vector,Vector2(0,-1))

func run():
	forces_vector.x = Input.get_action_strength("ui_right")*SPEED - Input.get_action_strength("ui_left")*SPEED

func flip():
	if forces_vector.x != 0:
		sprite.flip_h = forces_vector.x < 0

func jump():
	if is_on_floor():
		forces_vector.y = 0
		if Input.is_action_pressed("ui_up"):
			forces_vector.y -= JUMP_FORCE
	if forces_vector.y < 0 and Input.is_action_just_released("ui_up"):
		forces_vector.y *= 0.5

func friction():
	if is_on_floor():
		forces_vector.x *= FRICTION
	else:
		forces_vector.x *= RESISTANCE

func gravity():
	forces_vector.y += GRAVITY

func texture():
	if not is_on_floor():
		animationplayer.play("Fall")
	else:
		if forces_vector.x != 0:
			animationplayer.play("Run")
		else:
			animationplayer.play("Idle")

func respawn():
	if position.y > get_viewport_rect().end.y:
		forces_vector.y = GRAVITY
		position.x = get_viewport_rect().end.x/2
		position.y = get_viewport_rect().end.y/10

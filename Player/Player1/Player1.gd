extends KinematicBody2D

export var player_name = ""
var SPEED = 100
var ACC = 500
var O_GRAVITY = 8
var GRAVITY = 8
var JUMP_FORCE = 200
var FRICTION = 1
var RESISTANCE = 1
var jumps = 1
var MAX_HP = 10
var forces_vector = Vector2.ZERO
var bullet_speed = 250
var can_fire = true
onready var sprite = $Sprite
onready var animationplayer = $AnimationPlayer
onready var left = $RayCast2DLeft
onready var right = $RayCast2DRight
onready var bullet_spawn = $BulletSpawn
onready var hp_bar = $HPBar
var bullet = preload("res://Player/Bullet.tscn")

func _ready():
	hp_bar.max_value = MAX_HP
	hp_bar.value = MAX_HP
	
func _physics_process(delta):
	
	run()
	flip()
	jump()
	friction()
	gravity()
	texture()
	check_bounds()
	fire()
	
	forces_vector = move_and_slide(forces_vector,Vector2(0,-1))

func run():
	forces_vector.x = Input.get_action_strength("ui_right")*SPEED - Input.get_action_strength("ui_left")*SPEED

func flip():
	if forces_vector.x != 0:
		sprite.flip_h = forces_vector.x < 0

func jump():
	if is_on_floor():
		jumps = 1
		forces_vector.y = 0
		if Input.is_action_just_pressed("ui_up"):
			forces_vector.y -= JUMP_FORCE
	else: 
		if Input.is_action_just_pressed("ui_up") and jumps > 0:
			jumps -= 1
			forces_vector.y = min(forces_vector.y - JUMP_FORCE, -JUMP_FORCE)
	if forces_vector.y < 0 and Input.is_action_just_released("ui_up"):
		forces_vector.y *= 0.5

func friction():
	if is_on_floor():
		forces_vector.x *= FRICTION
	else:
		forces_vector.x *= RESISTANCE

func gravity():
	forces_vector.y += GRAVITY
	if left.is_colliding() and forces_vector.x < 0 and forces_vector.y > GRAVITY*5:
		forces_vector.y = GRAVITY*5
		animationplayer.play("Slide")
		
	if right.is_colliding() and forces_vector.x > 0 and forces_vector.y > GRAVITY*5:
		forces_vector.y = GRAVITY*5
		animationplayer.play("Slide")
		

func texture():
	if not is_on_floor():
		if left.is_colliding() or right.is_colliding():
			animationplayer.play("Slide")
		else:
			animationplayer.play("Fall")
	else:
		if forces_vector.x != 0:
			animationplayer.play("Run")
		else:
			animationplayer.play("Idle")

func check_bounds():
	if position.y > get_viewport_rect().end.y:
		respawn()
		
func respawn():
	forces_vector.y = GRAVITY
	position.x = get_viewport_rect().end.x/2
	position.y = get_viewport_rect().end.y/10
	hp_bar.value = MAX_HP
		
func fire():
	if Input.is_action_pressed("ui_accept") and can_fire:
		var bullet_instance = bullet.instance()
		var dir = -1 if sprite.flip_h else 1
		var pos = get_global_position()
		bullet_instance.position = Vector2(pos.x + 10 * dir, pos.y + rand_range(1,4))
		bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed * dir, 0))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(0.2), "timeout")
		can_fire = true
		
func shot(dmg): 
	hp_bar.value -= dmg
	if hp_bar.value < 1:
		respawn()
		
		

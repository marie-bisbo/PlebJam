extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D

enum state {IDLE, RUNNING, JUMPING, ATTACKING, ROLLING}

var current_state = state.IDLE

func _physics_process(delta):
	set_current_state()
	
	match current_state:
		state.IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animated_sprite.play("idle")
		state.RUNNING:
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * SPEED
				animated_sprite.play("run")
				animated_sprite.flip_h = direction < 0
		state.JUMPING:
			velocity += get_gravity() * delta
			animated_sprite.play("jump")
		state.ATTACKING:
			animated_sprite.play("attack")
		state.ROLLING:
			pass

	move_and_slide()

func set_current_state():
	if Input.is_action_just_pressed("attack"):
		current_state = state.ATTACKING
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			current_state = state.JUMPING
		else:
			var direction = Input.get_axis("move_left", "move_right")
			current_state = state.RUNNING if direction else state.IDLE
			
func idle():
	pass
	
func run():
	pass
	
func jump():
	pass
	
func attack():
	pass
	
func roll():
	pass

extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var anim_tree = $AnimationTree
@onready var camera_2d = $Camera2D

enum state {IDLE, RUNNING, JUMPING, ATTACKING, ROLLING}

var current_state = state.IDLE

func _physics_process(delta):
	set_current_state()
	
	match current_state:
		state.IDLE:
			idle()
		state.RUNNING:
			run()
		state.JUMPING:
			jump(delta)
		state.ATTACKING:
			attack()
		state.ROLLING:
			roll()

	move_and_slide()

func set_current_state():
	if Input.is_action_just_pressed("attack") and current_state != state.JUMPING:
		current_state = state.ATTACKING
	elif current_state != state.ATTACKING:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			current_state = state.JUMPING
		else:
			var direction = Input.get_axis("move_left", "move_right")
			current_state = state.RUNNING if direction else state.IDLE
			
func idle():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	anim_tree.get("parameters/playback").travel("Idle")
	
func run():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		anim_tree.get("parameters/playback").travel("Run")
		animated_sprite.flip_h = direction < 0
	
func jump(delta):
	velocity += get_gravity() * delta
	anim_tree.get("parameters/playback").travel("Jump")
	
func attack():
	anim_tree.get("parameters/playback").travel("Attack")
	
func roll():
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack":
		current_state = state.IDLE

extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var anim_tree = $AnimationTree
@onready var camera_2d = $Camera2D

var attacking = false
var rolling = false

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		attacking = true
	
	if Input.is_action_just_pressed("roll"):
		if is_on_floor() and abs(velocity.x) > 0:
			rolling = true
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
			animated_sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack":
		attacking = false
	elif anim_name == "roll":
		rolling = false

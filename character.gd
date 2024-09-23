extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var anim_tree = $AnimationTree
@onready var camera_2d = $Camera2D

var attacking = false
var rolling = false

var position_offset = Vector2(0, -20)
var attack_range = Vector2(50, -20)

var attack_amount = 50

func _physics_process(delta):	
	if Input.is_action_just_pressed("attack"):
		attacking = true
		# Raycast
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position + position_offset, position + attack_range)
		query.exclude = [self, $"../Thing"]
		var result = space_state.intersect_ray(query)
		if (result):
			result.collider.deal_damage(attack_amount)
	
	if Input.is_action_just_pressed("roll"):
		if is_on_floor() and abs(velocity.x) > 0:
			rolling = true
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
		attack_range.x *= -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _draw():
	# draw_line(position_offset, attack_range, Color.CHARTREUSE, 1.0)
	pass
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack":
		attacking = false
	elif anim_name == "roll":
		rolling = false

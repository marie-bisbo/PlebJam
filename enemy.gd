extends StaticBody2D

@export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deal_damage(amount):
	health -= amount
	if (health <= 0):
		queue_free()

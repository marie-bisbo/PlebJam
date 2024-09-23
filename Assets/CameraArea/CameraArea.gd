extends Area2D

@onready var area = $Area

func _on_body_entered(body):
	if body.is_in_group("player"):
		var viewport_rect = get_viewport_rect().size / body.camera_2d.zoom.x
		body.camera_2d.limit_left = area.global_position.x - max(area.shape.size.x, viewport_rect.x) * 0.5
		body.camera_2d.limit_right = area.global_position.x + max(area.shape.size.x, viewport_rect.x) * 0.5
		body.camera_2d.limit_top = area.global_position.y - max(area.shape.size.y, viewport_rect.y) * 0.5
		body.camera_2d.limit_bottom = area.global_position.y + max(area.shape.size.y, viewport_rect.y) * 0.5

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.camera_2d.limit_left = -10000000
		body.camera_2d.limit_right = +1000000
		body.camera_2d.limit_top = -10000000
		body.camera_2d.limit_bottom = +1000000

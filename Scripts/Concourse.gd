extends TileMap

export(Vector2) var size: Vector2 = Vector2(16, 4) setget set_size, get_size

var start: Vector2 setget , get_start
var end: Vector2 setget , get_end


func randomize_gates() -> void:
	pass # TODO


func randomize_kiosks() -> void:
	pass # TODO


func _update_size() -> void:
	pass


func set_size(value: Vector2) -> void:
	assert(fmod(value.x, 1) == 0 and fmod(value.y, 1) == 0)
	assert(value.x >= 3 and value.y >= 3)
	_update_size()


func get_size() -> Vector2:
	_update_size()
	return size


func get_start() -> Vector2:
	return start


func get_end() -> Vector2:
	return end



extends TileMap

const GATE_SCENE := preload("res://Scenes/Gate.tscn")
const KIOSK_SCENE := preload("res://Scenes/Kiosk.tscn")

export(Vector2) var min_hub_size := Vector2(4, 4)
export(Vector2) var max_hub_size := Vector2(16, 16)

export(float) var terminal_generation_chance := 1
export(Vector2) var min_terminal_size := Vector2(4, 4)
export(Vector2) var max_terminal_size := Vector2(4, 16)
export(float) var terminal_spacing := 4

export(float) var concourse_generation_chance := 0.5
export(Vector2) var min_concourse_size := Vector2(2, 2)
export(Vector2) var max_concourse_size := Vector2(2, 8)
export(float) var concourse_spacing := 2

export(float) var gate_generation_chance := 0.5
export(Vector2) var min_gate_size := Vector2(1, 2)
export(Vector2) var max_gate_size := Vector2(1, 4)
export(float) var gate_spacing := 2

enum Tile {
	Floor,
	Wall = 8,
}

var kiosks := []
var gates := []



func _ready() -> void:
	randomize()
	clear()
	var hub_rect := generate_hub(min_hub_size, max_hub_size)
	var term_rects := generate_satellites(hub_rect, min_terminal_size, max_terminal_size, terminal_spacing, 1)
	var concourse_rects := []
	for rect in term_rects:
		concourse_rects.append_array(generate_satellites(rect, min_concourse_size, max_concourse_size, concourse_spacing, 2))
	var gate_rects := []
	for rect in concourse_rects:
		gate_rects.append_array(generate_satellites(rect, min_gate_size, max_gate_size, gate_spacing, 3))
	_build_walls()


func get_num_gates() -> int:
	return gates.size()


func randomize_gates() -> void:
	pass # TODO


func randomize_kiosks() -> void:
	pass # TODO


func _build_walls() -> void:
	for cell in get_used_cells():
		for x in range(-1, 2):
			for y in range(-1, 2):
				if get_cell(cell.x + x, cell.y + y) == INVALID_CELL:
					set_cell(cell.x + x, cell.y + y, Tile.Wall)


func _random_int(minimum: int, maximum: int) -> int:
	return minimum + ((randi() % (maximum - minimum)) if maximum > minimum else 0)


func _random_vector(minimum: Vector2, maximum: Vector2 = - Vector2.ONE) -> Vector2:
	if maximum.x < 0 and maximum.y < 0:
		maximum = minimum
		minimum = Vector2.ZERO
	if minimum == maximum:
		return minimum
	var x: int = minimum.x + (randi() % int(maximum.x - minimum.x)) if maximum.x > minimum.x else 0
	var y: int = minimum.y + (randi() % int(maximum.y - minimum.y)) if maximum.y > minimum.y else 0
	return Vector2(x, y)


func _check_rect(rect: Rect2) -> bool:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			if get_cell(x, y) != INVALID_CELL:
				return false
	return true


func _build_rect(rect: Rect2, tile: int = Tile.Floor) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			set_cell(x, y, tile)


func generate_hub(min_size: Vector2 = Vector2(16, 16),
				  max_size: Vector2 = Vector2(20, 20)) -> Rect2:
	assert(min_size <= max_size)
	assert(int(min_size.x) % 2 == 0 and
		   int(min_size.y) % 2 == 0 and
		   int(max_size.x) % 2 == 0 and
		   int(max_size.y) % 2 == 0)
	var hub_size := _random_vector(min_size / 2, max_size / 2) * 2
	var hub_rect := Rect2(- hub_size / 2, hub_size)
	if _check_rect(hub_rect):
		_build_rect(hub_rect)
	return hub_rect


func generate_satellites(base_rect: Rect2,
						min_size: Vector2,
						max_size: Vector2,
						spacing: int,
						color: int = 0) -> Array:
	var start_x = base_rect.position.x
	var start_y = base_rect.position.y
	var end_x = base_rect.end.x
	var end_y = base_rect.end.y
	
	var rects := []

	for y in [start_y, end_y]:
		var possible := range(start_x + max_size.x / 2, end_x - max_size.x / 2 - 1)
		possible.shuffle()
		for x in possible:
			var short := _random_int(min_size.x, max_size.x)
			var long := _random_int(min_size.y, max_size.y)
			var rect := Rect2(x, end_y if y == end_y else (start_y - long), short, long)
			if !_check_rect(rect):
				continue
			_build_rect(rect, color)
			rects.append(rect)
			for margin in range(x - short / 2 - spacing, x + short / 2 + spacing):
				possible.erase(margin)
	for x in [start_x, end_x]:
		var possible := range(start_y + max_size.x / 2, end_y - max_size.x / 2 - 1)
		possible.shuffle()
		for y in possible:
			var short := _random_int(min_size.x, max_size.x)
			var long := _random_int(min_size.y, max_size.y)
			var rect := Rect2(end_x if x == end_x else (start_x - long), y, long, short)
			if !_check_rect(rect):
				continue
			_build_rect(rect, color)
			rects.append(rect)
			for margin in range(y - short / 2 - spacing, y + short / 2 + spacing):
				possible.erase(margin)
	return rects


func generate_concourses(terminal_rects: Array) -> Array:
	return []


func generate_gates(concourse_rects: Array) -> Array:
	return []

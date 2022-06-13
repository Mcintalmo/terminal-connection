extends TileMap

const GATE_SCENE := preload("res://Scenes/Gate.tscn")
const KIOSK_SCENE := preload("res://Scenes/Kiosk.tscn")

export(float) var hub_side_chance := 0.5
export(float) var terminal_generation_chance := 1
export(float) var terminal_spacing := 4
export(float) var concourse_generation_chance := 0.5
export(float) var concourse_spacing := 2
export(float) var gate_generation_chance := 0.5
export(float) var gate_spacing := 1

enum Tile {
	Floor,
	Wall = 8,
}

var kiosks := []
var gates := []



func _ready() -> void:
	randomize()
	clear()
	var hub_rect := generate_hub()
	var term_rects := generate_terminals(hub_rect)
	_build_rect(hub_rect)
	for term in term_rects:
		_build_rect(term, 1)


func get_num_gates() -> int:
	return gates.size()


func randomize_gates() -> void:
	pass # TODO


func randomize_kiosks() -> void:
	pass # TODO


func _build_walls() -> void:
	for cell in get_used_cells_by_id(Tile.Floor):
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


func _check_rect(rect: Rect2) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			assert(get_cell(x, y) == INVALID_CELL)


func _build_rect(rect: Rect2, tile: int = Tile.Floor) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			set_cell(x, y, tile)


func generate() -> void:
	var hub_rect := generate_hub()
	var terminal_rects := generate_terminals(hub_rect)
	var concourse_rects := generate_concourses(terminal_rects)
	var gate_rects := generate_gates(concourse_rects)
	_build_rect(hub_rect)
	for terminal in terminal_rects:
		_build_rect(terminal)
	for concourse in concourse_rects:
		_build_rect(concourse)


func generate_hub(min_size: Vector2 = Vector2(16, 16),
				  max_size: Vector2 = Vector2(20, 20)) -> Rect2:
	assert(min_size <= max_size)
	assert(int(min_size.x) % 2 == 0 and
		   int(min_size.y) % 2 == 0 and
		   int(max_size.x) % 2 == 0 and
		   int(max_size.y) % 2 == 0)
	var hub_size := _random_vector(min_size / 2, max_size / 2) * 2
	var hub_rect := Rect2(- hub_size / 2, hub_size)
	return hub_rect


func generate_terminals(hub_rect: Rect2,
						min_width: int = 4,
						min_length: int = 4,
						max_width: int = 4,
						max_length:int = 8) -> Array:
	var start_x = hub_rect.position.x
	var start_y = hub_rect.position.y
	var end_x = hub_rect.end.x
	var end_y = hub_rect.end.y
	
	var terminals := []

	for y in [start_y, end_y]:
		var possible_terminals := range(start_x + max_width / 2, end_x - max_width / 2 - 1)
		possible_terminals.shuffle()
		for x in possible_terminals:
			var terminal_short := _random_int(min_width, max_width)
			var terminal_long := _random_int(min_length, max_length)
			for margin in range(x - terminal_short / 2 - terminal_spacing, x + terminal_short / 2 + terminal_spacing):
				possible_terminals.erase(margin)
			var terminal_rect := Rect2(x, end_y if y == end_y else (start_y - terminal_long), terminal_short, terminal_long)
			_check_rect(terminal_rect)
			terminals.append(terminal_rect)
	for x in [start_x, end_x]:
		var possible_terminals := range(start_y + max_width / 2, end_y - max_width / 2 - 1)
		possible_terminals.shuffle()
		for y in possible_terminals:
			var terminal_short := _random_int(min_width, max_width)
			var terminal_long := _random_int(min_length, max_length)
			for margin in range(y - terminal_short / 2 - terminal_spacing, y + terminal_short / 2 + terminal_spacing):
				possible_terminals.erase(margin)
			var terminal_rect := Rect2(end_x if x == end_x else (start_x - terminal_long), y, terminal_long, terminal_short)
			_check_rect(terminal_rect)
			terminals.append(terminal_rect)
	return terminals


func generate_concourses(terminal_rects: Array) -> Array:
	return []


func generate_gates(concourse_rects: Array) -> Array:
	return []

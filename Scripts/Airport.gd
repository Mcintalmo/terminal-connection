extends TileMap

const GATE_SCENE := preload("res://Scenes/Gate.tscn")
const KIOSK_SCENE := preload("res://Scenes/Kiosk.tscn")

export(float) var hub_side_chance := 0.5
export(float) var terminal_generation_chance := 0.5
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



func get_num_gates() -> int:
	return gates.size()


func randomize_gates() -> void:
	pass # TODO


func randomize_kiosks() -> void:
	pass # TODO


func build_walls() -> void:
	for cell in get_used_cells_by_id(Tile.Floor):
		for x in range(-1, 2):
			for y in range(-1, 2):
				if get_cell(cell.x + x, cell.y + y) == INVALID_CELL:
					set_cell(cell.x + x, cell.y + y, Tile.Wall)


func _random_vector(minimum: Vector2, maximum: Vector2 = - Vector2.ONE) -> Vector2:
	if maximum.x < 0 and maximum.y < 0:
		maximum = minimum
		minimum = Vector2.ZERO
	var x := randi() % int((maximum.x - minimum.x) + minimum.x)
	var y := randi() % int((maximum.y - minimum.y) + minimum.y)
	return Vector2(x, y)


func _build_rect(rect: Rect2) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			set_cell(x, y, Tile.Floor)


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


func generate_hub(min_size: Vector2 = Vector2(4, 4),
				  max_size: Vector2 = Vector2(16, 16)) -> Rect2:
	assert(min_size.x <= max_size.x and min_size.y <= max_size.y)
	assert(int(min_size.x) % 2 == 0 and
		   int(min_size.y) % 2 == 0 and
		   int(max_size.x) % 2 == 0 and
		   int(max_size.y) % 2 == 0)
	var hub_size := _random_vector(min_size, max_size)
	var hub_rect := Rect2(- hub_size / 2, hub_size)
	return hub_rect


func generate_terminals(hub_rect: Rect2,
						min_size: Vector2 = Vector2(4, 4),
						max_size: Vector2 = Vector2(16, 16)) -> Array:
	var next_terminal_size := _random_vector(min_size, max_size)
	# Randomly choose sides to build terminals on
	var directions := [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN]
	directions.shuffle()
	for i in range(directions.size(), 1):
		if randf() > hub_side_chance:
			directions.remove(i)
			
	# Build at least one terminal on every chosen side of the hub
	var terminal_rects := []
	for direction in directions:
		var num_term := 0
		var start: Vector2
		var end: Vector2
		if direction.x == 0: # UP or DOWN
			start.x = hub_rect.position.x
			end.x = hub_rect.end.x - next_terminal_size.x
			if direction.y < 0: # UP
				start.y = hub_rect.position.y
			else: # DOWN
				start.y = hub_rect.end.y
			end.y = start.y
		else: # LEFT or RIGHT
			start.y = hub_rect.position.y
			end.y = hub_rect.end.y - next_terminal_size.x # Treating the terminal as rotated
			if direction.x < 0: # LEFT
				start.x = hub_rect.position.x
			else: # RIGHT
				start.x = hub_rect.end.x
			end.x = start.x
		var skip_x := 0
		var skip_y := 0
		for x in range(start.x, end.x):
			if skip_x:
				skip_x -= 1
				continue
			for y in range(start.y, end.y):
				if skip_y:
					skip_y -= 1
					continue
				if randf() > terminal_generation_chance:
					var term_size: Vector2
					term_size.x = next_terminal_size.x if direction.x == 0 \
													   else next_terminal_size.y
					term_size.y = next_terminal_size.y if direction.x == 0 \
													   else next_terminal_size.x
					next_terminal_size = _random_vector(min_size, max_size)
					if direction in [Vector2.DOWN, Vector2.LEFT]:
						term_size.y = - term_size.y
					if direction in [Vector2.UP, Vector2.DOWN]:
						skip_x = term_size.x
					if direction in [Vector2.LEFT, Vector2.RIGHT]:
						skip_y = term_size.y
					var terminal_rect := Rect2(Vector2(x, y), term_size)
					terminal_rects.append(terminal_rect)
	return terminal_rects


func generate_concourses(terminal_rects: Array) -> Array:
	return []


func generate_gates(concourse_rects: Array) -> Array:
	return []

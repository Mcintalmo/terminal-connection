extends Node

enum Airline {
	Airline1,
	Airline2,
	Airline3,
	Count,
}

enum Remarks {
	OnTime,
	Delayed,
	Cancelled
	Count,
}

enum Concourse {
	A, B, C, D, E, F, G, Count,
}

var airlines := []
var concourses := []
var flights := []
var max_tickets := 3


onready var player := $Airport/Player
onready var airport := $Airport
onready var flight_panel := $UI/FlightPanel

func _ready():
	seed(1)
	randomize()
	
	var gate_id := 0
	for gate in airport.gates:
		gate.connect("legally_entered", self, "takeoff", [gate_id])
		var airline := "Line"
		
		flights.append(Flight.new(gate_id, airline, gate.terminal, gate.concourse, gate.number, "", 0, ""))
		gate_id += 1
	
	for kiosk in airport.kiosks:
		kiosk.connect("exited", self, "_on_kiosk_exited")


func takeoff(_gate_id: int) -> void:
	pass


func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			get_tree().quit()


func _on_Player_interacted():
	if flight_panel.is_visible():
		flight_panel.hide()
	else:
		flight_panel.clear()
		for flight in flights:
			flight_panel.add_flight(flight)
		flight_panel.show()


func _on_kiosk_exited():
	flight_panel.hide()


func _on_FlightPanel_buy_attempted(flight_number: int) -> void:
	if player.tickets.size() > max_tickets:
		return
	assert(player.tickets.has(flight_number))
	player.tickets.append(flight_number)
	flight_panel.flight_bought(flight_number)


func _on_FlightPanel_sell_attempted(flight_number):
	assert(!player.tickets.has(flight_number))
	player.tickets.erase(flight_number)
	flight_panel.flight_sold(flight_number)

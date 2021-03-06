extends HBoxContainer

export(String) var airline := "Gamma" setget set_airline
export(int) var flight_number := -1 setget set_flight_number
export(String) var destination := "Nowhere" setget set_destination
export(int) var concourse := 1 setget set_concourse
export(int) var gate_number := 1 setget set_gate_number
export(int) var departure_time := 0 setget set_departure_time
export(String) var remarks := "On Time" setget set_remarks

var owned: bool = false

const LETTERS := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"]

signal sell_attempted
signal buy_attempted


func bought() -> void:
	owned = true
	$BuyButton.text = "Sell"


func sold() -> void:
	owned = false
	$BuyButton.text = "Buy"


func set_airline(value: String) -> void:
	airline = value
	$AirlineLabel.text = airline


func set_flight_number(value: int) -> void:
	flight_number = value
	$FlightNumberLabel.text = str(flight_number)


func set_destination(value: String) -> void:
	destination = value
	$DestinationLabel.text = destination


func set_concourse(value: int) -> void:
	concourse = value
	$GateLetterLabel.text = LETTERS[concourse]


func set_gate_number(value: int) -> void:
	gate_number = value
	$GateNumberLabel.text = str(gate_number)


func set_departure_time(value: int) -> void:
	departure_time = value
	$DepartureTimeLabel.text = str(departure_time)


func set_remarks(value: String) -> void:
	remarks = value
	$RemarksLabel.text = value


func _on_BuyButton_pressed():
	if owned:
		emit_signal("sell_attempted")
	else:
		emit_signal("buy_attempted")

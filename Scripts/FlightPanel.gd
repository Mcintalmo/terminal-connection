extends PanelContainer

onready var flight_infos := $VBoxContainer/Flights
onready var header := $VBoxContainer/Flights/Header

signal buy_attempted(flight_number)
signal sell_attempted(flight_number)

enum View {
	All,
	Owned,
}

var view: int = View.All

func add_flight(flight: Flight) -> void:
	var flight_info := header.duplicate()
	flight_infos.add_child(flight_info)
	flight_info.airline = flight.airline
	flight_info.flight_number = flight.number
	flight_info.destination = flight.destination
	flight_info.concourse = flight.concourse
	flight_info.gate_number = flight.gate_number
	flight_info.departure_time = flight.departure_time
	flight_info.remarks = flight.remarks
	var con := flight_info.connect("buy_attempted", self, "attempt_buy", [flight.number])
	assert(con == OK)
	con = flight_info.connect("sell_attempted", self, "attempt_sell", [flight.number])
	assert(con == OK)


func attempt_buy(flight_number: int) -> void:
	emit_signal("buy_attempted", flight_number)


func attempt_sell(flight_number: int) -> void:
	emit_signal("sell_attempted", flight_number)


func flight_bought(flight_number: int) -> void:
	for flight_info in flight_infos:
		if flight_number == flight_info.flight_number:
			flight_info.bought()
			return


func flight_sold(flight_number: int) -> void:
	for flight_info in flight_infos:
		if flight_number == flight_info.flight_number:
			flight_info.sold()
			return


func _on_ChangeViewButton_pressed():
	if view == View.Owned:
		for flight_info in flight_infos.get_children():
			flight_info.show()
		view = View.All
	elif view == View.All:
		for flight_info in flight_infos.get_children():
			if not flight_info.owned:
				flight_info.hide()
		view = View.Owned

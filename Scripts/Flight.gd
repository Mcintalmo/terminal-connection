extends Object
class_name Flight

var number := -1
var airline := "Gamma" 
var terminal := 1
var concourse := 1
var gate_number := 1
var destination := "Nowhere"
var departure_time := 0 
var remarks := "On Time"


func _init(number_: int,
		   airline_: String, 
		   terminal_ : int,
		   concourse_: int,
		   gate_number_: int,
		   destination_: String,
		   departure_time_: int,
		   remarks_: String):
	number = number_
	airline = airline_
	terminal = terminal_
	concourse = concourse_
	gate_number = gate_number_
	destination = destination_
	departure_time = departure_time_
	remarks = remarks_

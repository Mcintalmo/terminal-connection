extends Area2D

var id: int
signal legally_entered
var terminal: int setget set_terminal
var concourse: int setget set_concourse
var number: int setget set_number

const LETTERS := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"]

func _on_body_entered(player: Player) -> void:
	if not player:
		return
	if player.tickets.has(id):
		emit_signal("legally_entered")


func set_terminal(value: int) -> void:
	terminal = value
	$PanelContainer/HBoxContainer/TerminalLabel.text = str(value)


func set_concourse(value: int) -> void:
	concourse = value
	$PanelContainer/HBoxContainer/ConcourseLabel.text = LETTERS[value]


func set_number(value: int) -> void:
	number = value
	$PanelContainer/HBoxContainer/NumberLabel.text = str(value)

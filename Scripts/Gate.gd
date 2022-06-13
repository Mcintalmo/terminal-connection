extends Area2D

var id: int
signal legally_entered

func _on_body_entered(player: Player) -> void:
	if not player:
		return
	if player.tickets.has(id):
		emit_signal("legally_entered")

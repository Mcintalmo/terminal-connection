extends Area2D

export(Color) var default_color := Color.blue
export(Color) var entered_color := Color.green

signal exited

func _ready():
	$Sprite.modulate = default_color


func _on_body_entered(body: Player) -> void:
	if !body:
		return
	$Sprite.modulate = entered_color
	body.kiosk = self


func _on_body_exited(body: Player) -> void:
	if !body:
		return
	$Sprite.modulate = default_color
	if body.kiosk == self:
		body.kiosk = null
		emit_signal("exited")

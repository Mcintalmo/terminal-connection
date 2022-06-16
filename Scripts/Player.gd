extends KinematicBody2D
class_name Player

export(float) var speed := 200.0
var kiosk: Area2D = null
var tickets := []

signal interacted


# warning-ignore:unused_argument
func _physics_process(delta):
	var _direction := Vector2.ZERO
	if Input.get_action_strength("up"):
		_direction += Vector2.UP
	if Input.get_action_strength("left"):
		_direction += Vector2.LEFT
	if Input.get_action_strength("down"):
		_direction += Vector2.DOWN
	if Input.get_action_strength("right"):
		_direction += Vector2.RIGHT
	_direction = _direction.normalized()
	_direction.y *= 0.5
# warning-ignore:return_value_discarded
	move_and_slide(_direction * speed)


func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("interact") and kiosk != null:
			emit_signal("interacted")

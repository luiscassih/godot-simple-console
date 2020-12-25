extends Node2D

enum Types {
	INT, STRING, BOOLEAN, FLOAT
}
const commands = {
	# Command name: [Params types]
	"speed": [Types.FLOAT]
}

func speed(speed):
	speed = float(speed)
	emit_signal("set_speed", speed)
	return str("Speed has been set to ", speed)

signal set_speed(speed)
func connect_signals(parent):
	connect("set_speed", parent.get_node("Player"), "_on_set_speed")

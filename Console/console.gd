extends Control

var consoleHistoryIndex = ConsoleHistory.history.size()
export var pause_on_open = true
var parent

func _init_console(_parent, console):
	parent = _parent
	$commandHandler.connect_signals(_parent)
	_parent.get_tree().paused = pause_on_open
	_parent.add_child(console)

func _ready():
	$input.grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_console") or Input.is_key_pressed(KEY_ESCAPE):
		if pause_on_open:
			get_tree().paused = false
		parent.console_open = false
		queue_free()
		
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			offsetConsoleHistory(-1)
		if event.scancode == KEY_DOWN:
			offsetConsoleHistory(1)

func outputText(text):
	$output.text = str($output.text, "\n", text)
	$output.set_v_scroll($output.get_line_count())

func _on_input_text_entered(new_text):
	$input.clear()
	processCommand(new_text)
	consoleHistoryIndex = ConsoleHistory.history.size()

func processCommand(text):
	var params = text.split(" ", false)
	params = Array(params)
	if params.size() == 0:
		return
	ConsoleHistory.history.append(text)
	var command = params.pop_front()
	if $commandHandler.commands.has(command):
		var commandParams = $commandHandler.commands[command]
		if params.size() != commandParams.size():
			outputText(str("Failure executing comand '", command, "', expected ", commandParams.size(), " parameters."))
			return
		for i in range(params.size()):
			if not checkType(params[i], commandParams[i]):
				outputText(str("Failure executing comand '", command, "', parameter '", params[i], "' has wrong type."))
				return
		outputText($commandHandler.callv(command, params))
		return
	outputText(str("Command '", command,"' doesn't exist."))

func checkType(param: String, type):
	var ValidTypes = $commandHandler.Types
	match type:
		ValidTypes.INT:
			return param.is_valid_integer()
		ValidTypes.FLOAT:
			return param.is_valid_float()
		ValidTypes.STRING:
			return true
		ValidTypes.BOOLEAN:
			return param.to_lower() == "true" or param.to_lower() == "false"

func offsetConsoleHistory(offset):
	consoleHistoryIndex += offset
	consoleHistoryIndex = clamp(consoleHistoryIndex, 0, ConsoleHistory.history.size())
	if consoleHistoryIndex < ConsoleHistory.history.size() and ConsoleHistory.history.size() > 0:
		$input.text = ConsoleHistory.history[consoleHistoryIndex]
		$input.caret_position = $input.text.length()
		accept_event()

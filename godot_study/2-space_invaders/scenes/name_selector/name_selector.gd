extends Node2D

# ----------------------------------------
#				signals
# ----------------------------------------
signal finished

# ----------------------------------------
#				consts
# ----------------------------------------
const LETTERS: String = "ABCDEFGHIJKLMNOPQRSTUVXWYZ0123456789_*#"

# ----------------------------------------
#				state
# ----------------------------------------
var letters_idx: int = 0
var selected_name: String = ''
var selected_letter_is_visible: bool = true

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _input(event: InputEvent): # pega todos os eventos. clique, moveu mouse, apertou botão e etc
	if event.is_action_pressed("ui_up"):
		letters_idx += 1
	if event.is_action_pressed("ui_down"):
		letters_idx -= 1

	if selected_name.length() == 0:
		$HBoxContainer/letter_1.text = LETTERS[letters_idx]
	elif selected_name.length() == 1:
		$HBoxContainer/letter_2.text = LETTERS[letters_idx]
	elif selected_name.length() == 2:
		$HBoxContainer/letter_3.text = LETTERS[letters_idx]
	else:
		if not selected_name.length() == 3:
			print("ERROR: Unexpected condition on script name_selector.gd. ID: 1. \nData:")

	if event.is_action_pressed("select_letter"):
		letters_idx = 0
		var selected_letter: String = ''

		if selected_name.length() == 0:
			selected_letter = $HBoxContainer/letter_1.text
			show_letter($HBoxContainer/letter_1)
		elif selected_name.length() == 1:
			selected_letter = $HBoxContainer/letter_2.text
			show_letter($HBoxContainer/letter_2)
		elif selected_name.length() == 2:
			selected_letter = $HBoxContainer/letter_3.text
			show_letter($HBoxContainer/letter_3)
			disable_letter_timer()
		else:
			print("ERROR: Unexpected condition on script name_selector.gd. ID: 2")

		selected_name = selected_name + selected_letter

	if selected_name.length() == 3:
		emit_signal("finished", selected_name)

func disable_letter_timer():
	$timer_blink_letter.stop()

func show_letter(el: Label):
	el.add_color_override("font_color", Color(255, 255, 255, 1))

func hide_letter(el: Label):
	el.add_color_override("font_color", Color(255, 255, 255, 0))

func toggle_visibility(el: Label):
	if selected_letter_is_visible:
		hide_letter(el)
		selected_letter_is_visible = false
	else:
		show_letter(el)
		selected_letter_is_visible = true

# ----------------------------------------
#				signals input
# ----------------------------------------
func _on_timer_blink_letter_timeout():
	var selected_letter: Label = null

	if selected_name.length() == 0:
		selected_letter = $HBoxContainer/letter_1
	elif selected_name.length() == 1:
		selected_letter = $HBoxContainer/letter_2
	elif selected_name.length() == 2:
		selected_letter = $HBoxContainer/letter_3
	else:
		print("ERROR: Unexpected condition on script name_selector.gd. ID: 3")

	toggle_visibility(selected_letter)

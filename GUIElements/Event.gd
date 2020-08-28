extends Control

var event_data
signal choice1
signal choice2

func _ready():
	if !event_data:
		return
	var graphic = str("res://EventImages/" + event_data.graphic)
	var image = load(graphic)
	$TextureRect.texture = image
	$HBoxContainer/Choice1.text = event_data.choice_1_text
	$HBoxContainer/Choice2.text = event_data.choice_2_text

func _on_Choice1_pressed():
	#emit_signal("choice1", "nothing", "")
	emit_signal("choice1", event_data.choice_1_result, event_data.choice_1_result_text)
	$HBoxContainer.queue_free()

func _on_Choice2_pressed():
	#emit_signal("choice2", "nothing", "")
	emit_signal("choice2", event_data.choice_2_result, event_data.choice_2_result_text)
	$HBoxContainer.queue_free()

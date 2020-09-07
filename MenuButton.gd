extends MenuButton

var popup

func _ready():
	popup = get_popup()
	popup.add_item("Engineering")
	popup.add_item("Tactical")
	popup.add_item("Science")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	text = popup.get_item_text(ID)
	set_station_color()
	
func set_station_color():
	var new_style = load("res://Buttons/StationPicker.tres").duplicate()
	new_style.set_bg_color(GlobalData.STATION_COLORS[text])
	set('custom_styles/normal', new_style)
	set('custom_styles/hover', new_style)
	set('custom_styles/pressed', new_style)

extends MenuButton

var popup

func _ready():
	popup = get_popup()
	popup.add_item("Engineering")
	popup.add_item("Tactical")
	popup.add_item("Science")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	self.text = popup.get_item_text(ID)
	print(popup.get_item_text(ID), " pressed")

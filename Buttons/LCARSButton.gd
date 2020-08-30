tool
extends Button

export(int, "Orange", "Light Blue", "Faded Purple", "Red", "Pink", "Blue") var color
export(int, "Left", "Right") var side

var colors = [
	{"normal":Color("#f7bd5a"),"hover":Color("#ff9c00")},
	{"normal":Color("#9c9cff"),"hover":Color("#646dcc")},
	{"normal":Color("#9977AA"),"hover":Color("#774466")},
	{"normal":Color("#bb4411"),"hover":Color("#882211")},
	{"normal":Color("#cc6699"),"hover":Color("#cc6666")},
	{"normal":Color("#3366ff"),"hover":Color("#000088")},
]

func _ready():
	randomize()
	#var color = randi() % colors.size()	

	var new_normal_style = load("res://Buttons/LCARSButton.tres").duplicate()
	var new_hover_style = load("res://Buttons/LCARSButton.tres").duplicate()
	var new_disabled_style = load("res://Buttons/LCARSButton.tres").duplicate()
	
	new_normal_style.set_bg_color(colors[color].normal)
	new_hover_style.set_bg_color(colors[color].hover)
	new_disabled_style.set_bg_color(Color("#9a9a9a"))
	
	if side == 1:
		new_normal_style.set_corner_radius_individual(60, 0, 0, 60)
		new_hover_style.set_corner_radius_individual(60, 0, 0, 60)
		new_disabled_style.set_corner_radius_individual(60, 0, 0, 60)
		new_normal_style.content_margin_left = 20
		new_normal_style.content_margin_right = -1
		new_hover_style.content_margin_left = 20
		new_hover_style.content_margin_right = -1
		new_disabled_style.content_margin_left = 20
		new_disabled_style.content_margin_right = -1
		set_text_align(ALIGN_LEFT)

	self.set('custom_styles/normal', new_normal_style)
	self.set('custom_styles/pressed', new_normal_style)
	self.set('custom_styles/focus', new_hover_style)
	self.set('custom_styles/hover', new_hover_style)
	self.set('custom_styles/disabled', new_disabled_style)

func _on_LCARSButton_pressed():
	self.release_focus()

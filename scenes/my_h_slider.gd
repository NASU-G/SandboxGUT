extends HSlider

@onready var my_label: Label = $MyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.warm_reset()
	
	update_text(Global.my_slider_value)
	grab_focus.call_deferred()


func _on_value_changed(value: float) -> void:
	update_text(value)


func update_text(v: float):
	Global.my_slider_value = v
	my_label.text = str(int(value * 100)) + "%"

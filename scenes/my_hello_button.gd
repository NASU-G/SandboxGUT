extends Button

@onready var my_hello_button_label: Label = $MyHelloButtonLabel


# Button を押したら呼ばれる
func _on_button_down() -> void:
	my_hello_button_label.text = "Hello, my hello button."
	my_hello_button_label.modulate = Color(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0))

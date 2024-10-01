extends HSlider

@onready var my_label: Label = $MyLabel


func _ready() -> void:
	#print_debug("ready")	#NOTE add_child() すれば、_ready() も呼んでもらえる！
	
	Global.warm_reset()
	
	update_my_label_text(Global.my_slider_value)
	grab_focus.call_deferred()	# 入力フォーカスを MyHSlider に与える (キー入力が効く)


# HSlider を操作したら呼ばれる
func _on_value_changed(v: float) -> void:
	update_my_label_text(v)


# 指定値で、値と表示内容を更新する
func update_my_label_text(v: float):
	Global.my_slider_value = v
	my_label.text = str(int(value * 100)) + "%"

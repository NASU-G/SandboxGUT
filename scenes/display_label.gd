class_name DispalyLabel
extends Label


func _ready() -> void:
	#print_debug("ready")	#NOTE add_child() すれば、_ready() も呼んでもらえる！
	
	update_dispaly_text("The display label in main scene.")


# shouted_hello_everyone で叫ばれたとき、どうするか
func _on_shouted_hello_everyone(txt: String) -> void:
	update_dispaly_text(str(randi()) + ": OK, " + txt)	# 応答内容をラベルの text で表現する


# Label の内容を更新する
func update_dispaly_text(txt: String):
	text = txt

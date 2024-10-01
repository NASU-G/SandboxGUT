class_name MainScene
extends Node

signal shouted_hello_everyone	# 叫んでみたらどうなるのか ?

@onready var display_label_1: DispalyLabel = $DisplayLabel1	# add_child() すれば、@onready 行も呼んでもらえる！
@onready var display_label_2: DispalyLabel = $DisplayLabel2
@onready var display_label_3: DispalyLabel = $DisplayLabel3
@onready var display_label_4: DispalyLabel = $DisplayLabel4
@onready var display_label_5: DispalyLabel = $DisplayLabel5


func _ready() -> void:
	print("ready")	# add_child() すれば、_ready() も呼んでもらえる！
	Global.warm_reset()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		shout("Hello everyone")	# 叫んでみたら、


# signal を使って叫び、その内容を返す
func shout(txt: String) -> String:
	var result = txt + "!!!"
	shouted_hello_everyone.emit(result)		# signal で叫びを表現し、事前に登録しておいた一連の処理たちに呼びかける
	
	return result


# テスト対象
func hello() -> String:
	return "hello!!!"

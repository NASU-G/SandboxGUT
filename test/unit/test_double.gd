extends GutTest

const UTILITY_SCRIPT_PATH = "res://scenes/utility_script.gd"

var DoubleUtilityScript = null
var double_utility_script = null


func before_all():
	DoubleUtilityScript = load(UTILITY_SCRIPT_PATH)


func before_each():
	double_utility_script = double(DoubleUtilityScript).new()	# double には自動解放機能がある


func after_each():
	pass


func after_all():
	queue_free()	# 自身も解放しないと、Orphans が 1 付く


#----------


func test_double():
	assert_null(double_utility_script.hello("Taro"), "double はsutbをかませるため以外には全く上手く働かない")
	
	stub(double_utility_script, "hello").to_return("hello!!!")
	var data = double_utility_script.hello("Taro")
	assert_eq(data, "hello!!!", "このように、ダミーとしてstubをかませるためにのみdoubleは使用される")

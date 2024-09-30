extends GutTest

const MAIN_SCENE_PATH = "res://scenes/main_scene.tscn"

var PartialDoubleMainScene = null
var partial_double_main_scene = null


func before_all():
	PartialDoubleMainScene = load(MAIN_SCENE_PATH)


func before_each():
	partial_double_main_scene = partial_double(PartialDoubleMainScene).instantiate()	# (partial) double は自動で解放される
	add_child(partial_double_main_scene)	# これで、_ready() や @onready が呼ばれる！


func after_each():
	remove_child(partial_double_main_scene)	# add_child() と対


func after_all():
	queue_free()	# 自身も解放しないと、Orphans が発生する

#----------

func test_instantiate():
	assert_not_null(partial_double_main_scene, "何はともあれ、まず作れたかどうか ?")


# 典型的な処理のテスト
var parameterized_test_shout = [
	["Hello everyone", "Hello everyone!!!", true, "叫ぶことを予想できている、典型的な成功例"],
	["Good morning", "Good morning.", false, "叫ぶことを予想できていない、典型的な失敗例"],
]
func test_shout(params=use_parameters(parameterized_test_shout)):
	var result = partial_double_main_scene.shout(params[0])
	assert_eq((result == params[1]), params[2], params[-1])


# stub を使ったダミーを読ませるテスト ((partial) double のみ使える方法)
var parameterized_test_shout_with_stub = [
	["I like apple", "I like apple!!!!!!!!!!", "いつもより大きく叫んでいる特別な例1"],
	["I love apple", "I love apple!!!!!!!!!!", "いつもより大きく叫んでいる特別な例2"],
]
func test_shout_with_stub(params=use_parameters(parameterized_test_shout_with_stub)):
	stub(partial_double_main_scene, "shout").to_return(params[0] + "!!!!!!!!!!")	# もう我慢できない！いいから、いつもより大きめに！！！
	var result = partial_double_main_scene.shout(params[0])
	assert_true(result == params[1], params[-1])


# signal を持っているか
func test_shout_has_signal():
	partial_double_main_scene.shout("Hello everyone")
	assert_has_signal(partial_double_main_scene, "shouted_hello_everyone")


# signal を発しているか
func test_shout_signal_emitted():
	watch_signals(partial_double_main_scene)	# assert_signal_emitted の前に毎回 1度呼ぶ必要がある https://gut.readthedocs.io/en/latest/Asserts-and-Methods.html#watch-signals-object
	partial_double_main_scene.shout("Hello everyone")
	assert_signal_emitted(partial_double_main_scene, "shouted_hello_everyone")


# 簡素な例
func test_hello():
	var result = partial_double_main_scene.hello()	# partial double ならこれはできる。(double だと hello() の戻り値が null になってエラーなはず)
	assert_eq(result, "hello!!!")


# signal が connect されているかどうか
func test_connected_display_labels():
	# add_child() したので、@onready 行が期待通りの動作をしてくれる !
	assert_connected(partial_double_main_scene, partial_double_main_scene.display_label_1, "shouted_hello_everyone")
	assert_connected(partial_double_main_scene, partial_double_main_scene.display_label_2, "shouted_hello_everyone")
	assert_connected(partial_double_main_scene, partial_double_main_scene.display_label_3, "shouted_hello_everyone")
	assert_connected(partial_double_main_scene, partial_double_main_scene.display_label_4, "shouted_hello_everyone")
	assert_connected(partial_double_main_scene, partial_double_main_scene.display_label_5, "shouted_hello_everyone")

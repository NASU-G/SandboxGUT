# MainScene のみの、インテグレーションテスト(統合テスト)
#TODO 次回は、複数シーンを用意する予定
extends GutTest

var TargetSceneMainScene
var target_scene_main_scene
var _sender = InputSender.new(Input)	# 自動入力を使う


func before_all():
	TargetSceneMainScene = load(Global.MAIN_SCENE_PATH)	# テスト対象は MainScene


func before_each():
	# partial_double は自動解放される
	target_scene_main_scene = partial_double(TargetSceneMainScene).instantiate()
	
	#NOTE _ready() @onready が呼ばれる!
	add_child(target_scene_main_scene)
	
	# リセット処理
	Global.cold_reset()
	Global.warm_reset()


func after_each():
	# 自動入力イベントを全リセット
	_sender.release_all()
	_sender.clear()
	
	#NOTE add_child と対
	remove_child(target_scene_main_scene)


func after_all():
	queue_free()	# 自身を解放して終える (これで Orpahns 1 が無くなる)

#---


# キー押下で、シグナル発生させるテスト（自動キー操作）
func test_user_key_input_pressed_enter():
	
	# assert_signal_emitted などを使うときは前もって呼ぶ必要がある
	# https://gut.readthedocs.io/en/latest/Asserts-and-Methods.html#watch-signals-object
	watch_signals(target_scene_main_scene)
	
	# 自動でキー入力。Enter。
	_sender.action_down('ui_accept').wait_frames(10)\
	.release_all()
	await _sender.idle	# 入力イベントの消化を待つ
	
	# 検査
	assert_has_signal(target_scene_main_scene, 'shouted_hello_everyone', "叫べるのか ?")
	assert_signal_emitted(target_scene_main_scene, 'shouted_hello_everyone', "叫んだか ?")


# HSlider を操作するテスト（自動キー操作）
func test_change_my_h_slider():
	# 自動でキー入力。右→右。
	_sender.action_down('ui_right').wait_frames(10)\
	.release_all()
	await _sender.idle	# 入力イベントの消化を待つ
	_sender.action_down('ui_right').wait_frames(10)\
	.release_all()
	await _sender.idle	# 入力イベントの消化を待つ
	
	# 検査
	assert_eq(int(Global.my_slider_value * 100), int(Global.MY_SLIDER_DEFAULT_VALUE * 100) + 20, "Hスライダーの操作は反映されるのか ?")


# Button を押すテスト（自動マウス操作）
func test_push_my_hello_button():
	# assert_signal_emitted などを使うときは前もって呼ぶ必要がある
	# https://gut.readthedocs.io/en/latest/Asserts-and-Methods.html#watch-signals-object
	watch_signals(target_scene_main_scene.get_node('MyHelloButton'))
	
	# 自動でマウス操作。ボタンを押す。
	_sender.mouse_left_button_down(Vector2i(180, 420)).wait_frames(10)\
	.release_all()
	await _sender.idle	# 入力イベントの消化を待つ
	
	# 検査
	assert_signal_emitted(target_scene_main_scene.get_node('MyHelloButton'), 'button_down', "ボタンを押したか ?")

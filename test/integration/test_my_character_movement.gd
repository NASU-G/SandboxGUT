# MyCharacter と MyGround と キー入力 の、インテグレーションテスト(統合テスト)
extends GutTest

# テスト対象をそれぞれ設置した、テスト用シーン
const TEST_SCENE_PATH = "res://test/resources/test_my_character_moving_platform.tscn"

var TargetSceneMyCharacterMovingPlatform
var target_scene_my_character_moving_platform
var _sender = InputSender.new(Input)	# 自動入力を使う


func before_all():
	TargetSceneMyCharacterMovingPlatform = load(TEST_SCENE_PATH)


func before_each():
	target_scene_my_character_moving_platform = partial_double(TargetSceneMyCharacterMovingPlatform).instantiate()	# partial_double は自動解放される
	
	add_child(target_scene_my_character_moving_platform)
	
	# リセット処理
	Global.cold_reset()
	Global.warm_reset()


func after_each():
	# 自動入力イベントを全リセット
	_sender.release_all()
	_sender.clear()
	
	# add_child と対
	remove_child(target_scene_my_character_moving_platform)


func after_all():
	queue_free()	# 自身を解放して終える (これで Orpahns 1 が無くなる)

#---

func test_my_character_moving():
	# 少し浮いた状態で、MyCharacter がスポーンする
	var pos_x = target_scene_my_character_moving_platform.get_node('MyCharacter').position.x as int
	var pos_y = target_scene_my_character_moving_platform.get_node('MyCharacter').position.y as int
	
	_sender.wait_frames(3)
	await _sender.idle	# 入力イベントの消化を待つ
	_sender.release_all()
	# 検査: 浮いた状態から始まり、少しの間、落ちる
	assert_gt(target_scene_my_character_moving_platform.get_node('MyCharacter').velocity.y, 0.0)
	
	_sender.wait_secs(3)
	await _sender.idle	# 入力イベントの消化を待つ
	_sender.release_all()
	# 検査: すでに着地しており、地面から落ちていない
	assert_eq(target_scene_my_character_moving_platform.get_node('MyCharacter').velocity.y, 0.0)
	
	# 3秒 右キー押下し続ける
	_sender.action_down('ui_right').hold_for(3)
	await _sender.idle	# 入力イベントの消化を待つ
	_sender.release_all()
	
	# 検査: 地面から落ちて落下している
	assert_gt(target_scene_my_character_moving_platform.get_node('MyCharacter').position.x as int, pos_x)
	assert_gt(target_scene_my_character_moving_platform.get_node('MyCharacter').position.y as int, pos_y)
	assert_gt(target_scene_my_character_moving_platform.get_node('MyCharacter').velocity.y, 0.0)
	
	await wait_seconds(1)	# 結果が見えるように少し待機

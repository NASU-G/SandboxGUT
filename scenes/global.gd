#class_name Global	# 不要	# Global.AAA で、AAA にアクセス可能
extends Node

# @GlobalScope enum Error # https://docs.godotengine.org/ja/4.x/classes/class_@globalscope.html#enum-globalscope-error
var error: Error = Error.FAILED

const MAIN_SCENE_PATH = "res://scenes/main_scene.tscn"

const MY_SLIDER_DEFAULT_VALUE = 0.2	# MyHSlider の初期値
var my_slider_value: float = MY_SLIDER_DEFAULT_VALUE	# MyHSlider の現在値


func _ready() -> void:
	cold_reset()
	warm_reset()


# 動作初回と、テストのときに呼ぶことを想定した、より厳しいリセット処理
func cold_reset() -> void:
	my_slider_value = MY_SLIDER_DEFAULT_VALUE
	return


# 各sceneの_ready()で呼ぶことを想定した、リセット処理
func warm_reset() -> void:
	error = FAILED
	return

extends Sprite2D

func _ready():
	# アニメーションプレイヤーを取得
	var anim = $AnimationPlayer
	
	# 現在のアニメーション（blink）の長さを取得
	var length = anim.current_animation_length
	
	# ランダムな位置（0秒〜長さの間）までシーク（早送り）する
	# これにより、開始タイミングがズレる
	anim.seek(randf_range(0.0, length))
	
	# ついでに再生速度も少しランダムにする（0.8倍〜1.2倍）
	# これで「完全にバラバラなリズム」になる
	anim.speed_scale = randf_range(0.8, 1.2)

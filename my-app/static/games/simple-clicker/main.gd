extends Control

# ゲーム状態
var money: float = 1000.0
var cost_per_second: float = 50.0
var money_per_click: float = 50.0
var total_clicks: int = 0
var game_over: bool = false
var time_played: float = 0.0

# イベント管理
var events_triggered: Array = []
var event_definitions = [
	{
		"threshold": 	2000,
		"name": "昇進",
		"message": "Promotion",
		"income_mult": 2.0,
		"cost_mult": 6.5
	},
	{
		"threshold": 5000,
		"name": "結婚",
		"message": "Marriage",
		"income_mult": 2.5,
		"cost_mult": 3.0
	},
	{
		"threshold": 10000,
		"name": "子供",
		"message": "Childbirth",
		"income_mult": 2.5,
		"cost_mult": 3.5
	},

	{
		"threshold": 20000,
		"name": "fin.",
		"message": "Burnout",
		"income_mult": 3.0,
		"cost_mult": 5.0
	}
]

# UI要素
@onready var money_label = $MoneyLabel
@onready var work_button = $WorkButton
@onready var cost_label = $CostLabel
@onready var event_panel = $EventPanel
@onready var event_label = $EventPanel/EventLabel
@onready var gameover_panel = $GameOverPanel
@onready var gameover_label = $GameOverPanel/GameOverLabel
@onready var stats_label = $StatsLabel
@onready var runner_anim = $AnimatedSprite2D 
@onready var click_sound = $ClickSound
@onready var event_sound = $EventSound
var audio_bus_idx: int
var distortion_effect: AudioEffectDistortion
var lowpass_effect: AudioEffectLowPassFilter

# パーティクル効果用
#var particle_scene = preload("res://click_particle.tscn") if ResourceLoader.exists("res://click_particle.tscn") else null

func _ready():
	# UI初期設定
	event_panel.visible = false
	gameover_panel.visible = false
# オーディオバス "Environment" のインデックスを取得
	audio_bus_idx = AudioServer.get_bus_index("Environment")
	# バスに追加したエフェクトのインスタンスを取得 (インデックスは追加した順序)
	# 0番目にDistortion、1番目にLowPassFilterを追加したと仮定
	distortion_effect = AudioServer.get_bus_effect(audio_bus_idx, 0)
	lowpass_effect = AudioServer.get_bus_effect(audio_bus_idx, 1)
	
	# 初期状態の設定（歪みなし、フィルタ全開）
	distortion_effect.drive = 0.0
	lowpass_effect.cutoff_hz = 20000.0 # 人間の可聴域上限
	
	# 再生開始（もしまだなら）
	if $AudioStreamPlayer: # ノード名は適宜合わせてください
		$AudioStreamPlayer.play()
	# ボタン接続
	work_button.pressed.connect(_on_work_button_pressed)
	
	# イベントパネルの自動非表示タイマー
	var timer = Timer.new()
	timer.name = "EventTimer"
	add_child(timer)
	timer.timeout.connect(_hide_event_panel)
	
	
	### 追加・修正: アニメーション開始 ###
	if runner_anim:
		runner_anim.play("default") # アニメーション名を指定して再生
	
	update_ui()


func _process(delta):
	if game_over:
		return
	
	time_played += delta
	
	# 毎フレーム生活維持費を減算
	money -= cost_per_second * delta
	
	# 資産がマイナスになったらゲームオーバー
	if money <= 0:
		money = 0
		trigger_game_over()
	
	# イベントチェック
	check_events()
	
	
	### 追加・修正: ハムスターの速度更新関数を呼び出し ###
	update_runner_speed()
	
	#update_audio_effects()
	
	update_ui()

# 【新規追加】音響パラメータの更新関数 うるさかったので使用しないことにした（シンプルではなかった）
func update_audio_effects():
	# 基準コスト（50.0）に対する現在の倍率を計算
	# 1.0 (正常) 〜 10.0 (異常) 〜 それ以上 の範囲を想定
	var stress_factor = cost_per_second / 50.0
	
	# 1. Distortion (歪み) の制御
	# driveプロパティ: 0.0 (無音/クリーン) 〜 1.0 (最大歪み)
	# コストが増えるほど歪ませる。ただし急激すぎないように調整
	var target_drive = clamp((stress_factor - 1.0) * 0.1, 0.0, 0.9)
	distortion_effect.drive = lerp(distortion_effect.drive, target_drive, 0.05)
	
	# 2. LowPassFilter (閉塞感) の制御
	# cutoff_hz: 低いほど音がこもる
	# ストレスが低い時は20000Hz、高くなると徐々に下がって最後は500Hzくらいに
	# 物理屋らしく指数関数的減衰で表現
	var target_cutoff = 20000.0 * exp(-0.05 * (stress_factor - 1.0))
	target_cutoff = clamp(target_cutoff, 500.0, 20000.0)
	lowpass_effect.cutoff_hz = lerp(lowpass_effect.cutoff_hz, target_cutoff, 0.05)
	
	# 3. ピッチ（再生速度）の微細な揺らぎ（オプション）
	# ストレスがかかるとモーターが不安定になる演出
	if stress_factor > 5.0:
		var wobble = sin(Time.get_ticks_msec() * 0.01) * 0.05
		$AudioStreamPlayer.pitch_scale = 1.0 - (stress_factor * 0.01) + wobble
	else:
		$AudioStreamPlayer.pitch_scale = 1.0
### 追加・修正: ハムスターの速度制御ロジック ###
func update_runner_speed():
	if not runner_anim:
		return
		
	# 基準となる維持費（初期値の50.0）
	var base_cost = 35.0
	
	# 現在の維持費が基準の何倍か計算
	var speed_factor = cost_per_second / base_cost
	
	# 速度があまりに速すぎると見えなくなるため、最大値を制限（Clamp）
	# 例: 最小0.5倍速 〜 最大20倍速
	runner_anim.speed_scale = clamp(speed_factor, 0.5, 2.5)
	
	# 【物理学的アプローチの補足】
	# もし速度の変化を対数的にしたい（後半のインフレを緩やかに見せたい）場合は以下を使用
	runner_anim.speed_scale = log(speed_factor + 1) * 0.5 

func _on_work_button_pressed():
	if game_over:
		return
	# ▼▼▼ 追加：クリック音の再生 ▼▼▼
	# ピッチをわずかにランダムにすることで、機械的すぎない「手作業感」を出します
	click_sound.pitch_scale = randf_range(0.9, 1.1)
	click_sound.play()
	# ▲▲▲▲▲▲
	# クリックで収入獲得
	money += money_per_click
	total_clicks += 1
	
	# ボタンアニメーション効果
	work_button.scale = Vector2(0.95, 0.95)
	var tween = create_tween()
	tween.tween_property(work_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	# 収入表示のフィードバック
	show_income_feedback()

func show_income_feedback():
	# クリックで得た金額を一時的に表示
	var feedback = Label.new()
	var font_data = load("res://Nosutaru-dotMPlusH-10-Regular.ttf")
	feedback.add_theme_font_override("font",font_data) 
	feedback.text = "+$%.0f" % money_per_click
	feedback.add_theme_color_override("font_color", Color.WHITE_SMOKE)
	feedback.add_theme_font_size_override("font_size", 24)
	feedback.position = work_button.position + Vector2(work_button.size.x / 2+40, -30)
	feedback.z_index = 10
	add_child(feedback)
	
	# フェードアウトアニメーション
	var tween = create_tween()
	tween.tween_property(feedback, "position:y", feedback.position.y - 50, 1.0)
	tween.parallel().tween_property(feedback, "modulate:a", 0.0, 1.0)
	tween.tween_callback(feedback.queue_free)


func check_events():
	for event in event_definitions:
		if money >= event["threshold"] and not event in events_triggered:
			trigger_event(event)
			events_triggered.append(event)

func trigger_event(event):
	# イベント効果を適用
	money_per_click *= event.get("income_mult", 1.0)
	cost_per_second *= event.get("cost_mult", 1.0)
	
	if event.has("cost"):
		money -= event["cost"]
	
	# イベント通知を表示
	event_label.text = event["message"]
	event_panel.visible = true
	event_sound.play()
	
	# パネルのフェードインアニメーション
	event_panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(event_panel, "modulate:a", 1.0, 0.3)
	
	# 3秒後に自動で非表示
	var timer = get_node("EventTimer")
	timer.start(4.0)
	
	# 画面シェイク効果（強制イベントの衝撃）
	screen_shake()

func screen_shake():
	var original_pos = position
	var shake_amount = 3.0
	var shake_duration = 0.1
	
	var tween = create_tween()
	for i in range(10):
		var offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		tween.tween_property(self, "position", original_pos + offset, shake_duration / 10)
	tween.tween_property(self, "position", original_pos, shake_duration / 10)

func _hide_event_panel():
	var tween = create_tween()
	tween.tween_property(event_panel, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): event_panel.visible = false)

func update_ui():
	# 資産表示
	money_label.text = "$ %.0f" % money
	
	# 生活維持費表示
	cost_label.text = "Operating Cost: $%.1f " % cost_per_second
	
	# 統計情報
	if stats_label:
		stats_label.text = "total output: %d | time: %.0fs" % [total_clicks, time_played]
	
	# 資産が減っている時は赤く表示
	if money < cost_per_second * 5:
		money_label.add_theme_color_override("font_color", Color.RED)
	elif money < cost_per_second * 20:
		money_label.add_theme_color_override("font_color", Color.ORANGE)
	else:
		money_label.add_theme_color_override("font_color", Color.WHITE)
	
	# ボタンテキストを状況に応じて変更
	if cost_per_second > 30:
		work_button.text = "Work"
	elif cost_per_second > 15:
		work_button.text = "Work"
	else:
		work_button.text = "Work"

func trigger_game_over():
	game_over = true
	work_button.disabled = true
	
	### 追加・修正: ゲームオーバー時にハムスターを止める ###
	if runner_anim:
		runner_anim.pause() # または runner_anim.stop()
	
	# ゲームオーバー画面を表示
	gameover_label.text = "Terminated."
	gameover_panel.visible = false
	gameover_panel.modulate.a = 0
	
	# フェードインアニメーション
	var tween = create_tween()
	tween.tween_property(gameover_panel, "visible", true, 0)
	tween.tween_property(gameover_panel, "modulate:a", 1.0, 1.5)
	
	# 統計情報を追加
	await get_tree().create_timer(2.0).timeout
	gameover_label.text += "\n\noperations: %d\ntenure: %.0fs" % [total_clicks, time_played]
	
	# 5秒後にリスタート
	await get_tree().create_timer(10.0).timeout
	get_tree().reload_current_scene()

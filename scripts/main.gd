extends Node2D

@export var square_scene: PackedScene
@export var spawn_margin: float = 20.0
@export var spawn_y: float = -40.0
@export var spawn_interval: float = 1.0
@export var start_fall_speed: float = 80.0
@export var fall_speed_acceleration: float = 9.0
@export var max_fall_speed: float = 520.0

const MAX_MISTAKES: int = 10

var score: int = 0
var mistakes: int = 0
var current_fall_speed: float = 0.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var catcher: Catcher = $Catcher
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var mistakes_label: Label = $CanvasLayer/MistakesLabel
@onready var match_sound: AudioStreamPlayer2D = $MatchSound
@onready var miss_sound: AudioStreamPlayer2D = $MissSound


func _ready() -> void:
	current_fall_speed = start_fall_speed

	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	catcher.square_matched.connect(_on_square_matched)
	catcher.square_missed.connect(_on_square_missed)

	update_ui()


func _process(delta: float) -> void:
	current_fall_speed = min(
		current_fall_speed + fall_speed_acceleration * delta,
		max_fall_speed
	)


func _on_spawn_timer_timeout() -> void:
	var item := square_scene.instantiate() as FallingItem
	if item == null:
		push_error("square_scene must instantiate a FallingItem.")
		return

	var viewport_width := get_viewport_rect().size.x
	var min_x := spawn_margin
	var max_x := viewport_width - item.item_size.x - spawn_margin

	if max_x < min_x:
		min_x = 0.0
		max_x = max(viewport_width - item.item_size.x, 0.0)

	item.position = Vector2(randf_range(min_x, max_x), spawn_y)
	item.set_fall_speed(current_fall_speed)

	add_child(item)


func _on_square_matched() -> void:
	score += 1
	update_ui()
	match_sound.play()


func _on_square_missed() -> void:
	mistakes += 1
	update_ui()
	miss_sound.play()

	if mistakes >= MAX_MISTAKES:
		get_tree().reload_current_scene()


func update_ui() -> void:
	score_label.text = "Score: %d" % score
	mistakes_label.text = "Mistakes: %d / %d" % [mistakes, MAX_MISTAKES]

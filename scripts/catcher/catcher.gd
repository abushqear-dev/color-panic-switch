class_name Catcher
extends Area2D

signal square_matched
signal square_missed

@export var catcher_height: float = 64.0

# Assign these in the Inspector
@export var red_texture: Texture2D
@export var green_texture: Texture2D
@export var blue_texture: Texture2D

var color_index: int = 0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	get_viewport().size_changed.connect(_update_layout)

	_update_layout()
	update_color()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("change_color_left"):
		_change_color(-1)
	elif event.is_action_pressed("change_color_right"):
		_change_color(1)


func _change_color(direction: int) -> void:
	color_index = posmod(color_index + direction, 3)
	update_color()


func update_color() -> void:
	match color_index:
		0:
			sprite.texture = red_texture
		1:
			sprite.texture = green_texture
		2:
			sprite.texture = blue_texture

	_update_sprite_scale()


func _on_area_entered(area: Area2D) -> void:
	var item := area as FallingItem
	if item == null:
		return

	if item.color_index == color_index:
		square_matched.emit()
	else:
		square_missed.emit()

	item.queue_free()


func _update_layout() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var center_y := viewport_size.y - catcher_height * 0.5

	sprite.position = Vector2(viewport_size.x * 0.5, center_y)
	collision_shape.position = Vector2(viewport_size.x * 0.5, center_y)

	var rect_shape := collision_shape.shape as RectangleShape2D
	if rect_shape != null:
		rect_shape.size = Vector2(viewport_size.x, catcher_height)

	_update_sprite_scale()


func _update_sprite_scale() -> void:
	if sprite.texture == null:
		return

	var viewport_width := get_viewport_rect().size.x
	var tex_size := sprite.texture.get_size()
	if tex_size.x <= 0.0:
		return

	var uniform_scale := viewport_width / tex_size.x
	sprite.scale = Vector2(uniform_scale, 0.5)

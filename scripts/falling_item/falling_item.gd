class_name FallingItem
extends Area2D

@export var item_size: Vector2 = Vector2(48.0, 48.0)
@export var offscreen_free_margin: float = 100.0

# Assign these 3 textures from the Inspector
@export var red_texture: Texture2D
@export var green_texture: Texture2D
@export var blue_texture: Texture2D

var fall_speed: float = 80.0
var color_index: int = 0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_apply_visual_size()
	randomize_color()


func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta

	if position.y > get_viewport_rect().size.y + offscreen_free_margin:
		queue_free()


func set_fall_speed(value: float) -> void:
	fall_speed = value


func randomize_color() -> void:
	set_color_index(randi_range(0, GameColors.COLORS.size() - 1))


func set_color_index(index: int) -> void:
	color_index = posmod(index, GameColors.COLORS.size())

	match color_index:
		0:
			sprite.texture = red_texture
		1:
			sprite.texture = green_texture
		2:
			sprite.texture = blue_texture
	
	_update_sprite_scale()


func _apply_visual_size() -> void:
	var center := item_size * 0.5

	sprite.position = center
	collision_shape.position = center

	var rect_shape := collision_shape.shape as RectangleShape2D
	if rect_shape != null:
		rect_shape.size = item_size

	_update_sprite_scale()


func _update_sprite_scale() -> void:
	if sprite.texture == null:
		return

	var tex_size := sprite.texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return

	sprite.scale = Vector2(
		item_size.x / tex_size.x,
		item_size.y / tex_size.y
	)

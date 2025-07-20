extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"moving platform/AnimationPlayer".play("move")
	await get_tree().create_timer(2.0).timeout
	$"moving platform2/AnimationPlayer".play("move")
	await get_tree().create_timer(2.0).timeout
	$"moving platform3/AnimationPlayer".play("move")
	await get_tree().create_timer(2.0).timeout
	$"moving platform4/AnimationPlayer".play("move")
	await get_tree().create_timer(2.0).timeout
	$"moving platform5/AnimationPlayer".play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

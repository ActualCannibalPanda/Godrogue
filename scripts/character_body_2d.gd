extends CharacterBody2D

var movement_speed: float = 15.0


func _ready() -> void:
    pass


func _physics_process(_delta: float) -> void:
    move_and_slide()

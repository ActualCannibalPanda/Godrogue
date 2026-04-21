extends CharacterBody2D

var movement_speed: float = 15.0
var movement_target_position: Vector2 = Vector2(60.0, 180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	navigation_agent.link_reached.connect(link_reached)
	
	call_deferred("actor_setup")

func link_reached(details: Dictionary) -> void:
	print("Reached")
	movement_speed = 0.0

func actor_setup() -> void:
	await get_tree().physics_frame
	
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.target_position = movement_target

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
		
		
	navigation_agent.debug_enabled = true
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed

	move_and_slide()

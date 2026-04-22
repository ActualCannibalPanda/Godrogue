extends Node

@onready var camera: Camera2D = $Camera2D

func _ready():
	# Connect the input event to this script
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Check if the event is a left mouse button click
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Get the click position
			var click_position = get_viewport().get_canvas_transform().affine_inverse() * event.position
			# Get the child node named "NPC"
			var npc = $NPC
			if npc:
				print("HERE")
				# Call the set_movement_target method with the click position
				npc.set_movement_target(click_position)

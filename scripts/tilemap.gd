extends Node2D

@onready var layer: TileMapLayer = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(len(layer.get_used_cells()))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	for cell in layer.get_used_cells():
		var tile_data = layer.get_cell_tile_data(cell)
		if tile_data.get_custom_data("walkable"):
			#draw_circle(layer.map_to_local(cell), 10, Color.RED)
			var local = layer.map_to_local(cell)
			var points = []
			var color = Color(randf(),randf(),randf(),1)
			if tile_data.get_collision_polygons_count(0) > 0:
				for i in range(tile_data.get_collision_polygons_count(0)):
					for point in tile_data.get_collision_polygon_points(0, i):
						points.push_back(local + point + layer.position)
					
					if len(points) >= 3:
						draw_polygon(points, [Color.RED, Color.RED, Color.RED, Color.RED])

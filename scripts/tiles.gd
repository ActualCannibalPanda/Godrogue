extends Node2D

@onready var layer: TileMapLayer = $TileMaps/TileMapLayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("create_polygons")

func create_polygons() -> void:
	for cell in layer.get_used_cells():
		var tile_data = layer.get_cell_tile_data(cell)
		if tile_data.get_custom_data("walkable"):
			#draw_circle(layer.map_to_local(cell), 10, Color.RED)
			var local = layer.map_to_local(cell) + layer.position
			var points = []
			if tile_data.get_collision_polygons_count(0) > 0:
				for point in tile_data.get_collision_polygon_points(0, 0):
					points.push_back(local + point)
				
				if len(points) >= 3:
					var polygon = Polygon2D.new()
					polygon.polygon = points
					polygon.color = Color(randf(), randf(), randf(), 1)
					add_child(polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

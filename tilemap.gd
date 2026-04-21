extends Node2D

@onready var layer: TileMapLayer = $TileMapLayer2

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
			if tile_data.get_collision_polygons_count(0) > 0:
				for point in tile_data.get_collision_polygon_points(0, 0):
					var global = get_viewport().get_canvas_transform().affine_inverse() * local
					points.push_back(get_viewport().get_canvas_transform() * (global + point))
				
				if len(points) >= 3:
					draw_polygon(points, [Color.RED, Color.RED,Color.RED,Color.RED])
				

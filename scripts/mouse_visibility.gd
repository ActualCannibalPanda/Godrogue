extends Node2D

@onready var layers: Array[TileMapLayer] = [$TileMapLayer, $TileMapLayer2, $TileMapLayer3, $TileMapLayer4]

var hidden_cells: Array[Vector2i] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(_delta):
	if len(hidden_cells) > 0:
		for layer in layers:
			for cell in hidden_cells:
				layer.set_cell(cell, layer.tile_set.get_source_id(0), layer.get_cell_atlas_coords(cell), 0)
		hidden_cells.clear()

	for layer in layers:
		var map_pos = layer.local_to_map(layer.get_local_mouse_position())
		var map_pos_data = layer.get_cell_tile_data(map_pos)
		if map_pos_data:
			if not map_pos_data.get_custom_data("walkable"):
				layer.set_cell(map_pos, layer.tile_set.get_source_id(0), layer.get_cell_atlas_coords(map_pos), 1)
				hidden_cells.push_back(map_pos)

		for neighbour in layer.get_surrounding_cells(map_pos):
			var neighbour_data = layer.get_cell_tile_data(neighbour)
			if neighbour_data:
				if not neighbour_data.get_custom_data("walkable"):
					layer.set_cell(neighbour, layer.tile_set.get_source_id(0), layer.get_cell_atlas_coords(neighbour), 1)
					hidden_cells.push_back(neighbour)

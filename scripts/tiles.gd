extends Node2D

class Tile:
	var map_index: Vector2i
	var position: Vector2
	var layer: TileMapLayer
	var vertices: Array[Vector2]


@onready var layers: Array[TileMapLayer] = [$TileMaps/TileMapLayer, $TileMaps/TileMapLayer2, $TileMaps/TileMapLayer3, $TileMaps/TileMapLayer4]
@onready var tile_maps: Node2D = $TileMaps

var game_map: Array[Tile] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("create_polygons")


func create_polygons() -> void:
	for z in range(len(layers)):
		var layer = layers[z]
		for cell in layer.get_used_cells():
			var tile = Tile.new()
			tile.map_index = cell
			tile.map_index.x -= z
			for t in game_map:
				if t.map_index == tile.map_index:
					game_map.erase(t)
					break
			var tile_data = layer.get_cell_tile_data(cell)
			if tile_data.get_custom_data("walkable"):
				var local = layer.map_to_local(cell) + layer.position
				var points: Array[Vector2] = []
				if tile_data.get_collision_polygons_count(0) > 0:
					for point in tile_data.get_collision_polygon_points(0, 0):
						points.push_back(local + point + tile_maps.position)

					if len(points) >= 3:
						tile.vertices = points
						game_map.push_back(tile)

	for tile in game_map:
		var polygon = Polygon2D.new()
		polygon.polygon = tile.vertices
		polygon.color = Color(randf(), randf(), randf(), 0.7)
		add_child(polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

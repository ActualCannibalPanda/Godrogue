class_name Map
extends Node2D

class Tile:
    var map_index: Vector2i
    var position: Vector2
    var z_index: int
    var vertices: Array[Vector2]


@onready var layers: Array[TileMapLayer] = [$TileMapLayer, $TileMapLayer2, $TileMapLayer3, $TileMapLayer4]

var hidden_cells: Array[Vector2i] = []

var game_map: Array[Tile] = []


func request() -> void:
    Signals.get_current_tilemaps.emit(layers)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # stop this for now
    Signals.request_tilemaps.connect(request)
    for z in range(len(layers)):
        layers[z].z_index = 90 + z
    #create_polygons()


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

        for n in layer.get_surrounding_cells(map_pos):
            var neighbour_data = layer.get_cell_tile_data(n)
            if neighbour_data:
                if not neighbour_data.get_custom_data("walkable"):
                    layer.set_cell(n, layer.tile_set.get_source_id(0), layer.get_cell_atlas_coords(n), 1)
                    if not hidden_cells.has(n):
                        hidden_cells.push_back(n)

            for n2 in layer.get_surrounding_cells(n):
                var n2_data = layer.get_cell_tile_data(n2)
                if n2_data:
                    if not n2_data.get_custom_data("walkable"):
                        layer.set_cell(n2, layer.tile_set.get_source_id(0), layer.get_cell_atlas_coords(n2), 1)
                        if not hidden_cells.has(n2):
                            hidden_cells.push_back(n2)


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
                        points.push_back(local + point)

                    if len(points) >= 3:
                        tile.vertices = points
                        game_map.push_back(tile)

    for tile in game_map:
        var polygon = Polygon2D.new()
        polygon.polygon = tile.vertices
        polygon.color = Color(randf(), randf(), randf(), 0.7)
        add_child(polygon)

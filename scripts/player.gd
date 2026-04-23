extends Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var layers: Array[TileMapLayer] = []
var game_map: Array[Map.Tile] = []

@onready var player = $Player


func _get_tilemaps(maps: Array[TileMapLayer]) -> void:
    layers = maps


func _ready() -> void:
    Signals.get_current_tilemaps.connect(_get_tilemaps)


func _process(_delta: float) -> void:
    if len(layers) == 0:
        Signals.request_tilemaps.emit()
        return

    if len(game_map) > 0:
        return

    for z in range(len(layers)):
        var layer = layers[z]
        var player_pos = layer.local_to_map(player.position)
        for cell in layer.get_used_cells():
            var dist = (player_pos.x - cell.x) + (player_pos.y - cell.y)
            var tile = Map.Tile.new()
            tile.map_index = cell
            tile.map_index.x -= z
            for t in game_map:
                if t.map_index == tile.map_index:
                    game_map.erase(t)
                    break
            if dist < 2:
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

    return

    for z in range(len(layers)):
        var layer = layers[z]
        var pos = layer.local_to_map(player.position)
        for cell in layer.get_surrounding_cells(pos):
            var tile = Map.Tile.new()
            tile.map_index = cell
            tile.map_index.x -= z
            for t in game_map:
                if t.map_index == tile.map_index:
                    game_map.erase(t)
                    break
            var tile_data = layer.get_cell_tile_data(cell)
            if tile_data:
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
        polygon.color = Color.RED
        add_child(polygon)


func _physics_process(_delta: float) -> void:
    pass

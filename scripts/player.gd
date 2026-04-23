extends Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var layers: Array[TileMapLayer] = []
var game_map: Array[Map.Tile] = []


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

    var new_pos: Vector2 = Vector2.ZERO

    for z in range(len(layers)):
        var layer = layers[z]
        var player_pos = layer.local_to_map(global_position + -layer.position)
        if layer.get_used_cells().has(player_pos):
            new_pos = layer.map_to_local(player_pos) + layer.position
            z_index = 90 + z + 1

    global_position = new_pos

    for z in range(len(layers)):
        var layer = layers[z]
        var player_pos = layer.local_to_map(global_position + -layer.position)
        for cell in layer.get_used_cells():
            var dist = player_pos.distance_to(cell)
            var tile = Map.Tile.new()
            tile.map_index = cell
            tile.map_index.x -= z
            tile.z_index = z
            for t in game_map:
                if t.map_index == tile.map_index:
                    game_map.erase(t)
                    break

            if dist <= 2:
                if cell != player_pos:
                    var tile_data = layer.get_cell_tile_data(cell)
                    if tile_data.get_custom_data("walkable"):
                        var local = layer.map_to_local(cell)
                        var points: Array[Vector2] = []
                        if tile_data.get_collision_polygons_count(0) > 0:
                            for point in tile_data.get_collision_polygon_points(0, 0):
                                points.push_back(local + point + layer.position)

                            if len(points) >= 3:
                                tile.vertices = points
                                game_map.push_back(tile)

    for tile in game_map:
        var polygon = Polygon2D.new()
        polygon.polygon = tile.vertices
        polygon.color = Color(Color.RED, 0.5)
        polygon.z_index = 90 + tile.z_index
        get_tree().root.add_child(polygon)


func _physics_process(_delta: float) -> void:
    pass

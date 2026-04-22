extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var tilemaps: Array[TileMapLayer] = []


func _get_tilemaps(maps: Array[TileMapLayer]) -> void:
    tilemaps = maps


func _ready() -> void:
    Signals.get_current_tilemaps.connect(_get_tilemaps)


func _process(delta: float) -> void:
    if len(tilemaps) == 0:
        Signals.request_tilemaps.emit()
        return

    for layer in tilemaps:
        for cell in layer.get_used_cells():
            var tile_data = layer.get_cell_tile_data(cell)
            if tile_data.get_custom_data("walkable"):
                var local = layer.map_to_local(cell) + layer.position
                var points: Array[Vector2] = []
                if tile_data.get_collision_polygons_count(0) > 0:
                    for point in tile_data.get_collision_polygon_points(0, 0):
                        points.push_back(local + point + tile_maps.position)

                    if len(points) >= 3:
                        game_map.push_back(tile)

    for tile in game_map:
        var polygon = Polygon2D.new()
        polygon.polygon = tile.vertices
        polygon.color = Color(randf(), randf(), randf(), 0.7)
        add_child(polygon)


func _physics_process(_delta: float) -> void:
    pass

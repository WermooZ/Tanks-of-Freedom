extends "res://scripts/bag_aware.gd"

var grid = {}
var map_grid = {}

var astar = AStar.new()
var is_grid_clean = false

var obstacles = []
var new_obstacles = []

func _initialize():
    self.prepare_grid()
    self.is_grid_clean = true

func path_search(start, goal):
    var path = []
    for id in self.astar.get_id_path(self.pos_2_point_id(start), self.pos_2_point_id(goal)):
        path.push_back(self.point_id_2_pos(id))

    return path

func prepare_map_grid(abstract_map):
    var field = null
    var pos = null
    for id in self.grid:
        field = abstract_map.get_field(self.point_id_2_pos(id))
        self.map_grid[id] = {
            "passable"  : field.is_passable(),
        }

    if !self.is_grid_clean:
       self.__reset_grid()

    self.connect_passable_tiles()
    self.is_grid_clean = false

func prepare_grid():
    var id = 0
    for x in range(self.bag.abstract_map.MAX_MAP_SIZE):
        for y in range(self.bag.abstract_map.MAX_MAP_SIZE):
            id = self.get_point_id(x, y)
            self.grid[id] = {
                "neighbors":{
                    "u" : Vector2(x  ,y-1),
                    "r" : Vector2(x+1,y  ),
                    "d" : Vector2(x  ,y+1),
                    "l" : Vector2(x-1,y  ),
                },
                    "pos" : Vector2(x, y),
            }
            self.astar.add_point(id, Vector3(x, y, 0))

func set_obstacles(obstacle_positions):
    for position in obstacle_positions:
        self.new_obstacles.push_back(self.get_point_id(position.x, position.y))
    for id in self.bag.helpers.array_diff(self.obstacles, self.new_obstacles):
        self.connect_point(id)
    for id in self.bag.helpers.array_diff(self.new_obstacles, self.obstacles):
        self.disconnect_point(id)

    self.obstacles = Array(self.new_obstacles)
    self.new_obstacles = []

func get_distance(start, end):
    return abs(start.x - end.x) + abs(start.y - end.y)

func connect_passable_tiles():
    for tile_id in grid:
        if map_grid[tile_id].passable:
            self.connect_point(tile_id)

func connect_all():
    for tile_id in grid:
        self.connect_point(tile_id)

func connect_point(tile_id):
    for id in self.get_adjacement_tile_ids(tile_id):
        if not astar.are_points_connected(tile_id, id):
             astar.connect_points(tile_id, id)

func disconnect_all():
    for tile_id in grid:
        disconnect_point(tile_id)

func disconnect_point(tile_id):
	for id in get_adjacement_tile_ids(tile_id):
		if astar.are_points_connected(tile_id, id):
			astar.disconnect_points(tile_id, id)

func get_point_id(x, y):
    return x * 1000 + y

func pos_2_point_id(pos):
    return get_point_id(pos.x, pos.y)

func point_id_2_pos(id):
    return self.grid[id].pos

func get_adjacement_tile_ids(tile_id):
    if !self.grid.has(tile_id):
       #print('missing ', tile_id)
       return IntArray([])

    var neighbors = self.grid[tile_id]["neighbors"]
    var ids = IntArray([])
    for direction in ["u","r","d","l"]:
        ids.push_back(self.get_point_id(neighbors[direction].x, neighbors[direction].y))

    return ids

func refresh_grid():
    print('refresh grid')

func reset_obstacles():
    self.obstacles.clear()
    self.new_obstacles.clear()

func __reset_grid():
     if !self.is_grid_clean:
         self.disconnect_all()
         self.reset_obstacles()
     self.is_grid_clean = false



var abstract_map
var actions
var pathfinding
var positions
var action_builder

const MINIMAL_DISTANCE = 4

func _init(abstract_map_object, actions_object, pathfinding_object, action_builder_object, positions_object):
    self.abstract_map = abstract_map_object
    self.actions = actions_object
    self.pathfinding = pathfinding_object
    self.action_builder = action_builder_object
    self.positions = positions_object

func push_front(unit, buildings, actual_cost_grid):
    print('push')
    if buildings.size() == 0:
        return

    var closest_destination = null
    var closest_path_length = 999
    var path
    var distance
    var destination
    var unit_pos = unit.get_pos_map()
    for position in buildings:
        distance = self.pathfinding.__get_manhattan(unit_pos, position)
        if distance >= self.MINIMAL_DISTANCE :
            if closest_destination == null || distance < closest_path_length:
                closest_destination = position
                closest_path_length = distance

    if closest_destination != null:
        path = self.__get_path(unit_pos, closest_destination, actual_cost_grid)
        if path.size() == 0:
            return
        var next_tile = path[0]
        if next_tile == unit_pos:
            next_tile = path[1]
        var action = self.action_builder.create(self.action_builder.ACTION_MOVE, unit, [next_tile])
        self.actions.append_action(action, 100 - closest_path_length)

func __get_unocupied_destination(position, actual_cost_grid, unit_pos):
    for lookup_range in self.positions.tiles_building_lookup_ranges:
        var destinations = self.positions.get_nearby_tiles_subset(position, lookup_range)
        for dest in destinations:
            if actual_cost_grid.has(dest) && actual_cost_grid[dest].walkable:
                return dest

    return position

func __get_path(unit_pos, destination, actual_cost_grid, level=0):
    if level >= 3:
        return []

    var unocupied_dest = self.__get_unocupied_destination(destination, actual_cost_grid, unit_pos)
    var path = self.pathfinding.pathSearch(unit_pos, unocupied_dest)
    print('from ', unit_pos,' to ', unocupied_dest, ' path ', path)

    if (path.size() == 0):
        level = level + 1
        return self.__get_path(unit_pos, self.__get_subdestination(unit_pos, destination), actual_cost_grid, level)

    return path

func __get_subdestination(s, d):
    return Vector2(int((s.x + d.x) / 2), int((s.y + s.y) / 2))

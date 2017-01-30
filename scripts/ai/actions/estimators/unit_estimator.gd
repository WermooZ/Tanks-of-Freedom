const WAYPOINT_WEIGHT = 50

var bag
var score
var waypoint_value = {0: 10, 1 : 4, 2: 3, 3: 5, 4: 2} # building types

func __ap_level(unit):
	return 1.0 * unit.ap / unit.max_ap

func __health_level(unit):
	return 1.0 * unit.life / unit.max_life

func get_target_object(action):
    return self.bag.abstract_map.get_field(action.path[1]).object

func can_move(action):
    var field = self.bag.abstract_map.get_field(action.path[1])
    if field.has_building() or field.has_unit():
        return false

    return true

func get_waypoint_value(action):
    var type = self.bag.abstract_map.get_field(action.destination.position_on_map).object.type

    #TODO - stub for waypoint handling
    return self.waypoint_value[type]

func enemies_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 4)
    return self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player)

func buildings_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 6)
    return self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, action.unit.player) + self.bag.positions.get_nearby_empty_buldings(nearby_tiles)

func target_can_be_captured(action):
    var tile = self.bag.abstract_map.get_field(action.path[1])
    if !action.unit.can_capture_building(tile.object):
        return false

    return true
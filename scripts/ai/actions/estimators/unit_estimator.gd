const WAYPOINT_WEIGHT = 100

var bag
var score

func __ap_level(unit):
	return 1.0 * unit.ap / unit.max_ap

func __health_level(unit):
	return 1.0 * unit.life / unit.max_life

#func __turns_to_finish():
#	# distance to destination
#    var turns_to_finish = distance / action.unit.max_ap
#    if (turns_to_finish > 0):
#        mod = mod + (10 - (10 / turns_to_finish))

func get_waypoint_value(action):
    var tile = self.bag.abstract_map.get_field(action.destination.position_on_map)
    #TODO - stub for waypoint handling
    if tile.object.type == 0:
    	return 10
    if tile.object.type == 1:
    	return 4
    if tile.object.type == 2:
    	return 3
    if tile.object.type == 3:
    	return 5
    if tile.object.type == 4:
    	return 2

func enemies_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 4)
    return self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player)
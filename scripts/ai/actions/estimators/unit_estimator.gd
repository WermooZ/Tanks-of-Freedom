const WAYPOINT_WEIGHT = 100
var bag

func __ap_level(unit):
	return 1.0 * unit.ap / unit.max_ap

func __health_level(unit):
	return 1.0 * unit.life / unit.max_life

#func __turns_to_finish():
#	# distance to destination
#    var turns_to_finish = distance / action.unit.max_ap
#    if (turns_to_finish > 0):
#        mod = mod + (10 - (10 / turns_to_finish))

func get_waypoint_value(pos): #TODO - create waypoints
    return 1
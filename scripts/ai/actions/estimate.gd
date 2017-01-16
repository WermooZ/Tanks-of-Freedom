extends "res://scripts/bag_aware.gd"

func run(action):
    if action.group == 'unit':
        return self.__estimate_unit(action)
    else:
        return self.__estimate_building(action)

func __estimate_unit(action):
    if action.path.size() == 0:
        action.path = self.bag.a_star.path_search(action.start, action.destination.get_pos_map())

    var distance = action.path.size()
    if distance == 0:
        print('path size zero!')
        return

    action.score = 0
    self.bag.estimate_strategy.score(action)

    return action.score

func __estimate_building(action):
    var mod = 1
    if self.bag.abstract_map.get_field(action.unit.spawn_point).object:
        action.score = 0
        return 0

    # enemies modifier
    var nearby_tiles
    for lookup_range in [1,2,3,4,5]:
        nearby_tiles = self.bag.positions.get_nearby_tiles(action.start, lookup_range)
        mod = mod + 5 * (self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player).size() * (6 - lookup_range))

    # distance modifier (further from base TODO - closer to enemy?)
    var distance_from_hq = self.bag.a_star.get_distance(action.start, self.bag.positions.get_player_bunker_position(action.unit.player))
    if distance_from_hq > 10:
        mod = mod + distance_from_hq - 10

    # unit count modifier
    mod = mod + self.bag.new_ai.SPAWN_LIMIT - self.bag.positions.get_player_units(action.unit.player).size()

    action.score = mod * 10
    return action.score

extends "res://scripts/bag_aware.gd"

var thread
var processed_units_object_ids = []
var player
var player_ap
var own_units

const MIN_DESTINATION_PER_UNIT = 2
const SPAWN_LIMIT = 50
const THREADED = false

func _initialize():
    thread = Thread.new()

func start_do_ai(current_player, player_ap):
    if self.THREADED:
        if (thread.is_active()):
            return
        thread.start(self, "__do_ai_thread", {"player" : current_player, "ap" : player_ap})
    else:
        self.__do_ai(current_player, player_ap)

func __do_ai_thread(params):
    #do ai stuff
    var result = self.__do_ai(params["player"], params["ap"])
    call_deferred("__ai_done")
    return result

func __ai_done():
    var result = thread.wait_to_finish()
    # TODO - obsługa - czy koniec tury czy może nie? czy wykonywanie akcji i proceed
    return result

func __do_ai(current_player, player_ap):
    self.player = current_player
    self.player_ap = player_ap

    self.__prepare_unit_actions()
    self.__prepare_building_actions()

    return self.bag.new_actions.execute_best_action()

func __can_be_processed(unit):
    var unit_instance_id = unit.get_instance_ID()
    if self.processed_units_object_ids.has(unit_instance_id):
        return false

    self.processed_units_object_ids.has(unit_instance_id) = true
    return true

func __prepare_unit_actions():
    var destinations = null
    for unit in self.bag.positions.get_player_units(self.player).values():
        if self.__can_be_processed(unit):
            if unit.ap > 0:
                for destination in self.__gather_destinations(unit):
                    self.__add_action(unit, destination)

func __gather_destinations(unit):
    var destinations = Vector2Array()
    var nearby_tiles
    for lookup_range in self.bag.positions.tiles_lookup_ranges: #max 8 distance
        nearby_tiles = self.bag.positions.get_nearby_tiles(unit.position_on_map, lookup_range)

        destinations = self.bag.positions.get_nearby_enemies(nearby_tiles, self.player)

        if unit.type == 0:
            destinations = destinations + self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, self.player)
            destinations = destinations + self.bag.positions.get_nearby_empty_buldings(nearby_tiles)
        else:
           for building in self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, self.player):
               #TODO destinations[building.get_spawn_point_pos()] = true
               print('block spawn point')

        if destinations.size() > self.MIN_DESTINATION_PER_UNIT:
            return destinations

    return destinations

func __prepare_building_actions():
    if self.bag.positions.get_player_units(self.player).size() >= SPAWN_LIMIT:
        return

    for building in self.bag.positions.get_player_buildings(self.player).values():
        if (building.type == 4): # skip tower
            continue
        self.__add_action(building, null)

func __add_action(unit, destination):
    self.bag.new_actions.add_action(unit, destination)

func reset():
    self.prepared_units.clear()
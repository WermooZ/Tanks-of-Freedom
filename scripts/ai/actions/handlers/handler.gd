var bag

func __get_next_tile_from_path(path):
    if path.size() < 2:
        return null

    return self.bag.abstract_map.get_field(path[1])

func mark_unit_for_calculations(unit):
    self.bag.new_ai.processed_units_object_ids.remove(unit.get_instance_ID())

func remove_for_unit(unit, exept = null):
    for action in self.bag.new_actions.actions:
        if action.unit == unit and action != exept:
            self.bag.new_actions.remove(action)

func remove_for_target(processed_action, exept = null):
    var pos = processed_action.path[1]
    for action in self.bag.new_actions.actions:
        if action != exept:
            for i in range(action.path.size()):
                if i >= 1 and pos == action.path[i] :
                    self.bag.new_actions.remove(action)
                    continue

# invalidation when destination changes owner or dead
func remove_for_destination(processed_action):
    var destination = self.bag.helpers.array_last_element(processed_action.path)
    for action in self.bag.new_actions.actions:
        if self.bag.helpers.array_last_element(action.path) == destination:
#            self.__info(action, '-d ')
            self.bag.new_actions.remove(action)

func remove_for_type(type):
    for action in self.bag.new_actions.actions:
        if action.type == type:
            self.bag.new_actions.remove(action)

func get_actions_for_unit(unit):
    var unit_actions = []
    for action in self.bag.new_actions.actions:
        if action.unit == unit:
            unit_actions.append(action)
        
    return unit_actions


# this will block action from run until conditions change
func set_zero_score(action):
    action.score = 0

func __info(action, string=''):
    print(string, "execute id:", action.get_instance_ID(), " t: "+ action.type, " s: ", action.unit.position_on_map, "u", action.unit, " d:", action.destination, " p: ", action.path," score: ", action.score)

func __on_fail(action):
    action.fails = action.fails + 1
    action.score = action.score - 20
    if action.fails >= 3:
        self.bag.new_actions.remove(action)




var bag

func __get_next_tile_from_path(path):
    if path.size() < 2:
        return null

    return self.bag.abstract_map.get_field(path[1])

func __invalidate_for_unit(unit, exept = null):
    for action in self.bag.new_actions.actions:
        if action.unit == unit and action != exept:
            self.bag.new_actions.remove(action)

    self.bag.new_ai.processed_units_object_ids.remove(unit.get_instance_ID())

func __invalidate_for_target(processed_action, exept = null):
    var pos = processed_action.path[1]
    for action in self.bag.new_actions.actions:
        if action != exept:
            for i in range(action.path.size()):
               if i > 0 and i < 8:
                    if pos == action.path[i]:
                        self.bag.new_actions.remove(action)
                        continue

    self.bag.new_ai.processed_units_object_ids.remove(processed_action.unit.get_instance_ID())

# invalidation when destination changes owner or dead
func __invalidate_for_destination(processed_action):
    var destination = self.bag.helpers.array_last_element(processed_action.path)
    for action in self.bag.new_actions.actions:
        if self.bag.helpers.array_last_element(action.path) == destination:
            self.bag.new_actions.remove(action)

    self.bag.new_ai.processed_units_object_ids.remove(processed_action.unit.get_instance_ID())

func __info(action):
    print("execute id:", action.get_instance_ID(), " t: "+ action.type, " s: ", action.unit.position_on_map, " d:", action.destination, " p: ", action.path," score: ", action.score)

func __on_fail(action):
    action.fails = action.fails + 1
    action.score = action.score - 20
    if action.fails >= 3:
        self.bag.new_actions.remove(action)




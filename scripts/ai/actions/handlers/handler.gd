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

func __invalidate_for_target(action):
    var pos = action.path[1]
    for action in self.bag.new_actions.actions:
        for i in range(action.path.size()):
           if i > 0 and i < 8:
                if pos == action.path[i]:
                    self.bag.new_actions.remove(action)
                    continue

    self.bag.new_ai.processed_units_object_ids.remove(action.unit.get_instance_ID())

func __info(action):
    var dest = null
    if action.path.size() >= 2:
        dest = action.path[1]
    print("execute "+ action.type, " s: ", action.unit.position_on_map, " d:", dest, " p: ", action.path," score: ", action.score)

func __on_fail(action):
    action.fails = action.fails + 1
    action.score = action.score - 20
    if action.fails >= 3:
        self.bag.new_actions.remove(action)




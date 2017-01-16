extends "res://scripts/bag_aware.gd"

var actions = {}
var action = preload('actions/action.gd')

func add_action(unit, destination):
    var action = self.create_action(unit, destination)
    action.score = self.bag.estimate.run(action)

    #TODO - bedzie scierwic przy 0 (moze odsiac mniejsze od 100?)
    if self.actions.has(action.score):
        action.score = action.score + floor(randf() * 20)
        #print('score exists')

    self.actions[action.score] = action

func create_action(unit, destination):
    return action.new(unit.position_on_map, destination, unit, unit.group)

func execute_best_action():
    var action = self.get_best_action()
    #print("best: ", action.type, " -> ", action.path[1])
    if action != null:
        return self.bag.action_handler.execute(action)
    #print(action)

    return action

func get_best_action():
    if self.actions.empty():
        return null
    return actions[self.__get_max_key(actions.keys())]

func clear():
    self.actions.clear()

func __get_max_key(keys):
    var max_key = 0
    for key in keys:
        if (key > max_key):
            max_key = key

    return max_key
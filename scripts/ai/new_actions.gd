extends "res://scripts/bag_aware.gd"

var actions = []
var action = preload('actions/action.gd')

func add_action(unit, destination):
    var action = self.create_action(unit, destination)
    self.bag.estimate.run(action)
    self.actions.append(action)

func create_action(unit, destination):
    return action.new(unit.position_on_map, destination, unit, unit.group)

func execute_best_action(player):
    var action = self.get_best_action(player)
    #print("best: ", action.type, " -> ", action.path[1])
    if action != null:
        return self.bag.action_handler.execute(action)

    return false

func get_best_action(player):
    if self.actions.empty():
        return null

    var best = null
    self.actions.sort_custom(self, "__best_first")
    for action in self.actions:
        if action.unit.player == player:
           best = action
           break

    if best == null or best.score == 0:
        return null

    return best

func __best_first(a, b):
    if b != null and a.score > b.score:
        return true
    return false

func clear():
    self.actions.clear()
    self.actions = []

func remove(action):
    self.actions.erase(action)



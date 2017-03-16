extends "res://scripts/bag_aware.gd"

var actions = []
var action = preload('actions/action.gd')

func add_action(unit, destination):
    if self.get_action(unit, destination):
#        print("similar action exists - skipping!!!")
        return

    var action = self.create_action(unit, destination)
    #self.bag.estimate.run(action) #TODO this is not needed
    self.actions.append(action)

func create_action(unit, destination):
    return action.new(unit.position_on_map, destination, unit, unit.group)

func execute_best_action(action):
    if action != null:
        return self.bag.action_handler.execute(action)

    return false

func get_best_action(player):
    if self.actions.empty():
        return null

    self.reestimate_user_actions(player)
    var best = null
    self.actions.sort_custom(self, "__best_first")
    for action in self.actions:
        action.__info()
    for action in self.actions:
        if action.unit.player == player:
           best = action
           break
#    best.__info()
    if best == null or best.score == 0:
        return null

    return best

func reestimate_user_actions(player):
    for action in self.actions:
        if self.remove_if_faulty(action):
            continue
        if action.unit.player == player:
            self.fix_path_if_faulty(action)
            self.bag.estimate.run(action)

func __best_first(a, b):
    if b != null and a.score > b.score:
        return true
    return false

func clear():
    self.actions.clear()
    self.actions = []

func remove(action):
    action.status = 1
    self.actions.erase(action)

func reset():
    self.actions.clear()

func fix_path_if_faulty(action): #TODO - this pobably should be done in action handler?
    if action.path.size() and action.unit.position_on_map != action.path[0]:
        #print("fix pathv - path bug")
        action.fix_path()
        return true
    return false

func remove_if_faulty(action):
    if action.type != "spawn" and action.type != null and action.unit.life == 0: #WTF?
        self.actions.erase(action)
        #print("removed faulty action - spawn bug")
        return true
    return false

func get_action(unit, destination): #TODO a bit uneficcient way to check this - try to create separate class for holding calculation status and destiantions
    for action in self.actions:
        if action.unit == unit && action.destination == destination:
            return true

    return false



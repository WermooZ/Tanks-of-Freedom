extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    self.__info(action)
    var field = self.__get_next_tile_from_path(action.path)
    if field  != null:
        var active_field = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        print("active field", active_field.object.position_on_map)
        if self.bag.controllers.action_controller.handle_action(field.position) == 1:
            self.__on_success(action)
            return true

    self.__on_fail(action)
    return false

func __on_success(action):
    self.__invalidate_for_target(action, action)
    self.__invalidate_for_unit(action.unit, action)
    action.proceed()
    if action.path.size() >= 2:
        self.bag.estimate_strategy.score(action)
    else:
        self.bag.new_actions.remove(action)

func __on_fail(action):
    print("fail")

    self.__invalidate_for_unit(action.unit) #TODO - smth wrong

    #reset path - path will be recalculated with pathfinding
    #action.path = self.bag.a_star.path_search(action.start, action.destination.get_pos_map())
    #self.bag.estimate_strategy.score(action)






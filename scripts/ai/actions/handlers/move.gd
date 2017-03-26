extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    var field = self.__get_next_tile_from_path(action.path)
    if field  != null:
        var active_field = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        if active_field.object != null:
            var res = self.bag.controllers.action_controller.handle_action(field.position)
            if res["status"] == 1: #TODO wtf?
                self.__on_success(action)
                return true
        else:
            print("field is null ", action.unit.life)

    self.__on_fail(action)
    return false

func __on_success(action):
    action.proceed()
    self.remove_for_unit(action.unit, action)
    self.mark_unit_for_calculations(action.unit)
    if action.unit.ap == 0:
        action.score = 0
    #self.remove_for_unit(action.unit, action)
#    action.proceed()
#    if action.path.size() >= 2:
#        self.bag.estimate_strategy.score(action)
#    else:
#        self.bag.new_actions.remove(action)
#
#    self.remove_for_unit(action.unit)
#

#func __on_fail(action):
#    print("fail")
#    action.proceed = 0
#    action.path = Vector2Array([]) #action should be reestimated and new path
#    #self.remove_for_unit(action.unit) #TODO - smth wrong
#    #self.mark_unit_for_calculations(action.unit)
#
#    #reset path - path will be recalculated with pathfinding
#    #action.path = self.bag.a_star.path_search(action.start, action.destination.get_pos_map())
#    #self.bag.estimate_strategy.score(action)






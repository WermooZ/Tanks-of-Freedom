extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    self.__info(action)
    var field = self.__get_next_tile_from_path(action.path)
    if field  != null:
        var active_field = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        if active_field.object != null:
            var res = self.bag.controllers.action_controller.handle_action(field.position)
            print(res)
            if res["status"] == 1: #TODO wtf?
                self.__on_success(action)
                return true
        else:
            print("field is null ", action.unit.life)

    self.__on_fail(action)
    return false

func __on_success(action):
    self.remove_for_target(action, action)
    #self.remove_for_unit(action.unit, action) TODO trzeba by dodac do puli przeliczania/ i sprawdzanie czy akcja istnieje
#    action.proceed()
#    if action.path.size() >= 2:
#        self.bag.estimate_strategy.score(action)
#    else:
#        self.bag.new_actions.remove(action)
#
    self.remove_for_unit(action.unit)
    self.mark_unit_for_calculations(action.unit)

func __on_fail(action):
    print("fail")
    action.path = Vector2Array([]) #action should be reestimated and new path
    print("unit ap", action.unit.ap)
    #self.remove_for_unit(action.unit) #TODO - smth wrong
    #self.mark_unit_for_calculations(action.unit)

    #reset path - path will be recalculated with pathfinding
    #action.path = self.bag.a_star.path_search(action.start, action.destination.get_pos_map())
    #self.bag.estimate_strategy.score(action)






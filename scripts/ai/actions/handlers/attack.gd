extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    self.__info(action)

    var field = self.__get_next_tile_from_path(action.path)
    if field != null:
        self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        if self.bag.controllers.action_controller.handle_action(field.position) == 1:
            self.__on_success(action)
            return true

    self.__on_fail(action)
    return false

func __on_success(action):
    self.bag.positions.refresh_units()
    if action.destination.life == 0:
        # if unit killed all action connected to him will be invalidated
        self.__invalidate_for_destination(action)

    self.__invalidate_for_unit(action.unit)

extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print("execute "+ action.type)

    var field = self.__get_next_tile_from_path(action.path)
    if field != null:
        self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        if self.bag.controllers.action_controller.handle_action(field.position) == 1:
            self.__after()
            return true

    return false

func __after():
    self.bag.positions.refresh_buildings()
extends "res://scripts/bag_aware.gd"

var estimators = []

func _initialize():
    self.estimators = [
        load('res://scripts/ai/actions/estimators/soldier_estimator.gd').new(self.bag),
        load('res://scripts/ai/actions/estimators/tank_estimator.gd').new(self.bag),
        load('res://scripts/ai/actions/estimators/helicopter_estimator.gd').new(self.bag)
    ]

func score(action):
    # TODO - sprawdzic jak robiony jest path
    #print(action.path)
    var next_tile = self.bag.abstract_map.get_field(action.path[1])
    if (next_tile.object == null):
        return self.estimators[action.unit.type].__score_move(action)

    else:
        if next_tile.has_building():
            return self.estimators[action.unit.type].__score_capture(action)
        elif next_tile.object.group == 'unit':
            return self.estimators[action.unit.type].__score_attack(action)
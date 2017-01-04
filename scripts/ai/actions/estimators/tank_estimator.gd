extends "res://scripts/ai/actions/estimators/unit_estimator.gd"

func _init(bag):
    self.bag = bag

func __score_move(action):
    return 4

func __score_attack(action):
    return 6
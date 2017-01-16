extends "res://scripts/bag_aware.gd"

var handlers = []

func _initialize():
    self.handlers = {
        "capture" : load('res://scripts/ai/actions/handlers/capture.gd').new(self.bag),
        "move"    : load('res://scripts/ai/actions/handlers/move.gd').new(self.bag),
        "attack"  : load('res://scripts/ai/actions/handlers/attack.gd').new(self.bag)
    }

func execute(action):
    return self.handlers[action.type].execute(action)

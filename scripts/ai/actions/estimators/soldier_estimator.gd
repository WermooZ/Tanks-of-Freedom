extends "res://scripts/ai/actions/estimators/unit_estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

const CAPTURE_MOD = 300
const ATTACK_MOD  = 200
const MOVE_MOD    = 100

var capture_modifiers = IntArray([5, 2, 2])
var attack_modifiers = IntArray([4, 6, 8])
var move_capture_modifiers = IntArray([5, 2, 3])
var move_attack_modifiers = IntArray([2, 2, 5])

func _init(bag):
    self.bag = bag

func __score_capture(action):
    action.type = "capture"
    var enemy = self.get_target_object(action)
    if action.unit.player == enemy.player:
        return

    if action.unit.ap == 0:
        return

    if !self.target_can_be_captured(action):
        return

    if self.get_target_object(action).type == 4 and self.enemies_in_sight(action).size():
        return

    var score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # lower health is better
    score = score + (1 - self.__health_level(action.unit))

    action.score = self.CAPTURE_MOD + score
#    print("attack ", self.CAPTURE_MOD + score)



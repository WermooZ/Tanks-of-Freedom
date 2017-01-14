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

func __score_move(action):
    action.type = "move"

    # if enemies nearby dont use last ap (defend)
    if action.unit.ap == 1 and !action.unit.can_attack() and self.enemies_in_sight(action).size():
        return

    var score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # higher ap is better
    score = score + self.__health_level(action.unit) * 20

    # depending on target (unit like to capture building more than tank) - move attack / move capture
    action.score = self.MOVE_MOD + score

func __score_capture(action):
    action.type = "capture"
    if action.unit.ap == 0:
        return

    var score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # lower health is better
    score = score + (1 - self.__health_level(action.unit))

    action.score = self.CAPTURE_MOD + score


func __score_attack(action):
    action.type = "attack"
    if action.unit.ap == 0 or !action.unit.can_attack():
        return

    # highr health is better
    var score = self.__health_level(action.unit) * 20

    # doest enemy will be killed
    # action.destination.hp < action.unit.attack

    # does enemy have shild (doesnt matter if he will be killed)
    # action.destination.can_defend()

    # is enemy close to hq / building ?


    #print(self.__health_level(action.unit))
    return self.ATTACK_MOD + score
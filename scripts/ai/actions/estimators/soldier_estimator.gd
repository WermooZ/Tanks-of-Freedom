extends "res://scripts/ai/actions/estimators/unit_estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

func _init(bag):
    self.bag = bag

func __score_move(action):
    var mod = self.__get_waypoint_value(action.destination) * self.WAYPOINT_WEIGHT

    # higher ap is better
    action.score = action.score + self.__health_ap(action.unit)

    # if enemies nearby dont use last ap (defend)

    # depending on target (unit like to capture building more than tank) - move attack / move capture

func __score_capture(action):
    var mod = self.__get_waypoint_value(action.destination) * self.WAYPOINT_WEIGHT

    # lower health is better
    action.score = action.score + (1 - self.__health_level(action.unit))


func __score_attack(action):

    # highr health is better

    # doest enemy will be killed

    # does enemy have shild (doesnt matter if he will be killed)

    # is enemy close to hq / building ?


    print(self.__health_level(action.unit))
    return 6
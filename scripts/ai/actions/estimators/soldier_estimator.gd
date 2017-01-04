extends "res://scripts/ai/actions/estimators/unit_estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

func _init(bag):
    self.bag = bag

func __score_move(action):
    self.score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # higher ap is better
    action.score = action.score + self.__health_level(action.unit)

    # if enemies nearby dont use last ap (defend)
    self.enemies_in_sight(action).size()

    # depending on target (unit like to capture building more than tank) - move attack / move capture

func __score_capture(action):
    self.score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # lower health is better
    action.score = action.score + (1 - self.__health_level(action.unit))


func __score_attack(action):

    # highr health is better
    self.score = self.__health_level(action.unit) * 20

    # doest enemy will be killed
    # action.destination.hp < action.unit.attack

    # does enemy have shild (doesnt matter if he will be killed)
    # action.destination.can_defend()

    # is enemy close to hq / building ?


    #print(self.__health_level(action.unit))
    return 6
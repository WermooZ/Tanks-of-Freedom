var start       = Vector2(0,0)
var destination = null
var score       = 0
var path        = Vector2Array([])
var unit        = null
var group       = null
var type        = null
var fails       = 0
var proceed     = 0
var status      = 0

func _init(start, destination, unit, group):
    self.group = group
    self.start = start
    self.destination = destination
    self.unit = unit

func proceed():
    var path = Array(self.path)
    path.pop_front()
    self.path = Vector2Array(path)
    self.start = path[0]
    self.unit.add_move(path[0])
    self.proceed = self.proceed + 1

func fix_path(): #TODO - do it better maybe in pathfinding
    var path = Vector2Array([self.unit.position_on_map])
    path.append_array(self.path)
    self.path = path

func __info(string=''):
    if self.unit.type != 1:
        return
    print(string, "execute id:", self.get_instance_ID(), " t: "+ self.type, " s: ", self.unit.position_on_map, " u: ", self.unit, " d:", self.destination, " p: ", self.path," proc: ",self.proceed, " score: ", self.score)
    if self.destination:
        pass
        #print("gr:", self.destination.group)

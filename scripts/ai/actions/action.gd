var start = Vector2(0,0)
var destination = null
var score = 0
var path  = Vector2Array([])
var unit = null
var group = null

func _init(start, destination, unit, group):
    self.group = group
    self.start = start
    self.destination = destination
    self.unit = unit

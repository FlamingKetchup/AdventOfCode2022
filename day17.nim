import strutils, sequtils, sets, sugar
from algorithm import reversed

type
  Point = tuple
    x, y: int
  Chamber = seq[array[7, bool]] 

const shapes = ["""
####""",
"""
.#.
###
.#.""",
"""
..#
..#
###""",
"""
#
#
#
#""",
"""
##
##"""].map(func(shape: string): HashSet[Point] =
  # Putting splitLines in the for causes it to be interpreted as an iterator
  let asLines = shape.splitLines
  for y, line in asLines.reversed:
    for i, c in line:
      if c == '#': result.incl((i+2, y)))

let jet = readFile("day17input.txt").strip
var
  emptyLine: array[7, bool]
  chamber: Chamber
  jetIndex = 0

proc `[]`(c: Chamber, x, y: int): bool =
  if y <= c.high: c[y][x] else: false

proc `[]=`(c: var Chamber, x, y: int, value: bool) =
  if value:
    while c.high < y:
      c.add(emptyLine)
    c[y][x] = true
  elif y <= c.high:
    c[y][x] = false

proc collides(shape: HashSet[Point]): bool =
  for (x, y) in shape:
    if x < 0 or x > 6 or y < 0 or chamber[x, y]: return true

for i in 1..222:
  var shape = shapes[(i-1) mod 5]
  shape = shape.map(point => (point.x, point.y + chamber.len + 3))
  while true:
    var newShape = shape
    case jet[jetIndex]:
      of '<': newShape = newShape.map(point => (point.x-1, point.y))
      of '>': newShape = newShape.map(point => (point.x+1, point.y))
      else: raise newException(ValueError,
                               jet[jetIndex] & "is not a valid jet pattern")
    jetIndex = (jetIndex+1) mod jet.len
    if not newShape.collides: shape = newShape
    newShape = shape
    newShape = newShape.map(point => (point.x, point.y-1))
    if not newShape.collides: shape = newShape
    else:
      for (x, y) in shape:
        chamber[x, y] = true
      break
  echo jetIndex

echo "Part 1: ", chamber.len

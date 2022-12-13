import strutils, sequtils

type
  Map = object
    w, h: int
    internal: seq[int]

proc `[]`(m: Map, x, y: int): int = m.internal[x + y*m.w]

proc `[]`(m: Map, xy: (int, int)): int = m.internal[xy[0] + xy[1]*m.w]

proc `[]=`(m: var Map, x, y, val: int) =
  m.internal[x + y*m.w] = val

proc `[]=`(m: var Map, xy: (int, int) , val: int) =
  m.internal[xy[0] + xy[1]*m.w] = val

proc `$`(m: Map): string = m.internal.distribute(m.h).join("\n")

let
  f = readFile("day12input.txt").strip
  fLines = f.splitLines

var
  internal: seq[int]
  start, endpoint: (int, int)

# sugar.collect doesn't work with discard
for c in f:
  case c
    of 'S':
      
      internal.add(1)
    of 'E': internal.add(26)
    of 'a'..'z': internal.add(c.ord - 96)
    else: discard

let m = Map(w: f.find('\n') - 1, h: f.countLines, internal: internal)

for y, l in fLines:
  for x, c in l:
    case c
      of 'S': start = (x, y)
      of 'E': endpoint = (x, y)
      else: discard

var
  frontier: seq[(int, int)]
  cost = Map(w: m.w, h: m.h, internal: newSeq[int](m.w * m.h))

frontier.add(start)

proc adjacent(x, y: int): seq[(int, int)] =
  let height = m[x, y]
  if x > 0 and m[x-1, y] <= height + 1: result.add((x-1, y))
  if x < m.w-1 and m[x+1, y] <= height + 1: result.add((x+1, y))
  if y > 0 and m[x, y-1] <= height + 1: result.add((x, y-1))
  if y < m.h-1 and m[x, y+1] <= height + 1: result.add((x, y+1))

block loop:
  while true:
    let frontierCopy = frontier
    for i in frontierCopy:
      let (x, y) = i
      for j in adjacent(x, y):
        if cost[j] == 0 or cost[i] + 1 < cost[j]:
          cost[j] = cost[i] + 1
          if j == endpoint: break loop
          frontier.add(j)

echo "Part 1: ", cost[endpoint]

frontier = @[]
cost = Map(w: m.w, h: m.h, internal: newSeq[int](m.w * m.h))

frontier.add(endpoint)

proc reverseAdjacent(x, y: int): seq[(int, int)] =
  let height = m[x, y]
  if x > 0 and m[x-1, y] >= height - 1: result.add((x-1, y))
  if x < m.w-1 and m[x+1, y] >= height - 1: result.add((x+1, y))
  if y > 0 and m[x, y-1] >= height - 1: result.add((x, y-1))
  if y < m.h-1 and m[x, y+1] >= height - 1: result.add((x, y+1))

block loop:
  while true:
    let frontierCopy = frontier
    for i in frontierCopy:
      let (x, y) = i
      for j in reverseAdjacent(x, y):
        if cost[j] == 0 or cost[i] + 1 < cost[j]:
          cost[j] = cost[i] + 1
          if m[j] == 1:
            echo "Part 2: ", cost[j]
            break loop
          frontier.add(j)

import strscans, tables, intsets

const rowNum = 2000000
var
  sensors: Table[(int, int), (int, int)]
  radii: Table[(int, int), int]
  row: IntSet

let f = open("day15input.txt")

for l in f.lines:
  var x, y, bx, by: int
  if not scanf(l, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i",
               x, y, bx, by):
    raise newException(ValueError, "\"" & l & "\" is an invalid entry")

  sensors[(x, y)] = (bx, by)

for s, b in sensors: radii[s] = abs(s[0] - b[0]) + abs (s[1] - b[1])

for s, r in radii:
  let yDistance = abs(s[1] - rowNum)
  if yDistance <= r:
    for i in s[0] - r + yDistance..s[0] + r - yDistance: row.incl(i)

for b in sensors.values:
  if b[1] == rowNum: row.excl(b[0])

echo "Part 1: ", row.len

const maxXY = 4000000

var grid: array[maxXY+1, seq[int]]

for row in grid.mitems:
  row.add(maxXY+1)

# Ugly, but oh well
proc fill(row: var seq[int], start, `end`: int) =
  if row == @[0, maxXY + 1]: return
  var
    accum = 0
    sIndex, sSubindex, eIndex, eIndexRemaining = -1
  for i, n in row:
    if start < accum + n:
      sIndex = i
      sSubindex = start - accum
      break
    accum += n

  for i in sIndex..row.high:
    let n = row[i]
    if `end` < accum + n:
      eIndex = i
      eIndexRemaining = row[eIndex] - (`end` - accum + 1)
      break
    accum += n

  let width = `end` - start + 1
  if sIndex == -1:
    raise newException(ValueError, "Could not find " & $start & " in " & $row)
  elif eIndex == -1:
    raise newException(ValueError, "Could not find " & $`end` & " in " & $row)

  var
    splice = @[width]
    mergeLeft = false
    mergeRight = false
    
  # Even indices are empty, odd are filled
  if sIndex mod 2 == 1:
    splice[0] += sSubindex
    mergeLeft = true
  # Merge filled if possible
  elif sSubindex == 0 and sIndex > 1:
    sIndex -= 1
    splice[0] += row[sIndex]
    mergeLeft = true

  if eIndex mod 2 == 1:
    splice[0] += eIndexRemaining
    mergeRight = true
  elif eIndexRemaining == 0:
    if eIndex < row.high:
      eIndex += 1
      splice[0] += row[eIndex]
    mergeRight = true

  if not mergeLeft:
    splice.insert(sSubindex)
  if not mergeRight:
    splice.add(eIndexRemaining)

  row[sIndex..eIndex] = splice

for s, r in radii:
  for y in max(0, s[1] - r)..min(maxXY, s[1] + r):
    let yDistance = abs(s[1] - y)
    if yDistance <= r:
      grid[y].fill(max(0, s[0] - r + yDistance),
                   min(maxXY, s[0] + r - yDistance))

for y, row in grid:
  if row != @[0, maxXY + 1]:
    echo "Part 2: ", row[1] * 4000000 + y

import strutils 
import sequtils
import algorithm

var
  f = open("day5input.txt")
  crates: seq[seq[char]]

block populateCrates: 
  for line in f.lines:
    for i, c in line:
      if c.isDigit:
        crates.apply(proc(s: var seq[char]) = reverse(s))
        discard f.readLine
        break populateCrates

      if i mod 4 == 1:
        var stackIndex = i div 4
        if stackIndex > crates.high:
          crates.add(@[])
        if c.isAlphaAscii:
          crates[stackIndex].add(c)

var
  beforeRearrangement = f.getFilePos
  cratesCopy = crates

for line in f.lines:
  var
    lexemes = splitWhitespace(line)
    toBeMoved = parseInt(lexemes[1])
    source = parseInt(lexemes[3]) - 1
    target = parseInt(lexemes[5]) - 1
  for i in 1..toBeMoved:
    crates[target].add(crates[source].pop)

echo crates
echo "Part 1: ", crates.map(proc(s: seq[char]): char = s[^1]).join

f.setFilePos(beforeRearrangement)
crates = cratesCopy

for line in f.lines:
  var
    lexemes = splitWhitespace(line)
    toBeMoved = parseInt(lexemes[1])
    source = parseInt(lexemes[3]) - 1
    target = parseInt(lexemes[5]) - 1
  crates[target].add(crates[source][^toBeMoved..^1])
  crates[source][^toBeMoved..^1] = @[]

echo crates
echo "Part 2: ", crates.map(proc(s: seq[char]): char = s[^1]).join

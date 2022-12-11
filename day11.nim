import strscans, strutils, sequtils, sugar, algorithm, math

type
  Monkey = object
    inv: seq[int]
    op: proc(old: int): int
    divisible: int
    trueTarget: int
    falseTarget: int

var
  f = open("day11input.txt")
  monkeys: seq[Monkey]

proc intSeqMatcher(input: string, match: var seq[int], start: int): int =
  let last = input.find('\n', start)
  match = input[start..<last].split(", ").map(parseInt)
  result = last - start

proc opMatcher(input: string, match: var proc(old: int): int, start:int): int =
  let
    last = input.find('\n', start)
    tokens = input[start..<last].splitWhitespace
  proc op(old: int): int =
    case tokens[1]
      of "+": return old + tokens[2].parseInt
      of "*": return old * (if tokens[2] == "old": old else: tokens[2].parseInt)
  match = op
  result = last - start

while true:
  var
    m: Monkey
    throwaway: int

  let entry = collect(for i in 1..6: f.readLine).join("\n")

  if not scanf(entry, """
Monkey $i:
  Starting items: ${intSeqMatcher}
  Operation: new = ${opMatcher}
  Test: divisible by $i
    If true: throw to monkey $i
    If false: throw to monkey $i""", throwaway,
               m.inv, m.op, m.divisible, m.trueTarget, m.falseTarget):
    raise newException(ValueError, "Invalid Entry: " & entry)

  monkeys.add(m)
  try: f.readLine
  except EOFError: break

var
  inspections = repeat(0, monkeys.len)
  monkeysCopy = monkeys

for round in 1..20:
  for i, m in monkeys.mpairs:
    while m.inv.len > 0:
      inspections[i] += 1
      let item = m.op(m.inv[0]) div 3
      m.inv.delete(0)
      if item mod m.divisible == 0: monkeys[m.trueTarget].inv.add(item)
      else: monkeys[m.falseTarget].inv.add(item)

sort(inspections, Descending)
echo "Part 1: ", inspections[0] * inspections[1]

inspections = repeat(0, monkeys.len)
monkeys = monkeysCopy
let multiple = lcm(collect(for i in monkeys: i.divisible))

for round in 1..10000:
  for i, m in monkeys.mpairs:
    while m.inv.len > 0:
      inspections[i] += 1
      let item = m.op(m.inv[0]) mod multiple
      m.inv.delete(0)
      if item mod m.divisible == 0: monkeys[m.trueTarget].inv.add(item)
      else: monkeys[m.falseTarget].inv.add(item)

sort(inspections, Descending)
echo "Part 2: ", inspections[0] * inspections[1]

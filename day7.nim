import sequtils
import strutils
import strscans
import tables

type
  Dir = ref object
    files: Table[string, int]
    subdirs: Table[string, Dir]
    parent: Dir

proc `$`(dir: Dir): string =
  for name, size in dir.files:
    result &= $size & " " & name & "\n"
  for name, subdir in dir.subdirs:
    result &= name & "\n" & indent(($subdir).strip, 2) & "\n"
  result = result.strip

func dirSize(dir: Dir): int =
  for size in dir.files.values:
    result += size
  for i in dir.subdirs.values:
    result += dirSize(i)

func recursiveSubdirs(dir: Dir): seq[Dir] =
  result = dir.subdirs.values.toSeq
  for i in dir.subdirs.values:
    result &= i.recursiveSubdirs

var
  f = open("day7input.txt")
  root = Dir()
  current = root

discard f.readLine # skip "$ cd /"

for l in f.lines:
  if l == "$ ls":
    discard
  elif l == "$ cd ..":
    current = current.parent
  elif l[0..3] == "$ cd":
    current = current.subdirs[l[5..^1]]
  let
    (matchesFile, fileSize, fileName) = scanTuple(l, "$i $+")
    (matchesDir, dirName) = scanTuple(l, "dir $w")
  if matchesFile and fileName notin current.files:
    current.files[fileName] = fileSize
  elif matchesDir and dirName notin current.subdirs:
    current.subdirs[dirName] = Dir(parent: current)

let 
  allSubdirs = root.recursiveSubdirs
  allSizes = allSubdirs.map(dirSize)

var smallDirsSize = 0
for size in allSizes:
  if size <= 100000:
    smallDirsSize += size

echo "Part 1: ", smallDirsSize

let targetFreed = 30000000 - (70000000 - root.dirSize)

var currentSmallest = 99999999999999
for size in allSizes:
  if size >= targetFreed and size < currentSmallest:
    currentSmallest = size

echo "Part 2: ", currentSmallest

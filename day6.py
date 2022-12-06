with open("day6input.txt") as f:
    prev = f.read(4)
    while len(set(prev)) != 4:
        prev = prev[1:4] + f.read(1)

    print("Part 1:", f.tell())

    f.seek(0)

    prev = f.read(14)
    while len(set(prev)) != 14:
        prev = prev[1:14] + f.read(1)

    print("Part 2:", f.tell())

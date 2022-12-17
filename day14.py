from itertools import pairwise, product

with open("day14input.txt") as f:
    cave = {}
    
    for line in f:
        for pair in pairwise(tuple(int(j) for j in i.split(","))
                             for i in line.split(" -> ")):
            match pair:
                # Vertical
                case (x1, y1), (x2, y2) if x1 == x2:
                    if y1 < y2:
                        for y in range(y1, y2 + 1): cave[x1, y] = "#"
                    else:
                        for y in range(y1, y2 - 1, -1): cave[x1, y] = "#"
                # Horizontal
                case (x1, y1), (x2, y2) if y1 == y2:
                    if x1 < x2:
                        for x in range(x1, x2 + 1): cave[x, y1] = "#"
                    else:
                        for x in range(x1, x2 - 1, -1): cave[x, y1] = "#"
                case _:
                    raise ValueError(f"{pair} does not form a line")

    grains = 0
    while True:
        grainX, grainY = 500, 0
        try:
            while True:
                if (grainX, grainY + 1) not in cave:
                    grainY = sorted(y for x, y in cave
                                    if grainX == x and grainY < y)[0] - 1
                elif (grainX - 1, grainY + 1) not in cave:
                    grainX -= 1
                    grainY +=1
                elif (grainX + 1, grainY + 1) not in cave:
                    grainX += 1
                    grainY +=1
                else:
                    grains += 1
                    cave[grainX, grainY] = "o"
                    break

        except IndexError:
            break

    print("Part 1:", grains)
                
    yOnFloor = max(y for x, y in cave) + 1 # Y level directly above the floor
    while (500, 0) not in cave:
        grainX, grainY = 500, 0
        while True:
            if (grainX, grainY + 1) not in cave:
                try:
                    grainY = sorted(y for x, y in cave
                                    if grainX == x and grainY < y)[0] - 1
                except IndexError:
                    grains += 1
                    cave[grainX, yOnFloor] = "o"
                    break
            elif (grainX - 1, grainY + 1) not in cave:
                grainX -= 1
                grainY +=1
            elif (grainX + 1, grainY + 1) not in cave:
                grainX += 1
                grainY +=1
            else:
                grains += 1
                cave[grainX, grainY] = "o"
                break

    print("Part 2:", grains)

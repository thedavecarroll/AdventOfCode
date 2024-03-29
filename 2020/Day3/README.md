# --- Day 3: Toboggan Trajectory ---

## PowerShell Learning

Since `Get-Content` automatically reads the file into an array of strings (each line),
without the `-Raw` switch, you can easily iterate through each line in a `foreach`, `for`, `ForEach-Object` loop.

To ensure that we have a wide enough "map", we first need to multiply the line.
The type accelerator allows use to use a static method, [Math]::Ceiling, to get
the highest number for the multiplier.

Since the path is 3 right, 1 down, we can use the natural iteration for the `foreach` loop which is a step of 1.

`Regex` again is your friend in this puzzle
You can use the Index property from the `System.Text.RegularExpressions.Match` to quickly identify
the location of all trees.

```powershell
$HorizontalLine = '...........##....#......#..#..#'
$TreeLocation = [regex]::Matches($HorizontalLine,'#').Index
```

```text
11
12
17
24
27
30
```

For part 2, the loop had to be changed, as at least 1 path involved a different step value.

Since we were given multiple paths down the slope, I chose to put those settings into a `[hashtable]`.
I also included a value for trees encountered that I could increment directly and not have to deal with another variable.

```powershell
$SlopePaths = [ordered]@{
    Path1 = [ordered]@{ Right = 1; Down = 1; Trees = 0}
    Path2 = [ordered]@{ Right = 3; Down = 1; Trees = 0}
    Path3 = [ordered]@{ Right = 5; Down = 1; Trees = 0}
    Path4 = [ordered]@{ Right = 7; Down = 1; Trees = 0}
    Path5 = [ordered]@{ Right = 1; Down = 2; Trees = 0}
}
```

I used the Down value for each path as the step value, `for ($p=0;$p -lt $Map.Length;$p = $p + $SlopePaths[$SlopePath].Down)`.

> I struggled with this initially. But when I came back to it the following day, I managed to solve it.

## --- Part One ---

With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

```text
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
```

These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

```text
..##.........##.........##.........##.........##.........##.......  --->
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
```

You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

```text
..##.........##.........##.........##.........##.........##.......  --->
#..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........X.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...#X....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
```

In this example, traversing the map using this slope would cause you to encounter 7 trees.

Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?

Your puzzle answer was `171`.

## --- Part Two ---

Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.

In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?

Your puzzle answer was `1206576000`.

```text
Path1 : @{Right=1; Down=1; Trees=70}
Path2 : @{Right=3; Down=1; Trees=171}
Path3 : @{Right=5; Down=1; Trees=48}
Path4 : @{Right=7; Down=1; Trees=60}
Path5 : @{Right=1; Down=2; Trees=35}

Result 1206576000
```

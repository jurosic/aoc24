import java.io.File

data class Antenna(val x: Int, val y: Int, val frequency: Char)

fun main() {
    val fileName = "8.txt"
    val lines: List<String> = File(fileName).readLines()
    val antennas = mutableListOf<Antenna>()

    for (y in lines.indices) {
        for (x in lines[y].indices) {
            val char = lines[y][x]
            if (char != '.') {
                antennas.add(Antenna(x, y, char))
            }
        }
    }

    val antinodes = mutableSetOf<Pair<Int, Int>>()

    for (i in antennas.indices) {
        for (j in i + 1 until antennas.size) {
            val a1 = antennas[i]
            val a2 = antennas[j]
            if (a1.frequency == a2.frequency) {
                val dx = a2.x - a1.x
                val dy = a2.y - a1.y
                val antinode1 = Pair(a1.x - dx, a1.y - dy)
                val antinode2 = Pair(a2.x + dx, a2.y + dy)
                if (isWithinBounds(lines, antinode1)) {
                    antinodes.add(antinode1)
                }
                if (isWithinBounds(lines, antinode2)) {
                    antinodes.add(antinode2)
                }
            }
        }
    }

    //create a visual representation of the map
    val map = lines.toMutableList()
    for (antinode in antinodes) {
        val (x, y) = antinode
        map[y] = map[y].replaceRange(x, x + 1, "X")
    }

    map.forEach { println(it) }


    println("${antinodes.size}")
}

fun isWithinBounds(lines: List<String>, antinode: Pair<Int, Int>): Boolean {
    val (x, y) = antinode
    return x in lines[0].indices && y in lines.indices
}
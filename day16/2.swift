import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
    let direction: Int
}

struct PriorityQueue<Element> {
    private var elements: [Element]
    private let sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool) {
        self.elements = []
        self.sort = sort
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        elements.sort(by: sort)
    }
    
    mutating func dequeue() -> Element? {
        if isEmpty {
            return nil
        } else {
            return elements.removeFirst()
        }
    }
}

let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
let rotationCost = 1000
let movementCost = 1

func readFile(_ filename: String) -> String? {
    do {
        let contents = try String(contentsOfFile: filename)
        return contents
    } catch {
        print("Failed to read file")
        return nil
    }
}

func findStartAndEnd(_ maze: [[Character]]) -> (Position, Position)? {
    var start: Position?
    var end: Position?
    for (y, row) in maze.enumerated() {
        for (x, char) in row.enumerated() {
            if char == "S" {
                start = Position(x: x, y: y, direction: 0) // Start facing East
            } else if char == "E" {
                end = Position(x: x, y: y, direction: 0) // Direction doesn't matter for end
            }
        }
    }
    if let start = start, let end = end {
        return (start, end)
    }
    return nil
}

func manhattan(_ a: Position, _ b: Position) -> Int {
    return abs(a.x - b.x) + abs(a.y - b.y)
}

func aStar(_ maze: [[Character]], start: Position, end: Position, maxCost: Int) -> (Int, [Position]) {
    var openSet = PriorityQueue<(Position, Int)>(sort: { $0.1 < $1.1 })
    var gScore = [Position: Int]()
    var fScore = [Position: Int]()
    var cameFrom = [Position: Position]()
    var visited = Set<Position>()
    
    gScore[start] = 0
    fScore[start] = manhattan(start, end)
    openSet.enqueue((start, fScore[start]!))
    
    while let (current, _) = openSet.dequeue() {
        if gScore[current]! > maxCost {
            return (Int.max, [])
        }
        
        if current.x == end.x && current.y == end.y {
            var path = [current]
            var currentPos = current
            while let prev = cameFrom[currentPos] {
                path.append(prev)
                currentPos = prev
            }
            return (gScore[current]!, path.reversed())
        }
        
        visited.insert(current)
        
        let (dx, dy) = directions[current.direction]
        let newX = current.x + dx
        let newY = current.y + dy
        if maze[newY][newX] != "#" {
            let newPosition = Position(x: newX, y: newY, direction: current.direction)
            let tentativeGScore = gScore[current]! + movementCost
            if tentativeGScore < gScore[newPosition, default: Int.max] {
                cameFrom[newPosition] = current
                gScore[newPosition] = tentativeGScore
                fScore[newPosition] = tentativeGScore + manhattan(newPosition, end)
                if !visited.contains(newPosition) {
                    openSet.enqueue((newPosition, fScore[newPosition]!))
                }
            }
        }
        
        for i in [-1, 1] {
            let newDirection = (current.direction + i + 4) % 4
            let newPosition = Position(x: current.x, y: current.y, direction: newDirection)
            let tentativeGScore = gScore[current]! + rotationCost
            if tentativeGScore < gScore[newPosition, default: Int.max] {
                cameFrom[newPosition] = current
                gScore[newPosition] = tentativeGScore
                fScore[newPosition] = tentativeGScore + manhattan(newPosition, end)
                if !visited.contains(newPosition) {
                    openSet.enqueue((newPosition, fScore[newPosition]!))
                }
            }
        }
    }
    
    return (Int.max, [])
}

func findAllShortestPaths(_ maze: [[Character]], start: Position, end: Position) -> [[Position]] {
    var allPaths = [[Position]]()
    let (initialCost, initialPath) = aStar(maze, start: start, end: end, maxCost: Int.max)
    if initialCost == Int.max {
        return allPaths
    }
    allPaths.append(initialPath)
    
    var pathsToExplore = [(initialPath, Set<Position>())]
    var exploredPaths = Set<[Position]>()
    exploredPaths.insert(initialPath)
    
    while !pathsToExplore.isEmpty {
        print(pathsToExplore.count)
        let (path, barricades) = pathsToExplore.removeFirst()
        
        for position in path.reversed() {
            print(position)
            if barricades.contains(position) {
                continue
            }
            var mazeCopy = maze
            for barricade in barricades {
                mazeCopy[barricade.y][barricade.x] = "#"
            }
            mazeCopy[position.y][position.x] = "#"
            let (cost, newPath) = aStar(mazeCopy, start: start, end: end, maxCost: initialCost)
            if cost == initialCost && !exploredPaths.contains(newPath) {
                allPaths.append(newPath)
                var newBarricades = barricades
                newBarricades.insert(position)
                pathsToExplore.append((newPath, newBarricades))
                exploredPaths.insert(newPath)
            }
        }
    }
    
    return allPaths
}

func markBestPathTiles(_ maze: [[Character]], _ bestPaths: [[Position]]) -> [[Character]] {
    var markedMaze = maze
    for path in bestPaths {
        for position in path {
            if markedMaze[position.y][position.x] == "." {
                markedMaze[position.y][position.x] = "O"
            }
        }
    }
    return markedMaze
}

func main() {
    guard let input = readFile("16.txt") else { return }
    let maze = input.split(separator: "\n").map { Array($0) }
    
    guard let (start, end) = findStartAndEnd(maze) else {
        print("Start or end position not found")
        return
    }
    
    let allPaths = findAllShortestPaths(maze, start: start, end: end)
    let markedMaze = markBestPathTiles(maze, allPaths)
    
    for row in markedMaze {
        print(String(row))
    }
    
    var uniqueTiles = 0

    // Loop through markedMaze and count all O
    for row in markedMaze {
        for tile in row {
            if tile == "O" {
                uniqueTiles += 1
            }
            if tile == "E" {
                uniqueTiles += 1
            }
            if tile == "S" {
                uniqueTiles += 1
            }
        }
    }

    print("\(uniqueTiles)")
}

main()
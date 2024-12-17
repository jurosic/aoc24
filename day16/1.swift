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
                start = Position(x: x, y: y, direction: 1)
            } else if char == "E" {
                end = Position(x: x, y: y, direction: 0)
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

func aStar(_ maze: [[Character]], start: Position, end: Position) -> Int {
    var openSet = PriorityQueue<(Position, Int)>(sort: { $0.1 < $1.1 })
    var gScore = [Position: Int]()
    var fScore = [Position: Int]()
    var visited = Set<Position>()
    
    gScore[start] = 0
    fScore[start] = manhattan(start, end)
    openSet.enqueue((start, fScore[start]!))
    
    while let (current, _) = openSet.dequeue() {
        if current.x == end.x && current.y == end.y {
            return gScore[current]!
        }
        
        visited.insert(current)
        
        let (dx, dy) = directions[current.direction]
        let newX = current.x + dx
        let newY = current.y + dy
        if maze[newY][newX] != "#" {
            let newPosition = Position(x: newX, y: newY, direction: current.direction)
            let tentativeGScore = gScore[current]! + movementCost
            if tentativeGScore < gScore[newPosition, default: Int.max] {
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
                gScore[newPosition] = tentativeGScore
                fScore[newPosition] = tentativeGScore + manhattan(newPosition, end)
                if !visited.contains(newPosition) {
                    openSet.enqueue((newPosition, fScore[newPosition]!))
                }
            }
        }
    }
    
    return Int.max
}

func main() {
    guard let input = readFile("16.txt") else { return }
    let maze = input.split(separator: "\n").map { Array($0) }
    
    guard let (start, end) = findStartAndEnd(maze) else {
        print("Start or end position not found")
        return
    }
    
    let minCost = aStar(maze, start: start, end: end)
    print(minCost)
}

main()
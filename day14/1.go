package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

type Robot struct {
	x    int
	y    int
	velx int
	vely int
}

func main() {
	var TALL = 103
	var WIDE = 101

	file, err := os.Open("14.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	content, err := io.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}

	var robots []*Robot
	lines := strings.Split(string(content), "\n")
	for _, line := range lines {
		var x, y, velx, vely int
		_, err := fmt.Sscanf(line, "p=%d,%d v=%d,%d", &x, &y, &velx, &vely)
		if err != nil {
			log.Fatal(err)
		}
		robots = append(robots, &Robot{x, y, velx, vely})
	}

	simulate(robots, 100, TALL, WIDE)

	var quad = count_robots_in_all_quadrants(robots, TALL, WIDE)

	//multiply quad together
	fmt.Println(quad[0] * quad[1] * quad[2] * quad[3])
}

func simulate(robots []*Robot, seconds int, tall int, wide int) {
	for _, r := range robots {
		for i := 0; i < seconds; i++ {
			r.x += r.velx
			r.y += r.vely

			//wrap around
			if r.x < 0 {
				r.x += wide
			}
			if r.x >= wide {
				r.x -= wide
			}
			if r.y < 0 {
				r.y += tall
			}
			if r.y >= tall {
				r.y -= tall
			}
		}
	}
}

func count_robots_in_all_quadrants(robots []*Robot, tall int, wide int) [4]int {
	var count [4]int
	//count in all quadrants but ingnore the middle x and y
	for _, r := range robots {
		if r.x < wide/2 && r.y < tall/2 {
			count[0]++
		} else if r.x > wide/2 && r.y < tall/2 {
			count[1]++
		} else if r.x < wide/2 && r.y > tall/2 {
			count[2]++
		} else if r.x > wide/2 && r.y > tall/2 {
			count[3]++
		}
	}

	return count
}

func show_grid(robots []*Robot, tall int, wide int) {
	var grid = make([][]rune, tall)
	for i := range grid {
		grid[i] = make([]rune, wide)
		for j := range grid[i] {
			grid[i][j] = '.'
		}
	}

	for _, r := range robots {
		grid[r.y][r.x] = '#'
	}

	for i := range grid {
		for j := range grid[i] {
			fmt.Printf("%c", grid[i][j])
		}
		fmt.Println()
	}
}

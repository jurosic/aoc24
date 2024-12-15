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

	for i := 0; i < 100000; i++ {
		simulate(robots, 1, TALL, WIDE)
		if check_christmas_tree_arrangement(robots, TALL, WIDE) {
			show_grid(robots, TALL, WIDE)
			fmt.Println(i + 1)
			break
		}
	}
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

func check_christmas_tree_arrangement(robots []*Robot, tall int, wide int) bool {
	//check if no robots share the same tile
	for i := 0; i < len(robots); i++ {
		for j := i + 1; j < len(robots); j++ {
			if robots[i].x == robots[j].x && robots[i].y == robots[j].y {
				return false
			}
		}
	}
	return true
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

extern crate regex;

use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use regex::Regex;

pub fn pt1() -> io::Result<()> {
    let mut matches = 0;

    let file = File::open("4.txt")?;
    let reader = BufReader::new(file);

    let re = Regex::new(r"XMAS").unwrap();

    let grid: Vec<Vec<char>> = reader.lines()
        .map(|line| line.unwrap().chars().collect())
        .collect();

    //lines + rev lines

    for line in &grid {
        let line = line.iter().collect::<String>();
        matches += re.find_iter(&line).count();
        let rev_line = line.chars().rev().collect::<String>();
        matches += re.find_iter(&rev_line).count();
    }

    //cols + rev cols
    for i in 0..grid[0].len() {
        let mut line = String::new();

        for j in 0..grid.len() {
            line.push(grid[j][i]);
        }

        matches += re.find_iter(&line).count();
        let rev_line = line.chars().rev().collect::<String>();
        matches += re.find_iter(&rev_line).count();
    }

    //TL-BT diagonals + rev
    matches += count_diagonal_matches(&grid, &re);

    //TR-BL diagonals + rev
    let mut rev_grid = grid.clone();
    for line in &mut rev_grid {
        line.reverse();
    }
    
    matches += count_diagonal_matches(&rev_grid, &re);

    println!("pt1: {}", matches);

    Ok(())
}

fn count_diagonal_matches(grid: &[Vec<char>], re: &Regex) -> usize {
    let mut matches = 0;
    let rows = grid.len();
    let cols = grid[0].len();

    for i in (0..rows).rev() {
        let mut j = 0;
        let mut k = i;

        while k < rows {
            let mut line = String::new();

            while j < cols && k < rows {
                line.push(grid[k][j]);
                j += 1;
                k += 1;
            }

            matches += re.find_iter(&line).count();

            let rev_string = line.chars().rev().collect::<String>();

            matches += re.find_iter(&rev_string).count();
        }
    }

    //loop diagonally from top left
    for i in 1..cols {
        let mut j = i;
        let mut k = 0;

        while j < cols {
            let mut line = String::new();

            while j < cols && k < rows {
                line.push(grid[k][j]);
                j += 1;
                k += 1;
            }

            matches += re.find_iter(&line).count();

            let rev_string = line.chars().rev().collect::<String>();

            matches += re.find_iter(&rev_string).count();
        }
    }

    matches
}
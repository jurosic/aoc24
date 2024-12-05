extern crate regex;

use std::fs::File;
use std::io::{self, prelude::*, BufReader};

pub fn pt2() -> io::Result<()> {
    let mut matches = 0;

    let file = File::open("4.txt")?;
    let reader = BufReader::new(file);

    let grid: Vec<Vec<char>> = reader.lines()
    .map(|line| line.unwrap().chars().collect())
    .collect();

    matches += check_for_mas(&grid);

    println!("pt2: {}", matches);

    Ok(())
}

fn check_for_mas(grid: &[Vec<char>]) -> usize {
    let mut matches = 0;
    let rows = grid.len();
    let cols = grid[0].len();



    for i in 0..rows {
        for j in 0..cols {
            if grid[i][j] == 'A' {
                //check if up-left and up-right are M
                if i > 0 && j > 0 && j < cols - 1 {
                    if grid[i - 1][j - 1] == 'M' && grid[i - 1][j + 1] == 'M' {
                        //check if down-left and down-right are S
                        if i < rows - 1 && j > 0 && j < cols - 1 {
                            if grid[i + 1][j - 1] == 'S' && grid[i + 1][j + 1] == 'S' {
                                matches += 1;
                            }
                        }
                    }
                }
                //check if left-up and left-down are M
                if j > 0 && i > 0 && i < rows - 1 {
                    if grid[i - 1][j - 1] == 'M' && grid[i + 1][j - 1] == 'M' {
                        //check if right-up and right-down are S
                        if j < cols - 1 && i > 0 && i < rows - 1 {
                            if grid[i - 1][j + 1] == 'S' && grid[i + 1][j + 1] == 'S' {
                                matches += 1;
                            }
                        }
                    }
                }
                //check if left-down and right-down are M
                if i < rows - 1 && j > 0 && j < cols - 1 {
                    if grid[i + 1][j - 1] == 'M' && grid[i + 1][j + 1] == 'M' {
                        //check if up-left and up-right are S
                        if i > 0 && j > 0 && j < cols - 1 {
                            if grid[i - 1][j - 1] == 'S' && grid[i - 1][j + 1] == 'S' {
                                matches += 1;
                            }
                        }
                    }
                }
                //check if down-right and up-right are M
                if j < cols - 1 && i > 0 && i < rows - 1 {
                    if grid[i - 1][j + 1] == 'M' && grid[i + 1][j + 1] == 'M' {
                        //check if down-left and up-left are S
                        if j > 0 && i > 0 && i < rows - 1 {
                            if grid[i - 1][j - 1] == 'S' && grid[i + 1][j - 1] == 'S' {
                                matches += 1;
                            }
                        }
                    }
                }


            }
        }
    }
    matches 
}

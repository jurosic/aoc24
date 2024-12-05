extern crate regex;

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use regex::Regex;

fn main() {
    let file = File::open("4.txt");

    let file = match file {
        Ok(file) => file,
        Err(error) => {
            eprintln!("Error opening file: {}", error);
            return;
        }
    };

    let reader = BufReader::new(file);
    let re = Regex::new(r"XMAS").unwrap();

    let matches = 0;

    for line in reader.lines() {
        match line {
            Ok(line) => {
                matches += re.find_iter(&line).count();
            },
            Err(error) => eprintln!("Error reading line: {}", error),
        }
    }

    println!("Matches: {}", matches);
}
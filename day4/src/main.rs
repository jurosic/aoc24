extern crate regex;

mod pt1;
mod pt2;

use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use regex::Regex;

fn main() -> io::Result<()> {
    pt1::pt1()?;
    pt2::pt2()?;

    Ok(())
}
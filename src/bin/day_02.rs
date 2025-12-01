use std::fs::File;
use std::io::{self, BufRead};


#[derive(Debug)]
struct Part1;

#[derive(Debug)]
struct Part2;

fn main() {
    let answer = part_1().unwrap();
    println!("Part 1: {:?}", answer);

    let answer = part_2().unwrap();
    println!("Part 2: {:?}", answer);

}

fn part_1() -> Result<Part1, Box<dyn std::error::Error>> {
    let input = File::open("input/day_02/part_01.txt")?;
    let reader = io::BufReader::new(input);
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
    }
    todo!();
}

fn part_2() -> Result<Part2, Box<dyn std::error::Error>> {
    let input = File::open("input/day_02/part_02.txt")?;
    let reader = io::BufReader::new(input);
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
    }
    todo!();
}
